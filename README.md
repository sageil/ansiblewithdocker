# ansiblewithdocker
To verfiy your setup after creating the infrastructure using createinfra.sh, use the following command to test the connection.
`ansible all -i playbooks/00_inventory -m ping`
To run the one or more of the containers manually, run the following

`docker run -rm -tid --cap-add NET_ADMIN --cap-add SYS_ADMIN --publish-all=true -v /srv/data:/srv/html -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name {REPLACE_WITH_CONTAINER_NAME} -h {REPLACE_WITH_CONTAINER_NAME} sageil/ansible-env`

