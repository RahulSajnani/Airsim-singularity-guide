#!/bin/bash

# Code borrowed and modified from https://github.com/microsoft/AirSim/blob/master/docker/run_airsim_image_binary.sh

DOCKER_IMAGE_NAME=$1

# get the base directory name of the unreal binary's shell script
# we'll mount this volume while running docker container
UNREAL_BINARY_PATH=$(dirname $(readlink -f $2))
UNREAL_BINARY_SHELL_ABSPATH=$(readlink -f $2)

# this block is for running X apps in docker
XAUTH=/tmp/.docker.xauth
if [ ! -f $XAUTH ]
then
    xauth_list=$(xauth nlist :0 | sed -e 's/^..../ffff/')
    if [ ! -z "$xauth_list" ]
    then
        echo $xauth_list | xauth -f $XAUTH nmerge -
    else
        touch $XAUTH
    fi
    chmod a+r $XAUTH
fi

# this are the first (maximum) four arguments which the user specifies:
# ex: ./run_airsim_image.sh /PATH/TO/UnrealBinary/UnrealBinary.sh -windowed -ResX=1080 -ResY=720
# we save them in a variable right now:
UNREAL_BINARY_COMMAND="$UNREAL_BINARY_SHELL_ABSPATH $3 $4 $5"

# now let's check if user specified  an "-- headless" parameter in the end
# we'll set SDL_VIDEODRIVER_VALUE to '' if it wasn't specified, 'offscreen' if it was
SDL_VIDEODRIVER_VALUE='';
while [ -n "$1" ]; do
    case "$1" in
    --)
        shift
        break
        ;;
    esac
    shift
done

for param in $@; do
    case "$param" in
    headless) SDL_VIDEODRIVER_VALUE='offscreen' ;;
    esac
done

# now, let's mount the user directory which points to the unreal binary (UNREAL_BINARY_PATH)
# set the environment varible SDL_VIDEODRIVER to SDL_VIDEODRIVER_VALUE
# and tell the docker container to execute UNREAL_BINARY_COMMAND

if [ -d /tmp/.X11-unix  ]
then
  echo "tmp directory exists"
else
  mkdir /tmp/.X11-unix
fi

#singularity instance start $DOCKER_IMAGE_NAME airsim

# Export CUDA devices
export SINGULARITYENV_CUDA_VISIBLE_DEVICES=0

# Bind paths
export SINGULARITY_BIND="$(pwd)/settings.json:/home/airsim_user/Documents/AirSim/settings.json,$UNREAL_BINARY_PATH:$UNREAL_BINARY_PATH,/tmp/.X11-unix:/tmp/.X11-unix:rw,$XAUTH:$XAUTH"

# --nv is to use nvidia gpus
# run the container
singularity run --nv \
    --env DISPLAY=$DISPLAY \
    --env QT_X11_NO_MITSHM=1 \
    --env SDL_VIDEODRIVER=$SDL_VIDEODRIVER_VALUE \
    --env SDL_HINT_CUDA_DEVICE='0' \
    --env XAUTHORITY=$XAUTH \
    $DOCKER_IMAGE_NAME \
    /bin/bash -c "$UNREAL_BINARY_COMMAND"
