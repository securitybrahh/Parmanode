function make_lnd_directories {

sudo rm -rf $HOME/parmanode/lnd && mkdir $HOME/parmanode/lnd >$dn 2>&1

if [[ -d $HOME/.lnd ]] ; then
while true ; do
set_terminal ; echo -e "
########################################################################################

    The$cyan ~/.lnd/$orange directory exists on your computer. You have options:
$red
                       1)    Delete it and start fresh
$bright_blue
                       2)    Back it up to .lnd_backup (other backups overwritten!)
$green                       
                       3)    Use it
$orange
                       a)    Abort

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P|a|A) return 1 ;; m|M) back2main ;;
1)
sudo rm -rf $HOME/.lnd && mkdir $HOME/.lnd >$dn 2>&1
break
;;
2)
mv $HOME/.lnd $HOME/.lnd_backup 
mkdir $HOME/.lnd >$dn 2>&1
break
;;
3)
announce "Note that if this$cyan ~/.lnd/$orange directory that you're 'importing' 
    was not created by Parmanode, you could experience technical issues that 
    I can't predict.$red

    <control>-c$orange can abort now."
export reusedotlnd="true"
break
;;
*)
invalid
;;
esac 
done
else
mkdir $HOME/.lnd >$dn 2>&1
fi
}


