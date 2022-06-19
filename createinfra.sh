#!/bin/bash

help(){
echo "

Options :
                 -create : launch some containers (specify the number of containers to be created)

                 -delete : remove all containers started by the script

                 -info : list containers names and ip addresses

                 -start : restart all container created by the script. This is needed if machine wheree the script is executed gets rebooted

                 -ansible : to re-create the inventory with ip of each container

"

}

check_ssh_key(){
SSHFILE=$HOME/.ssh/ansible-dev
    if [ ! -f "$SSHFILE" ]; then
        echo "y" | ssh-keygen -t rsa -C "My ansible dev Key" -f ~/.ssh/ansible-dev -N ""
    fi
}
create_nodes() {
        # set number of containers
        total_containers=1
        [ "$1" != "" ] && total_containers=$1
        # setting min/max
        min=1
        max=0

        # if you have already created some container - start from the last id
        idmax=`docker ps -a --format '{{ .Names}}' | awk -F "-" -v user="$USER" '$0 ~ user"-ansible" {print $3}' | sort -r |head -1`
        # set new idmin and max from the last idmax
        min=$(($idmax + 1))
        max=$(($idmax + $total_containers))

        # run containers
        for i in $(seq $min $max);do
                docker run -tid --privileged --publish-all=true -v /srv/data:/srv/html -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name $USER-ansible-$i -h $USER-ansible-$i sageil/ansible-env
                docker exec -ti $USER-ansible-$i /bin/sh -c "useradd -m -p sa3tHJ3/KuYvI $USER"
                docker exec -ti $USER-ansible-$i /bin/sh -c "mkdir  ${HOME}/.ssh && chmod 700 ${HOME}/.ssh && chown $USER:$USER $HOME/.ssh"
        docker cp $HOME/.ssh/ansible-dev.pub $USER-ansible-$i:$HOME/.ssh/authorized_keys
        docker exec -ti $USER-ansible-$i /bin/sh -c "chmod 600 ${HOME}/.ssh/authorized_keys && chown $USER:$USER $HOME/.ssh/authorized_keys"
                docker exec -ti $USER-ansible-$i /bin/sh -c "echo '$USER   ALL=(ALL) NOPASSWD: ALL'>>/etc/sudoers"
                docker exec -ti $USER-ansible-$i /bin/sh -c "service ssh start"
                echo "Containers $USER-ansible-$i created"
        done
        nodes_info

}

delete_nodes(){
        echo "Deleting containers..."
        docker rm -f $(docker ps -a | grep $USER-ansible | awk '{print $1}')
        echo "Done!"
}

start_nodes(){
        echo ""
        docker start $(docker ps -a | grep $USER-ansible | awk '{print $1}')
  for container in $(docker ps -a | grep $USER-ansible | awk '{print $1}');do
                docker exec -ti $container /bin/sh -c "service ssh start"
  done
        echo ""
}


prepare_ansible_structure(){
        echo ""
        PLAYBOOKS_DIR="playbooks"
        mkdir -p $PLAYBOOKS_DIR
        echo "[all]" > $PLAYBOOKS_DIR/00_inventory
         for container in $(docker ps -a | grep $USER-ansible | awk '{print $1}');do
    docker inspect -f '{{.NetworkSettings.IPAddress }}' $container >> $PLAYBOOKS_DIR/00_inventory
  done
  mkdir -p $PLAYBOOKS_DIR/host_vars
  mkdir -p $PLAYBOOKS_DIR/group_vars
        echo ""
}

nodes_info(){
        echo ""
        echo "List of IP Addresses : "
        echo ""
        for container in $(docker ps -a | grep $USER-ansible | awk '{print $1}');do
                docker inspect -f '   => {{.Name}} - {{.NetworkSettings.IPAddress }}' $container
        done
        echo ""
}



# Let's Go !!! ###################################################################""
check_ssh_key
# option --create
if [ "$1" == "-create" ];then
        create_nodes $2
        prepare_ansible_structure

# option --drop
elif [ "$1" == "-delete" ];then
        delete_nodes

# option --start
elif [ "$1" == "-start" ];then
        start_nodes

# option --ansible
elif [ "$1" == "-ansible" ];then
        prepare_ansible_structure

# option --infos
elif [ "$1" == "-info" ];then
        nodes_info

# if nothing show help
else
        help

fi
