function create_wallet {
########################################################################################
if grep -q "lndpodman" $ic ; then

if ! podman ps >$dn 2>&1 ; then set_terminal ; echo -e "
########################################################################################$red
                              Docker is not running. $orange
########################################################################################
"
enter_continue ; jump $enter_cont
return 1
fi

if ! podman ps | grep -q lnd ; then set_terminal ; echo -e "
########################################################################################$red
                        The LND container is not running. $orange
########################################################################################
"
if [[ $1 != silent ]] ; then enter_continue ; jump $enter_cont ; return 1 ; esle true ; fi
fi 

if podman exec -it lnd /bin/bash -c "lncli walletbalance" >$dn 2>&1 ; then
announce "You already have an LND wallet, and it's unlocked. Please delete the 
    wallet first if you want to create a new one."
return 1
fi


########################################################################################


else #end podman


if ! sudo systemctl status litd.service >$dn \
&& ! sudo systemctl status lnd.service >$dn ; then
    set_terminal ; echo -e "LND is not running.$red Can't create wallet.$orange Start LND first."
    enter_continue ; return 1 ; 
fi

if lncli walletbalance >$dn 2>&1 ; then 
announce "You already have an LND wallet, and it's unlocked. Please delete the 
    wallet first if you want to create a new one."
return 1
fi

fi # end podman vs non podman

set_terminal
lnd_wallet_info
set_terminal

announce "${cyan}You will be asked to create a password - this is for your LND password, 
    NOT passphrase.$orange 

    (The keystrokes will not appear on your screen, just keep typing)

    The password needs to be 8 characters or more or LND won't accept it and you'll
    get errors.

    HIT ENTER FIRST, THEN YOU'LL BE ASKED TO ENTER THE PASSWORD.
"
echo -e "$reset" #resets colour

if grep -q "lndpodman" $ic ; then
podman exec -it lnd /bin/bash -c "lncli create"
debug "after lncli create"
else
lncli create
fi
echo -e "$orange" #colour goes back to Parmanode's default
enter_continue
}
