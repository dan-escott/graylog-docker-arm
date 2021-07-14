#!/bin/bash
image="$1"
branch="$2"
version="$3"

IFS='.-' read -r -a array <<< "${version}"

tag=""
tags=""

# tag latest if on main branch
if [ "$branch" = "main" ]
then
    tags="${tags} --tag ${image}:latest"
fi

# tag channel if not default (from 1.2.3-[channel].1)
if [ ${#array[@]} -gt 3 ]
then
    tags="${tags} --tag ${image}:${array[3]}"
fi

# tag 1, 1.2, 1.2.3, etc
for index in "${!array[@]}"
do
    # check this isn't the channel
    if [ ${index} != 3 ]
    then
        if test -z "$tag"
        then
            tag="${array[index]}"
        else
            tag="${tag}.${array[index]}"
        fi
        tags="${tags} --tag ${image}:${tag}"
    fi
done

echo "${tags}"
