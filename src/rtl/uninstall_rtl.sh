function uninstall_rtl {
while true ; do
set_terminal ; echo -e "
########################################################################################
$cyan
                                 Uninstall RTL 
$orange
    Are you sure? (y) (n)

########################################################################################
"
choose xpmq ; read choice
jump $choice || { invalid ; continue ; } ; set_terminal
case $choice in
q|Q) exit ;; p|P) return 1 ;; m|M) back2main ;;
n) return 1 ;; y) break ;;
rem)
rem="true"
break
;;
esac
done

please_wait

podman stop rtl
podman rm rtl 
podman rmi rtl 
sudo rm -rf $HOME/parmanode/rtl $hp/startup_scripts/rtl_startup.sh >$dn 2>&1
sudo rm ./src/rtl/RTL-Config.json >$dn 2>&1

sudo systemctl stop rtl.service
sudo systemctl disable rtl.service
sudo systemctl rm /etc/systemd/system/rtl.service

installed_config_remove "rtl"
#disable_tor_rtl
success "RTL" "being uninstalled."
return 0
}