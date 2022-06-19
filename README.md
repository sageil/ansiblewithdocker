# Create ansible Infrastructure with docker using Ubuntu
Prerequisites: Docker on WSL2 
To insatll WSL, please follow Microsoft guide at https://docs.microsoft.com/en-us/windows/wsl/install
Docker Instruction can be found here:
`curl -fsSL https://get.docker.com -o get-docker.sh
 sudo sh get-docker.sh`
 Using createinfra.sh:
 1. Ensure the script has execution permission set for the user. if it's not set, set it using `sudo chmod u+x createinfra.sh`
 2. To create the infrastructure, run ./createinfra.sh -create x where x is the number of containers you want created
 3. After creating the infrastructure, the script will create a playbooks directory with the inventory file `inventory`
 4. to verify the created invenory, run `ansible all -i playbooks/inventory -m ping`
 5. To delete the created inventory and start fresh, run `./createinfra.sh -delete` the delete the playbooks directory using `rm -rf playbooks`

To run the one or more of the containers manually, run the following

`docker run -rm -tid --cap-add NET_ADMIN --cap-add SYS_ADMIN --publish-all=true -v /srv/data:/srv/html -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name {REPLACE_WITH_CONTAINER_NAME} -h {REPLACE_WITH_CONTAINER_NAME} sageil/ansible-env`

