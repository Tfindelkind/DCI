# DCI
Deploy Cloud Image - bash scripts which generates Cloud-Init meta-data and user-data to deploy cloud images

It makes use of recipes which are defined before used. The recipes are simple text files right now because they are easy to use and enable me to reduce the overhead in the beginning. This may change in the future.

# Installing

make sure genisoimage and git is installed (Ubuntu)

sudo apt-get install genisoimage

sudo apt-get install git

git clone https://github.com/Tfindelkind/DCI

Prebuild recipes:

1. NTNX-AVM - The Nutanix Automation VM is a cloud image based on Centos 7 with a fixed IP and ready to use for scripting 
2. NTNX-AVM-UBUNTU -The Nutanix Automation VM is a cloud image based on Ubuntu with a fixed IP and ready to use for scripting 

# Usage

Change the config files for your needs ->  /recipes/NTNX-AVM/config to set IP, Nameserver etc.

./create_data_files --list        -> will list all valid recipes

./create_data_files --recipe NTNX-AVM  -> will create seed.iso for the Nutanix Automation VM based on Centos 7   


# Future
In the future this bash script should deploy the cloud images directly to a cloud platform like Nutanix, AWS, Azure, VMware, and so on. This may be difficult because bash may be not the best scripting language for this task.
