#!/bin/bash

exclude_archs=(alpha arc c6x csky h8300 \
			  hexagon m68k microblaze mips nds32 
			  nios2 openrisc parisc powerpc s390 \
			  sh sparc um unicore32 xtensa)
include_archs=(arm arm64 ia64 riscv x86)


# for exclude_arch in ${exclude_archs[@]}
# do
# 	echo "Working on $exclude_arch:"
# 	list=`find . -name $exclude_arch`
# 	echo "$list"
# done

function delete_file()
{
	if [ $# != 1 ]; then
		echo "Please specify one file or folder to delete"
		exit 1;
	fi

	#echo "Deleting $1"
}

function delete_arch_file()
{
	exclude_arch=$1
	file=$2

	if [ $# != 2 ]; then
		echo "Please specify ARCH and File/Folder to delete"
		exit 1;
	fi

	if [[ $file =~ arch/$exclude_arch ]]; then
		delete_file $file
	elif [[ $file =~ Documentation/$exclude_arch ]]; then
		delete_file $file
	elif [[ $file =~ Documentation/devicetree/bindings/$exclude_arch ]]; then
		delete_file $file
	elif [[ $file =~ scripts/dtc/include-prefixes/$exclude_arch ]]; then
		delete_file $file
	elif [[ $file =~ soc/$exclude_arch ]]; then
		delete_file $file
	elif [[ $file =~ sound/$exclude_arch ]]; then
		delete_file $file
	elif [[ $file =~ drivers/clk/$exclude_arch ]]; then
		delete_file $file
	elif [[ $file =~ drivers/$exclude_arch ]]; then
		delete_file $file
	fi
}

function delete_special()
{
	exclude_arch=$1

	if [ $# != 1 ]; then
		echo "Please specify ARCH to delete"
		exit 1;
	fi

	# if [ $exclude_arch == 'xtensa' ]; then
	# 	delete_file 'sound/soc/sof/xtensa'
	# fi
}

for exclude_arch in ${exclude_archs[@]}
do
	echo "Working on directory $exclude_arch:"

	# directory naming with arch
	list=`find . -type d -name "$exclude_arch"`
	echo "$list"

	for file in ${list[@]}
	do
		delete_arch_file $exclude_arch $file
	done

	# some special
	delete_special $exclude_arch
done

for exclude_arch in ${exclude_archs[@]}
do
	echo "Working on link $exclude_arch:"

	list=`find . -type l -name "$exclude_arch"`
	if [ ! -z $list ]; then
		echo "$list"
	fi

	for file in ${list[@]}
	do
		delete_arch_file $exclude_arch $file
	done

	# some special
	delete_special $exclude_arch
done

