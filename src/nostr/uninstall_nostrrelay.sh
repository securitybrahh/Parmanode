function uninstall_nostrrelay {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                               Uninstall Nostr Relay 
$orange
    Are you sure? 

                    y)    Yes, uninstall

                    n)    Nah, abort
$red
                    rem)  Yes, and remove the data directory too.
$orange


########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n)
return 1
;;
y)
break
;;
rem)
rem="true"
debug "rem true choice. rem is $rem"
break
;;
esac
done

set_terminal

if ! podman ps >$dn 2>&1 ; then
announce "podman not running. Aborting."
return 1
fi

double_check_website_not_installed || return 1

podman stop nostrrelay >$dn 2>&1
podman rm nostrrelay >$dn 2>&1

sudo rm -rf $hp/nostrrelay 2>$dn

if [[ -e /var/www/website ]] ; then
sudo rm -rf /var/www/website >$dn
fi

sudo rm -rf /etc/nginx/conf.d/website* >$dn 2>&1
sudo rm -rf /etc/nginx/conf.d/$domain_name.conf >$dn 2>&1
sudo rm -rf /etc/letsencrypt/live/$domain_name >$dn 2>&1
sudo rm -rf /etc/letsencrypt/live/www.$domain_name >$dn 2>&1
sudo systemctl restart nginx >$dn 2>&1

source $pc
if [[ $rem == "true" ]] ; then
    if [[ $drive_nostr == custom ]] ; then sudo rm -rf $drive_nostr_custom_data
    elif [[ $drive_nostr == external ]] ; then sudo rm -rf $pd/nostr_data 
    elif [[ $drive_nostr == internal ]] ; then sudo rm -rf $HOME/.nostr_data
    fi
fi
debug "after rem true if"

nostr_tor_remove
parmanode_conf_remove "domain"
parmanode_conf_remove "www" 
parmanode_conf_remove "nostrrelay"
parmanode_conf_remove "relay"
installed_conf_remove "nostrrelay"
success "Nostr Relay has been uninstalled"
}

function double_check_website_not_installed {

if which mariadb >$dn || which mysql >$dn ; then 
while true ; do
set_terminal ; echo -e "
########################################################################################
$pink$blinkon
       MAKE SURE YOU DON'T HAVE A PARMAWEB WEBSITE INSTALLED OR THIS PROCESS
       MAY DELETE FILES. $blinkoff
$orange       
       PARMANODE DOES NOT ALLOW THE TWO TO BE INSTALLED TOGETHER ANYWAY, BUT IF YOU 
       WERE \"LYING 'N' TRICKIN' THE CODE\", BAD THINGS CAN HAPPEN.


                        c)     Continue, it's fine

                        a)     Abort

########################################################################################
"
read choice
set_terminal
case $choice in
c) return 0 ;;
a) return 1 ;;
*) invalid ;;
esac
done
fi
}


