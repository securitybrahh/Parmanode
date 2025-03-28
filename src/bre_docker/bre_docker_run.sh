function bre_podman_run {

if [[ $OS == Linux ]] ; then
podman run -d --name bre \
           --restart unless-stopped \
     -v $HOME/parmanode/bre:/home/parman/parmanode/bre \
     --network="host" \
     bre || return 1
fi

if [[ $OS == Mac ]] ; then
podman run -d --name bre \
           --restart unless-stopped \
     -v $HOME/parmanode/bre:/home/parman/parmanode/bre \
     -p 3002:3002 \
     bre || return 1
fi

}