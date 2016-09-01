#!/bin/bash
#
# Copyright (c) 2016 Thomas Findelkind
#
# This program is free software: you can redistribute it and/or modify it under
# the terms of the GNU General Public License as published by the Free Software
# Foundation, either version 3 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program.  If not, see <http://www.gnu.org/licenses/>.
#
# MORE ABOUT THIS SCRIPT AVAILABLE IN THE README AND AT:
#
# http://tfindelkind.com
#
# ---------------------------------------------------------------------------- #

LOGDIR=""
RECIPE_FOLDER="recipes"
RECIPE_CONFIG=""
RECIPE_PATH=""
RECIPE=0
RECIPE_VERSION_FOLDER=0
RECIPE_OS_FOLDER=0
RECIPE_DESC=0
IMAGE_FOLDER="images"
AppVersion="0.9 beta"
VALID_RECIPE=0
HELP=0
LIST=0
VERSION=0
HOST=0
USERNAME=0
PASSWORD=0
VMNAME=0
CONTAINER=0
VLAN=0

setRecipe_Config()
{
 RECIPE_CONFIG="$RECIPE_PATH/config"
}

setRecipePath()
{
 RECIPE_PATH="./$RECIPE_FOLDER/$RECIPE/$RECIPE_VERSION_FOLDER/$RECIPE_OS_FOLDER"
}

check_all_valid_recipe()
{
	while read recipes_ls
	do
	 while read version_ls
	  do
			while read os_ls
			 do
				 VALID_RECIPE=0
				 RECIPE=$recipes_ls
				 RECIPE_VERSION_FOLDER=$version_ls
				 RECIPE_OS_FOLDER=$os_ls
				 setRecipePath
				 setRecipe_Config
 				 check_valid_recipe
 				 if [ $VALID_RECIPE = 1 ]; then
 				  echo "--recipe=$RECIPE --rv=$RECIPE_VERSION_FOLDER --ros=$RECIPE_OS_FOLDER"
 				 fi
			done < <(ls $RECIPE_FOLDER/$recipes_ls/$version_ls)
	  done < <(ls $RECIPE_FOLDER/$recipes_ls)
	done < <(ls $RECIPE_FOLDER)
}

check_valid_recipe()
{
   # does the file exist?
   if [ -f "$RECIPE_CONFIG" ]; then
	# read config file (key/values) into two array
	keys=()
	values=()
	while IFS='=' read -r key value
	do
		keys+=("$key")
		# remove the quotes when adding
		values+=("${value//\"}")
	done < "$RECIPE_CONFIG"



	#the first key needs to be "name", the value needs to be the same then the used $RECIPE
	if [ ${keys[0]} = "name" ]; then
		if [ ${values[0]} = $RECIPE ]; then
		   VALID_RECIPE=1
			 RECIPE_DESC=${values[1]}
		fi
	fi
   fi
}

