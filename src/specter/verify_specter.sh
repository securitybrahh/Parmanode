function verify_specter {

cd $HOME/parmanode/specter

gpg --keyserver keyserver.ubuntu.com --recv-keys 36ed357ab24b915f

if which sha256sum >$dn ; then 
    if ! sha256sum --ignore-missing --check SHA256SUMS ; then echo "Checksum failed. Aborting." ; enter_continue ; return 1 ; fi
else
    if ! shasum --check SHA256SUMS | grep -q OK ; then echo "Checksum failed. Aborting." ; enter_continue ; return 1 ; fi
fi 
   
set_terminal
echo -e "gpg and sha256 checks$green passed$orange."
sleep 1.5
set_terminal
return 0
}