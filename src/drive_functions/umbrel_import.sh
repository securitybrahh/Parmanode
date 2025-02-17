function umbrel_import {
if [[ $OS == Mac ]] ; then no_mac ; return 1 ; fi
cd
set_terminal ; echo -e "
########################################################################################
$cyan
                             UMBREL DRIVE MIGRATE TOOL
$orange
    This tool will convert your Umbrel external drive to make it compatible with
    Parmanode, preserving any Bitcoin block data that you may have already sync'd up.

    Simply use this convert tool, and plug into any Parmanode computer (ParmanodL). 
    I say 'any', but do know that if it's another ParmanodL, you still need to 
    'import' the drive on that computer as well - there is a 'Import to Parmnaode'
    option in the tools menu.

    If you wish to go back to Umbrel, then use the 'Revert to Umbrel' tool, 
    otherwise the drive won't work properly.
$pink
    Lightning channels are not migrated. At present, it has not been tested if your
    lighning channles are safe to leave. Either close your channels if you have them,
    or don't use this tool. $orange

########################################################################################
"
choose "eq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in q|Q|P|p) return 1 ;; esac

if [[ $importdrive != "true" ]] ; then
while sudo mount | grep -q parmanode ; do 
set_terminal ; echo -e "
########################################################################################
    
    This tool will$cyan refuse to run$orange if it detects an existing mounted 
    or even connected Parmanode drive. Bad things can happen. 

    If you want to continue, make sure any programs syncing to the drive (Bitcoin, or
    Fulcrum) have been stopped, then$pink unmount$orange the drive, then disconnect it,
    then come back to this function.

    Or, do you want Parmanode to attempt to cleanly stop everything and unmount the 
    drive for you?
$green
               y)       Yes please, how kind.
$red
               nah)     Nah ( = 'No' in Straylian)
$orange
########################################################################################
"
choose "xpmq" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; m|M) back2main ;;
p|P|nah|No|Nah|NAH|NO|n|N) return 1 ;;
y|Y|Yes|yes|YES)
safe_unmount_parmanode || return 1 
;;
*) invalid ;;
esac
done
fi #end importdrive != true

while sudo blkid | grep -q parmanode ; do
set_terminal ; echo -e "
########################################################################################

            Please disconnect the Parmanode drive from the computer.

            Hit$red a$orange and then$green <enter>$orange to abort.

            Hit $green<enter>$orange once physically$pink disconnected$orange.

########################################################################################
"
choose xmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q) exit ;; m|M) back2main ;;
p|a|A) return 1 ;; 
esac
done


while ! sudo lsblk -o LABEL | grep -q umbrel ; do
set_terminal ; echo -e "
########################################################################################

    Please insert the$cyan Umbrel drive$orange you wish to import, then hit$green <enter>.$orange

########################################################################################
"
choose xpmq ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in q|Q) exit ;; p|P) return 1 ;; *) sync ; continue ;; esac ; done


#Get disk ID
export disk=$(sudo blkid | grep umbrel | cut -d : -f 1)

#Mount
export disk=$(sudo blkid | grep umbrel | cut -d : -f 1)
export mount_point="/media/$USER/parmanode"
if [[ ! -d $mount_point ]] ; then sudo mkdir -p $mount_point ; debug "mountpoint made" ; fi

sudo umount /media/$USER/parmanode* >$dn 2>&1
sudo umount $disk >$dn 2>&1
sudo mount $disk $mount_point >$dn 2>&1

# Move files
#sudo mkdir -p $mount_point/.bitcoin
if [[ -d $mount_point/.bitcoin ]] ; then sudo mv $mount_point/.bitcoin $mount_point/.bitcoin_backup_0 
else
    sudo rm $mount_point/.bitcoin >$dn 2>&1
fi

# The main changes...