create_userdata()
{
	if [ -f "$RECIPE_CONFIG" ]; then
	# read config file (key/values) into two array
	keys=()
	values=()
	while IFS='=' read -r key value
	do
		keys+=("$key")
		# remove the quotes when adding
		values+=("${value//\"}")
	done < "$RECIPE_CONFIG"

	cp "$RECIPE_PATH/user-data.template" "$RECIPE_PATH/user-data"

	# Replace all variables
	for((i=4;i<${#keys[@]};i++))
	do
	    if [ $os == "debian" ] || [ $os == "redhat" ]; then
		   sed -i "s/${keys[i]}/${values[i]}/g" "$RECIPE_PATH/user-data"
		fi
		if [ $os == "mac" ]; then
		   sed -i '' "s/${keys[i]}/${values[i]}/g" "$RECIPE_PATH/user-data"
		fi
	done
  fi
}

create_metadata()
{
	if [ -f "$RECIPE_CONFIG" ]; then
	# read config file (key/values) into two array
	keys=()
	values=()
	while IFS='=' read -r key value
	do
		keys+=("$key")
		# remove the quotes when adding
		values+=("${value//\"}")
	done < "$RECIPE_CONFIG"

	cp "$RECIPE_PATH/meta-data.template" "$RECIPE_PATH/meta-data"

	# Replace all variables
	for((i=4;i<${#keys[@]};i++))
	do
		if [ $os == "debian" ] || [ $os == "redhat" ]; then
		 sed -i "s/${keys[i]}/${values[i]}/g" "$RECIPE_PATH/meta-data"
		fi
		if [ $os == "mac" ]; then
		 sed -i '' "s/${keys[i]}/${values[i]}/g" "$RECIPE_PATH/meta-data"
		fi
	done
  fi
}

download_cloud_image()
{
	if [ -f "$RECIPE_CONFIG" ]; then
	# read config file (key/values) into two array
	keys=()
	values=()
	while IFS='=' read -r key value
	do
		keys+=("$key")
		# remove the quotes when adding
		values+=("${value//\"}")
	done < $RECIPE_CONFIG


	# if url set download with curl
	for((i=0;i<${#keys[@]}-1;i++))
	do
		if [ ${keys[i]} = "cloud_image" ]; then
			cloud_image=${values[i]}
		fi
		if [ ${keys[i]} = "cloud_image_download" ]; then

		 if [ ! -d "./$IMAGE_FOLDER" ]; then
		  mkdir ./$IMAGE_FOLDER
		 fi
		 if [ ! -f "./$IMAGE_FOLDER/$cloud_image" ]; then
		  curl -L "${values[i]}" >> ./$IMAGE_FOLDER/$cloud_image
		 fi
		fi
	done
  fi

}

printHelp()
{
cat << EOF
  USAGE:
    dci.sh [options] [value]
    change config file for personal settings like IP,Name...

  Options:
    --recipe  		specifies the recipe
		--rv				  spefifies the recipe version
		--ros 				specifies the recipe OS
    --list    		list all available recipes
    --host
    --username
    --password
    --vm-name
    --container
    --vlan
    --help
    --version
EOF
}

## MAIN block-------------------------------------------------------------

# retrieve os
case $OSTYPE in
	darwin* )
		os="mac" ;;
	linux* )
		if [ -f "/etc/redhat-release" ]; then os="redhat"; fi
		if [ -f "/etc/debian_version" ]; then os="debian"; fi
		;;
esac

##
for i in "$@"
do
case $i in
    --recipe=*)
    RECIPE="${i#*=}"
    shift # past argument=value
    ;;
		--rv=*)
    RECIPE_VERSION_FOLDER="${i#*=}"
    shift # past argument=value
    ;;
		--ros=*)
    RECIPE_OS_FOLDER="${i#*=}"
    shift # past argument=value
    ;;
    --list)
    LIST=1
    shift # past argument=value
    ;;
    --host=*)
    HOST="${i#*=}"
    shift # past argument=value
    ;;
    --username=*)
    USERNAME="${i#*=}"
    shift # past argument=value
    ;;
    --password=*)
    PASSWORD="${i#*=}"
    shift # past argument=value
    ;;
    --vm-name=*)
    VMNAME="${i#*=}"
    shift # past argument=value
    ;;
    --container=*)
    CONTAINER="${i#*=}"
    shift # past argument=value
    ;;
    --vlan=*)
    VLAN="${i#*=}"
    shift # past argument=value
    ;;
    --help)
    HELP=1
    shift # past argument=value
    ;;
    --version)
    VERSION=1
    shift # past argument=value
    ;;
esac
done


if [ $VERSION = 1 ]; then
 echo $AppVersion
 exit
fi

if [ $HELP = 1 ]; then
 printHelp
 exit
fi

if [ $LIST = 1 ]; then
 check_all_valid_recipe
 exit
fi

if [ $RECIPE = 0 ]; then
 echo "--recipe is mandatory"
 exit
fi

if [ $RECIPE_VERSION_FOLDER = 0 ]; then
 echo "--rv is mandatory"
 exit
