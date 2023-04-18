function menu_parmanode {
clear
while true
do
set_terminal
echo "
########################################################################################

                              P A R M A N O D E - \"Apps\"

########################################################################################          

                             (b)      Bitcoin Core

                             (f)      Fulcrum (an Electrum Server)

            Not yet avaiable...                        

                             (m)      Mempool.Space

                             (l)      LND

                             (rtl)    RTL

                             (bps)    BTCPay Server

                             (s)      Specter Desktop

                             (th)     ThunderHub

                             (lh)     LND Hub

                             (t)      Tor 

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
m | M | l | L | RTL | rtl | bps | BPS | s | S | th | TH | lh | LH | t | T)
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
