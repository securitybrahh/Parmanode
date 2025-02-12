function menu_premium {
while true ; do
menu_add_source
set_terminal
echo -en "$blue
########################################################################################
#                                                                                      #
#    P A R M A N O D E --> Main Menu --> Install Menu  -->$cyan Premium      $blue                #
#                                                                                      #
########################################################################################
#                                                                                      #
#                                                                                      #
#$cyan              rr)$blue        RAID - join drives together                                   #
#                                                                                      #
#$cyan              pnas)$blue      ParmaNas - Network Attached Storage                           #
#                                                                                      #
#$cyan              h)$blue         HTOP - check system resources                                 #
#                                                                                      #
#$cyan              udev)$blue      Add UDEV rules for HWWs (only needed for Linux)               #
#                                                                                      #
#$cyan              fb)$blue        ${UPDATE}Parman's recommended free books (pdfs)$endline
#                                                                                      #
#$cyan              cl)$blue        Core Lightning                                                #
#                                                                                      #
#$cyan              pm)$blue        ParMiner                                                      #
#                                                                                      #
########################################################################################
"
choose "xpmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 0 ;; m|M) back2main ;;

rr)
    install_raid 
    return 0
;; 

pnas)
    [[ ! -e $dp/.parmanas_enabled ]] && {
    announce "ParmaNas is not enabled by default in Parmanode; it is a
    premium feature. Contact Parman for more info."
    continue
    }

    if ! grep -q "parmanas-end" $ic ; then
    git@github.com:armantheparman/parmanas.git $pp/parmanas || { enter_continue "Something went wrong. Contact Parman." ; continue ; }
    fi

    cd $pp/parmanas
    ./run_parmanas.sh

;;
h|H|htop|HTOP|Htop)

    if [[ $OS == "Mac" ]] ; then htop ; break ; return 0 ; fi
    if ! which htop ; then sudo apt-get install htop -y >$dn 2>&1 ; fi
    announce "To exit htop, hit$cyan q$orange"
    htop
;;

udev|UDEV)

    if grep -q udev-end $dp/installed.conf ; then
    announce "udev already installed."
    return 0
    fi
    udev
;;
fb|FB)
get_books
;;

cl)
announce "Parmanode isn't configured to support Core Lightning, but it can install it for
    you. This means that any conflicts with other Parmanode-installed software will 
    not be checked for or managed.

    To install Core Lightning, it is recommended you uninstall LND, make sure Bitcoin 
    is installed and running, then exit parmanode and restart it with this command: $cyan

            rp install_core_lightning
    $orange
    To uninstall, do:$cyan
            
            rp uninstall_core_lightning
    $orange
    This will start the installation, and will get you to hit <enter> at various 
    stages, as it downloads files and compiles from source.

    There won't be any menus in Parmanode, you'll need to interact with it by the 
    command line or other means. Core Lightning may be implemende within Parmanode in 
    the future." 
;;
pm)
get_parminer
;;


*)
    invalid
    continue
    ;;
esac
done

return 0

}


function menu_qrencode {

while true ; do
set_terminal ; echo -en "
########################################################################################
                                     QR Encode
########################################################################################


                       ${pink}QREncode is installed on your system.


$cyan
                    info)$orange          Info fo DIY QR codes
$cyan
                    pub)$orange           QR of your computer's SSH pubkey


########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
quit|Q|q) exit ;; p|P) return 1 ;; m|M) back2main ;;
info) qrencode_info ;;
pub) 
set_terminal_custom 50 100
echo "Public key..."
qrencode -t ANSIUTF8 "$(cat ~/.ssh/id_rsa.pub)"
enter_continue
;;

*) invalid ;;
esac
done
}

function qrencode_info {
set_terminal ; echo -en "
########################################################################################
                                  QREncode Info
########################################################################################
$orange
    To use qrencode command manually, the syntax is ...
$cyan
                        qrencode -t ANSIUTF8 \"some text\"
$orange
    You can also QR the contents of a file ...
$cyan
                        qrencode -t ANSIUTF8 \"\$(cat /path/to/file)\"
$orange
    Don't omit the \" 

########################################################################################
"
enter_continue
}