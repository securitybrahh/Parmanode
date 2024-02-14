function temp_patch {

if grep -q ":5000" < $bc ; then
delete_line $bc "zmqpubrawblock=tcp://\*:5000" >/dev/null 2>&1
echo "zmqpubrawblock=tcp://*:5000" | tee -a $bc >/dev/null
fi


if [[ -d $pp/parmanode/src/Public_pool ]] ; then
mv $pp/parmanode/src/Public_pool $pp/parmanode/src/public_pool >/dev/null 2>&1
fi

swap_string "$ic" "piassps-end" "piapps-end"
if [[ -f $bc ]] ; then
delete_line $bc "rpcallowip=172"
echo "rpcallowip=172.0.0.0/8" | sudo tee -a $bc >/dev/null 2>&1
fi

if [[ ${message_jq} != 1 ]] && grep -q "electrs" < $ic && ! which jq > /dev/null ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    Parmanode has detected that you have electrs installed, and due to some
    recent electrs menu improvements, you need to install$cyan jq$orange to make it display nice.
    
    Do that now?
$green
                           y)        Go for it
$red
                           n)        No
$bright_blue
                           nooo)     No and never ask again
$orange 
########################################################################################
"
choose "xq" ; read choice ; set_terminal
case $choice in
q|Q) exit 0 ;; p|P) previous ;; n|N) break ;;
y|yes)
if [[ $OS == Mac ]] && ! which brew >/dev/null ; then
announce "To install jq, Parmanode needs to install HomeBrew first. You can abandon
    this in the next screen, and next time install jq your self if you want."
brew_check
fi
install_jq
break
;;
nooo)
hide_messages_add "jq" "1"
break
;;
*)
invalid ;;
esac
done
fi
}