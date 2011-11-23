# user variables
#---------------------------------------------------------------
# gems to be installed
gems="rails capistrano"

# script variables
#---------------------------------------------------------------
mainTitle="Ubuntu Server Setup"
tmpFile=`tempfile`

# functions
#---------------------------------------------------------------
installServerUpdates()
{
    sudo aptitude -y update
    sudo aptitude -y safe-upgrade
    sudo aptitude -y full-upgrade
    
    return
}

installBuildTools()
{
    sudo aptitude -y install build-essential libssl-dev libreadline5-dev zlib1g-dev curl openssh-server libyaml-dev
    return
}


# First, install dialog
#---------------------------------------------------------------
sudo aptitude install dialog

# Then show welcome screen
#---------------------------------------------------------------
dialog --backtitle "$mainTitle" --title "Welcome" \
       --yesno "Hi. This script will setup your Ubuntu Server for Rails apps. Before starting, make sure you're running a fresh Ubuntu install.\n\nThere's no input validation, so be sure of what you're typing.\n\nDo you want to continue?" \
       13 50 2> $tmpFile

input=$?
exitIfCancelOrESC $input
clear

# Ask for username
#---------------------------------------------------------------
dialog  --backtitle "$mainTitle" --title "Creating user account" \
        --inputbox "An user will be created to hold all configuration files and your application.\n\nType the username below." \
        12 50 app 2> $tmpFile

input=$?
exitIfCancelOrESC $input
username=`cat $tmpFile`
clear

# Ask for SSH port
#---------------------------------------------------------------
# TODO: check if the chosen port is being used
#       nc -zv 127.0.0.1 $ssh_port 2>&1
dialog  --backtitle "$mainTitle" --title "SSH port" \
        --inputbox "Is recommended that you change your SSH port to avoid brute force attack. The default port is 22.\n\nWhat port do you want to use? Choose one over port 2000." \
        13 50 22 2> $tmpFile

input=$?
exitIfCancelOrESC $input
ssh_port=`cat $tmpFile`
clear

# Ask for domain
#---------------------------------------------------------------
dialog  --backtitle "$mainTitle" --title "Domain name" \
        --inputbox "What's the domain you're setting up? Can be an IP address." \
        8 50 "domain.com" 2> $tmpFile

input=$?
exitIfCancelOrESC $input
domain=`cat $tmpFile`
clear

# Ask for admin email
#---------------------------------------------------------------
dialog  --backtitle "$mainTitle" --title "Administrator e-mail" \
        --inputbox "What's the admin e-mail?" \
        8 50 "admin@$domain" 2> $tmpFile

input=$?
exitIfCancelOrESC $input
admin_email=`cat $tmpFile`
clear

# Ask for thin instances
#---------------------------------------------------------------
dialog  --backtitle "$mainTitle" --title "Thin instances" \
        --inputbox "How many thin instances do you want to run?" \
        7 50 3 2> $tmpFile

input=$?
exitIfCancelOrESC $input
thin_instances=`cat $tmpFile`
clear

# Ask for thin port
#---------------------------------------------------------------
dialog  --backtitle "$mainTitle" --title "Thin port" \
        --inputbox "What's the starting port number you want your thin instances to use?" \
        8 50 5000 2> $tmpFile

input=$?
exitIfCancelOrESC $input
thin_port_start=`cat $tmpFile`
clear

# Ask for memcache port
#---------------------------------------------------------------
dialog  --backtitle "$mainTitle" --title "Memcache port" \
        --inputbox "What port do you want to run Memcache? The default is 11211." \
        8 50 11211 2> $tmpFile

input=$?
exitIfCancelOrESC $input
memcache_port=`cat $tmpFile`
clear

# Ask for memcache maximum memory usage
#---------------------------------------------------------------
dialog  --backtitle "$mainTitle" --title "Memcache memory usage" \
        --inputbox "How much memory do you want Memcached to use? Please set this value in MB." \
        8 50 30 2> $tmpFile

input=$?
exitIfCancelOrESC $input
memcache_memory=`cat $tmpFile`
clear

# Ask for MySQL password
#---------------------------------------------------------------
dialog  --backtitle "$mainTitle" --title "MySQL user account" \
        --inputbox "An user '$username' will be added to the MySQL. Additionally, a database '${username}_production' will be also created.\n\nPlease type a password for this new MySQL user." \
        13 50 2> $tmpFile

input=$?
exitIfCancelOrESC $input
mysql_password=`cat $tmpFile`
clear

# Disclaimer
#---------------------------------------------------------------
dialog  --backtitle "$mainTitle" --title "Disclaimer" \
        --yesno "I'll start setting up the server now. After this process, I'll restart the SSH service, which means that you'll be disconnected. To reconnect, please use the port $ssh_port as in \"ssh $username@<ip or domain> -p $ssh_port\".\n\nDo you want to continue?" \
        12 50 2> $tmpFile

input=$?
exitIfCancelOrESC $input
clear

# Start the process
#---------------------------------------------------------------
installServerUpdates
installBuildTools


dialog  --backtitle "$mainTitle" --title "Ubuntu Server Setup Completed" \
        --msgbox "The server has been setup (I hope) and you can access a sample application at http://$domain/home after the domain has been propagated." 8 50

clear
exit 0