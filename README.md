# Create ansible Infrastructure with docker using Ubuntu
Prerequisites: Docker, Ansible on Windows 10+ WSL2 or Linux with Ansible and Docker insatlled 

To insatll WSL, please follow Microsoft guide at https://docs.microsoft.com/en-us/windows/wsl/install

Docker Instruction can be found here:
`curl -fsSL https://get.docker.com -o get-docker.sh
 sudo sh get-docker.sh`
 
 ## Using createinfra.sh on Windows and WSL (Ubuntu 20.4 is used here):
 1. Clone the repo
 2. Ensure the script has execution permission set for the user. if it's not set, set it using `sudo chmod u+x createinfra.sh`
 3. Install Ansible on WSL using `sudo apt get install ansible`
 4. Install docker
 5. Add the logged in user to the docker group using `sudo usermod -aG docker $USER`
 6. To create the infrastructure, run ./createinfra.sh -create x where x is the number of containers you want created
 7. After creating the infrastructure, the script will create a playbooks directory with the inventory file `inventory`
 8. To verify the created invenory, run `ansible all -i playbooks/inventory -m ping`
 9. To delete the created inventory and start fresh, run `./createinfra.sh -delete` the delete the playbooks directory using `rm -rf playbooks`

## using createinfra.sh on Linux:
1. Install Ansible 
2. Install docker 
3. add the current logged user to docker group `sudo usermod -aG docker $USER`
4. clone the repo 
5. Set execution permission on createinfra.sh `sudo chmod u+x createinfra.sh`
6. Excute the script and create containers using `./createingfra.sh -create 5` 

#Note: This script assumes the logged in user is a member of the docker group. to add the user, use `sudo usermod -aG docker $USER`

To run the one or more of the containers manually, run the following

`docker run -rm -tid --cap-add NET_ADMIN --cap-add SYS_ADMIN --publish-all=true -v /srv/data:/srv/html -v /sys/fs/cgroup:/sys/fs/cgroup:ro --name {REPLACE_WITH_CONTAINER_NAME} -h {REPLACE_WITH_CONTAINER_NAME} sageil/ansible-env`

![image](https://user-images.githubusercontent.com/67704508/174484474-b3f6b879-5e1e-4349-83dd-acfc87564802.png)
