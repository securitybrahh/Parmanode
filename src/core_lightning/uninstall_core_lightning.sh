function uninstall_core_lightning {

yesorno "Are you sure you want to uninstall Core Lightning?" || exit

sudo rm -rf $hp/core_lightning
sudo rm /usr/bin/lightning-cli  /usr/bin/lightningd  /usr/bin/lightning-hsmtool  /usr/bin/reckless >/dev/null
sudo rm $HOME/.lightning
success "Core Lightning Uninstalled"
exit
}
