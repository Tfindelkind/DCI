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
VALID_RECIPE=0


check_all_valid_recipe()
{
	i=0
	while read line 
	do
	 VALID_RECIPE=0
	 RECIPE=$line
	 check_valid_recipe
	 if [ $VALID_RECIPE = 1 ]; then 
	   echo "$RECIPE"
	 fi  
	done < <(ls $RECIPE_FOLDER)
	
}

check_valid_recipe()
{
   # does the file exist?
   if [ -f "./$RECIPE_FOLDER/$RECIPE/config" ]; then
	# read config file (key/values) into two array 
	keys=()
	values=()
	while IFS='=' read -r key value
	do
		keys+=("$key")
		# remove the quotes when adding
		values+=("${value//\"}")
	done < "./$RECIPE_FOLDER/$RECIPE/config"
	
	#the first key needs to be "name", the value needs to be the same then the used $RECIPE
	if [ ${keys[0]} = "name" ]; then 
		if [ ${values[0]} = $RECIPE ]; then
		   VALID_RECIPE=1
		fi
	fi	
   fi
}

if [ "$1" = "--recipe" ]; then
   RECIPE=$2
   check_valid_recipe
   if [ $VALID_RECIPE = 0 ]; then 
     echo "Recipe: $2 is not valid"    
     exit
   else
     echo "Using recipe: $2 to create seed.iso"
     echo "REMEMBER to edit settings in ./$RECIPE_FOLDER/$RECIPE/user-data ./$RECIPE_FOLDER/$RECIPE/meta-data for your environment"
     ## create seed.iso disk to attach with cloud image
	 genisoimage -output seed.iso -V cidata -r -J ./$RECIPE_FOLDER/$RECIPE/meta-data ./$RECIPE_FOLDER/$RECIPE/user-data	
   fi  
elif [ "$1" = "--list" ]; then
  check_all_valid_recipe  

else
  echo "  USAGE:
    `/.create_data_files.sh` [options] [value]

  Options:
    --recipe: specifies the recipe
    --list:   list all available recipes"
fi



