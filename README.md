# DCI
Deploy Cloud Image - bash script which deploys cloud images to a Nutanix cluster based on recipes 

It makes use of recipes which are pre-defined. The recipes are simple text files residing in /recipes folder
MAKE sure you edit the config file with your seetings IP/DNS/USER/PASSWORD...

# Installing

Supported OSes:  UBUNTU / DEBIAN / MAC OS / REDHAT / CENTOS

Download the source code tar.gz file from latest stable release 

unpack the files example:

# tar -xvzf DCI-1.0-stable.tar.gz

# Dependencies

DCI will download the cloud image which is specified in the recipes.
DCI makes use of genisoiamge/mkisofs and tries to install it if not installed.
DCI makes use of github.com/Tfindelkind/automation/deploy_cloud_vm and tries to install it if not installed.

Prebuild recipes:

1. NTNX-AVM - The Nutanix Automation VM is a cloud image based on Centos7/Ubuntu and ready to use for automation
2. DOCKER   - The Docker VM is based on Ubuntu cloud image

# Usage

Change the config files for your needs ->  "/recipes/NTNX-AVM/v1/CentOS7/config" to set IP, Nameserver etc.

./dci.sh --list        -> will list all valid recipes

Example:

./dci.sh --recipe=NTNX-AVM --rv=v1 --ros=CentOS7 --host=192.168.178.130 --username=admin --password=nutanix/4u --container=prod --vlan=VLAN0 --vm-name=NTNX-AVM


# Future
In the future this bash script should deploy the cloud images directly to different cloud platforms like AWS, Azure, VMware, and so on.
