function bre_podman_intro {
set_terminal ; echo -e "
########################################################################################
$cyan
                            BTC RPC Explorer Install
$orange
    Parmanode will now install BRE for you using Docker. This will give you a pretty
    webpage with your own Node's statistics. There's one to view online, but that's
    using someone else's node, and you'd be revealing your IP addres and wallet
    details to them, so it's good you'll be runnning your own.

########################################################################################                            
"
enter_continue
jump $enter_cont
}