function run_btcpay {
count=0
while [ $count -le 1 ] ; do

if docker ps | grep btcpay ; then   
docker exec -d -u parman btcpay /bin/bash -c "$HOME/parmanode/btcypayserver/run.sh" && \
    log "btcpay" "btcpay started" && break || log "btcpay" "failed to start btcpay" && return 1    
else
docker start btcpay || log "btcpay" "failed to start btcpay docker container"     
count=$((count + 1))
fi

set_terminal ; echo "
########################################################################################

    BTCPay Server lives inside the BTCPay Docker container. Parmanode couldn't get 
    the container to run, so BTCPay Server isn't running.

########################################################################################
"
log "btcpay" "run command failed. Likely because container not running."
enter_continue
return 1
}    