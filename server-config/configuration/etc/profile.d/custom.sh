#Custom Profile file
export PS1='\u@\h:\w\n#'
export PATH=$PATH:$HOME/bin:/home/opc/bin
export http_proxy=http://10.10.1.11:3128/
export https_proxy=http://10.10.1.11:3128/
export no_proxy=localhost,127.0.0.1

#display umask values
#umask -S
#umask=022 #default
umask 0027

alias rsync_server="sudo /home/opc/bin/rsync_server.sh"

# END