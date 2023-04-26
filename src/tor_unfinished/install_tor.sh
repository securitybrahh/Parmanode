function install_tor {

set_terminal ; echo "
########################################################################################

                                   Install Tor
    
    Parmanode will install Tor daemon (not browser). It runs in the background allowing
    you to access the Tor network.

########################################################################################    
"
choose "epq" ; read choice 
case $choice in Q|q|Quit|QUIT) exit 0 ;; p|P) return 1 ;; *) true ;; esac

set_terminal

if [[ $OS == "Linux" ]] ; then sudo apt install tor -y ; fi
if [[ $OS == "Mac" ]] ; then 
    while ! command -v brew ; do 
        set_terminal ; echo "Homebrew needs to be installed. Do that now (y) (n)?"
        read choice
        case $choice in y|Y) install_homebrew ;; n|N) break ;; esac
    done

    brew install tor 
fi





}