fi

if [ $RECIPE_OS_FOLDER = 0 ]; then
 echo "--ros is mandatory"
 exit
fi

if [ $HOST = 0 ]; then
 echo "--host is mandatory"
 exit
fi

if [ $USERNAME = 0 ]; then
 echo "--username is mandatory"
 exit
fi

if [ $PASSWORD = 0 ]; then
 echo "--password is mandatory"
 exit
fi

if [ $VMNAME = 0 ]; then
 echo "--vm-name is mandatory"
 exit
fi

if [ $CONTAINER = 0 ]; then
 echo "--container is mandatory"
 exit
fi

if [ $VLAN = 0 ]; then
 echo "--vlan is mandatory"
 exit
fi

setRecipePath
setRecipe_Config

check_valid_recipe

if [ $VALID_RECIPE = 0 ]; then
  echo "Recipe: $RECIPE with version: $RECIPE_VERSION_FOLDER and OS: $RECIPE_OS_FOLDER is not valid"
	echo "You may use: './dci.sh --list'"
  exit
else
 create_userdata
 create_metadata

 echo "Using recipe: $RECIPE to create seed.iso"
 echo "REMEMBER to edit settings in $RECIPE_CONFIG for your environment"
 ## create seed.iso disk to attach with cloud image

 ## debian style
 if [ $os == "debian" ]; then
  if command -v genisoimage 2>/dev/null; then
		genisoimage -output seed.iso -V cidata -r -J $RECIPE_PATH/meta-data $RECIPE_PATH/user-data
  else
		sudo apt-get install -y genisoimage
		genisoimage -output seed.iso -V cidata -r -J $RECIPE_PATH/meta-data $RECIPE_PATH/user-data
  fi
 fi

 ## redhat style
  if [ $os == "redhat" ]; then
   if command -v mkisofs 2>/dev/null; then
		 mkisofs -output seed.iso -V cidata -r -J $RECIPE_PATH/meta-data $RECIPE_PATH/user-data
   else
		 echo "mkisofs not installed. Try to install it and continue"
		 sudo yum install -y mkisofs
		 mkisofs -output seed.iso -V cidata -r -J $RECIPE_PATH/meta-data $RECIPE_PATH/user-data
   fi
  fi

	## mac style
   if [ $os == "mac" ]; then
    mkdir $RECIPE_PATH/data
		mv $RECIPE_PATH/meta-data $RECIPE_PATH/data
		mv $RECIPE_PATH/user-data $RECIPE_PATH/data
		hdiutil makehybrid -ov -o seed.iso -hfs -joliet -iso -default-volume-name cidata $RECIPE_PATH/data
   fi

 ## download cloud vm

 download_cloud_image

 ## download deploy_cloud_vm

 if [ ! -f "./deploy_cloud_vm" ]; then

  if [ $os == "debian" ] || [ $os == "redhat" ]; then
   curl -L "https://github.com/Tfindelkind/automation/releases/download/v0.9-beta/deploy_cloud_vm_linux" >> ./deploy_cloud_vm
  fi
  if [ $os == "mac" ]; then
   curl -L "https://github.com/Tfindelkind/automation/releases/download/v0.9-beta/deploy_cloud_vm_mac" >> ./deploy_cloud_vm
  fi
  chmod +x  ./deploy_cloud_vm
 fi

 ## deploy_cloud_vm
 ## TODO download deploy_cloud_vm binary for os
 #echo ./deploy_cloud_vm --host $HOST --username $USERNAME --password $PASSWORD --vm-name $VMNAME --container $CONTAINER --vlan $VLAN --debug
 set -o xtrace
 ./deploy_cloud_vm --host=$HOST --username=$USERNAME --password=$PASSWORD --vm-name=$VMNAME --container=$CONTAINER --vlan=$VLAN --image-file=./$IMAGE_FOLDER/$cloud_image --image-name=$cloud_image --seed-name=Cloud-Init-$VMNAME --seed-file=./seed.iso
fi
