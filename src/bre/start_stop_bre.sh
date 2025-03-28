function start_bre {
nogsedtest
if [[ $computer_type == Pi || $OS == Mac ]] ; then bre_podman_start ; return 0 ; fi

check_config_bre || return 1
sudo systemctl start btcrpcexplorer.service
}

function stop_bre {
if [[ $computer_type == Pi || $OS == Mac ]] ; then bre_podman_stop ; return 0 ; fi
sudo systemctl stop btcrpcexplorer.service
return 1
}

function restart_bre {
if [[ $computer_type == Pi || $OS == Mac ]] ; then bre_podman_restart ; return 0 ; fi
sudo systemctl restart btcrpcexplorer.service
}

function check_config_bre {

if [[ $computer_type == Pi || $OS == Mac ]] ; then
local file="$HOME/parmanode/bre/.env"
else
local file="$HOME/parmanode/btc-rpc-explorer/.env"
fi

if ! grep -q rpcuser= $bc >$dn 2>&1 ; then #if the setting doesn't exist 
    announce "There is a fault with the bitcoin.conf file. It can happen if
    the Bitcoin settings changed from when you originall installed BRE.

    Please set a username and password from the Bitcoin menu, otherwise, BRE
    won't work. Aborting for now."
    return 1
fi
if cat $file | grep COOKIE= ; then bre_auth=cookie ; fi
if cat $file | grep USER= ; then bre_auth="user/pass" ; fi

if grep -q "rpcuser" $bc ; then
 if [[ $bre_auth == "user/pass" ]] ; then return 0 ; fi #settings match, can proceed
else
 if [[ $bre_auth == "cookie" ]] ; then return 0 ; fi #settings match, can proceed
fi

# if code reaches here, changes need to be made.

if [[ $btc_auth == "cookie" ]] ; then
    sudo gsed -i "/USER=/d" $file
    sudo gsed -i "/PASS=/d" $file
    echo "BTCEXP_BITCOIND_COOKIE=$HOME/.bitcoin/.cookie" | sudo tee -a $file
    return 0
    fi

if [[ $btc_auth == "user/pass" ]] ; then
    sudo gsed -i "/COOKIE=/d" $file
    echo "BTCEXP_BITCOIND_USER=$rpcuser" | sudo tee -a $file 
    echo "BTCEXP_BITCOIND_PASS=$rpcpassword" | sudo tee -a $file 
    return 0
    fi
}