function expose_LND {
if grep -r "lndpodman-" $ic ; then
text="
    Additionally, for those who run LND inside a Docker container, the IP of the 
    container is different to the IP of the computer it runs on.
    "
else
unset text
fi

get_extIP >$dn

set_terminal ; echo -e "
########################################################################################
  
    In order for OTHER nodes to find you and make peer connections, you need to
    either run LND behind TOR (easy from Parmanode menu), or if using clearnet, expose 
    your exteral IP (done manually, can be tricky). 
    
    Note, the internal IP address (assigned by the router) is a totally different thing
    to the external IP address. The internal IP is not accessible from computers 
    outside your home. 
    $text 
    The external IP is the IP address OF THE ROUTER itself, where all internet traffic 
    first goes to before reaching your computer. 

    Parmanode detects your external IP - it is:
    
                               $extIP
    
    ... and it has been entered into the lnd configuration file. But unless you tell 
    the router to allow traffic from the internet to access your node, other nodes 
    won't be able to find you.
$green
    Here's how ...
$orange
########################################################################################
"
enter_continue ; jump $enter_cont

clear
echo -e "
########################################################################################

    Parmanode can't do this for you, sorry, but here are the instructions:

    Log into the web server of your router using BROWSER by typing in your router's
    INTERNAL IP address. The address is likely to be something like:
$cyan
        192.168.0.1    or    10.0.0.1
$orange
    These IP address are very common and not secret. My computer's is 192.168.0.1, 
    and no one can access it unless they get passed my router's external IP and 
    firewall.

    You could try looking up the router's manuel for its internal IP address. Once you
    log in, you should be able to see the router's EXTERNAL IP, and the internal IPs
    of all the connectd devices.

    Somewhere on the page, perhaps under advanced settings, you should see a way
    to add \"port forwarding\".

    Create a new IPv4 port forwarding rule; name it anything; choose TCP for the 
    protocol; set the WAN and LAN port options to $lnd_port; and put the destination 
    IP the same as this computer's: $IP 

    If using LND with Docker, the instructions are identical - Don't put the Docker
    container's IP, put the IP of the computer.

    Then save, and restart LND. 

########################################################################################
"
enter_continue ; jump $enter_cont
return 
}