cd $mount_point/ && sudo ln -s ./umbrel/app-data/bitcoin/data/bitcoin/ .bitcoin 
debug "line 113 done; mount point is $mount_point"
sudo chown -h $USER:$(id -gn) $mount_point/.bitcoin
debug "chown"
sudo mkdir -p $mount_point/umbrel/app-data/bitcoin/data/bitcoin/parmanode_backedup/
debug "mkdir parmanode_backedup"
sudo mv $mount_point/umbrel/app-data/bitcoin/data/bitcoin/*.conf $mount_point/umbrel/app-data/bitcoin/data/bitcoin/parmanode_backedup/
debug "moving to backedup"
sudo chown -R $USER:$(id -gn) $mount_point/umbrel/app-data/bitcoin/data/bitcoin
debug "chown"
make_bitcoin_conf umbrel

debug "after make_bitcoin_conf umbrel
Bitcoin drive import = $bitcoin_drive_import
"
sudo mkdir -p $mount_point/electrs_db $mount_point/fulcrum_db >$dn 2>&1
debug "mkdir electrs_db and fulcrum_db"
sudo chown -R $USER:$(id -gn) $mount_point/electrs_db $mount_point/fulcrum_db >$dn 2>&1
debug "chown for electrs and fulcrum"


# label
while sudo lsblk -o LABEL | grep -q umbrel ; do
echo "Changing the label to parmanode"
sudo e2label $disk parmanode 2>&1
sleep 1
sudo partprobe 2>/dev/null
done
deub "label done"
# fstab configuration
while grep -q parmanode < /etc/fstab ; do
set_terminal ; echo -e "
########################################################################################

    There already seems to be a Parmanode drive configured to auto-mount at system
    boot. 
    
    You can only have one at a time. 
    
    Would you like to$cyan replace the old Parmanode drive$orange with the new drive from Umbrel 
    for this computer?

                        $green  y $orange       or  $red      n $orange

########################################################################################
"
choose "xmq" ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q) exit ;; m|M) back2main ;;
y|Y)
# can't export everything, need grep, becuase if Label has spaces, causes error.
export $(sudo blkid -o export $disk | grep TYPE)
export $(sudo blkid -o export $disk | grep UUID)
sudo gsed -i "/parmanode/d" /etc/fstab
echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab >$dn 2>&1
debug "fstab done"
break
;;
n|N)
export fstab_setting=wrong
break
;;
*)
invalid ;;
esac
done

# Finished. Info.
set_terminal ; echo -e "
########################################################################################

    The drive data has been adjusted such that it can be used by Parmanode. It's
    label has been changed from$cyan umbrel$orange to$cyan parmanode${orange}.

    The drive can still be used by Umbrel - swap over at your leisure, but you do
    first need to use the Parmanode \"revert\" tool first.

########################################################################################
"  
enter_continue 
jump $enter_cont
set_terminal

########################################################################################
########################################################################################
if [[ $importdrive == "true" ]] ; then return 0 ; fi
########################################################################################
########################################################################################

#Conenct drive to Bitcoin Core
source $HOME/.parmanode/parmanode.conf
while [[ $drive == internal ]] ; do
source $HOME/.parmanode/parmanode.conf
set_terminal ; echo -e "
########################################################################################

        Parmanode will now change the syncing directory from Internal to External.
  
        Hit$cyan <enter>$orange to accept, or$red a$orange to abort.

        If you abort, you'l have to select to swap internal vs external from the
        Parmanode Bitcoin menu.

########################################################################################    
"
choose "xpmq"
read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in a|A|q|Q|P|p) return 1 ;; m) back2main ;; esac
change_bitcoin_drive change
source $HOME/.parmanode/parmanode.conf
done

# One more chance
if [[ $drive == external && $fstab_setting == wrong ]] ; then
while true ; do
echo -e "
########################################################################################

    When you replace the old Parmanode drive with this one, Bitcoin will sync up 
    with the data on this new drive. However, because you chose to not remove the
    old auto-mount configuration earlier for the old drive, when the system boots up, 
    the old drive will be expected and Bitcoin will fail to auto start.

    Remove the old auto-mount setting and use the current drive?

     $green               y  i$orange        or     i$red     n $orange

########################################################################################
"
choose "x" ; read choice 
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in 
q|Q) exit ;; m|M) back2main ;;
y|Y)
# can't export everything, need grep, becuase if Label has spaces, causes error.
export $(sudo blkid -o export $disk | grep TYPE) 
export $(sudo blkid -o export $disk | grep UUID) 
sudo gsed -i "/parmanode/d" /etc/fstab
echo "UUID=$UUID /media/$(whoami)/parmanode $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab >$dn 2>&1
break
;;
n|N)
export fstab_setting=wrong
break
;;
*)
invalid ;;
esac
done
fi

#Info

set_terminal ; echo -e "
########################################################################################

    Please note, if you wish to use this new Parmanode drive on a computer different
    to this one, you should$cyan 'import'$orange it from the menu so the auto-mount feature can 
    be configured.

########################################################################################
" ; enter_continue ; jump $enter_cont

cd
sudo umount $disk >$dn 2>&1
sudo umount /media/$USER/parmanode* >$dn 2>&1
sudo umount /media/$USER/parmanode >$dn 2>&1
debug "unmounts done"

if ! grep -q parmanode < /etc/fstab ; then 
    # can't export everything, need grep, becuase if Label has spaces, causes error.
    export $(sudo blkid -o export $disk | grep TYPE)
    export $(sudo blkid -o export $disk | grep UUID) 
    echo "UUID=$UUID $parmanode_drive $TYPE defaults,nofail 0 2" | sudo tee -a /etc/fstab >$dn 2>&1
    debug "after echo UUID...
    TYPE, $TYPE
    UUID, $UUID
    fstab...
    $(sudo cat /etc/fstab)"
fi

success "Umbrel Drive" "being imported to Parmanode."
}