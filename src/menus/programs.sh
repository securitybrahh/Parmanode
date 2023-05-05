function menu_programs {
clear
while true
do
set_terminal_bit_higher
echo "
########################################################################################

                              P A R M A N O D E - \"Apps\"

########################################################################################          

                             (b)       Bitcoin Core

                             (f)       Fulcrum (an Electrum Server)

                             (btcp)    BTCPay Server

                             (t)       Tor 

                             (lnd)     LND

            Not yet avaiable...                        

                             (m)       Mempool.Space

                             (rtl)     RTL

                             (s)       Specter Desktop

                             (th)      ThunderHub

                             (lh)      LND Hub

#######################################################################################

"
choose "xpq"
read choice

case $choice in

b|B)
    clear
    menu_bitcoin_core
    ;;
f|F)
    menu_fulcrum
    ;;
btcp|BTCP)
    if [[ $OS == "Mac" ]] ; then no mac ; continue ; fi
    menu_btcpay
    ;;

t|T)
    menu_tor
    ;;
lnd|LND|Lnd)
if [[ $OS == "Linux" ]] ; then menu_lnd ; fi
if [[ $OS == "Mac" ]] ; then no_mac ; fi
;;

m | M | RTL | rtl |is | S | th | TH | lh | LH )
    clear
    echo "Not yet available. Stay tuned for future versions."
    echo "Hit <enter> to return to menu."
    read
    ;;
p)
    return 0
    ;;
q | Q | quit)
    exit 0
    ;;
*)
    invalid
    ;;
esac

done
}
