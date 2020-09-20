#PLYAM=`cat ~/mpsi-test/PLAYER_AMOUNT`
DOMAIN="protocol.mpsi"
IPS=(`cat ip_internal.txt`)
MAIN_COMP_IP=172.31.85.14


function run_remote_command_all {
	COMMAND=$1
#	for PLY in $(seq 0 $(($PLYAM - 1)))
	for PLY in "${IPS[@]}"
	do
		echo "RC:$PLY >> $COMMAND"
	        ssh -o StrictHostKeyChecking=no $PLY $COMMAND &
	done
}   # end of run_command

function run_local_command_all {
        COMMAND=$1
#       for PLY in $(seq 0 $(($PLYAM - 1)))
        for PLY in "${IPS[@]}"
        do
                echo "LC:$PLY >> $COMMAND"
                $COMMAND
        done
}   # end of run_command

function copy_to_all {
#       for PLY in $(seq 0 $(($PLYAM - 1)))
        for PLY in "${IPS[@]}"
        do
                echo "CP:$PLY:"
                scp -q -o StrictHostKeyChecking=no ~/test-scripts/files_for_copy/* $PLY:~/ 
		#COUNT=$(($COUNT + 1))
        done
}   # end of run_command


if [ "$1" == 'init' ]; then
	run_command_all "bash ~/mpsi-test/init_machine.sh"
	exit
fi

if [ "$1" == 'reboot' ]; then
        run_remote_command_all "sudo reboot"
	exit
fi

if [ "$1" == 'shutdown' ]; then
        run_remote_command_all "sudo shutdown now"
        exit
fi

if [ "$1" == 'copy' ]; then
	copy_to_all
        exit
fi

#if [ "$1" == 'createdb' ]; then
#        run_remote_command_all "python3 gen_data_file.py common_data.txt data.txt $2 123"
#        exit
#fi

if [ "$1" == 'createipfile' ]; then
	echo "Create IP file..."
	echo -n "" > ~/test-scripts/files_for_copy/ip.txt
        for PLY in "${IPS[@]:0:$2}"
        do
                echo -e "$PLY\r" >> ~/test-scripts/files_for_copy/ip.txt
                $COMMAND
        done
        exit
fi

if [ "$1" == 'kill' ]; then
        run_remote_command_all "killall main"
        exit
fi

echo -e "help:\n\treboot\n\tinit"
