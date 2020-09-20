PAMOUNT="16" # 2 3 4 5 9 15 21 32 45"
IPS=(`cat ip_internal.txt`)
DBSIZE="16384 65536" #  256 1024 4096 10000 100000 500000 1000000"
#DOMAIN="protocol.mpsi"
EXPATH="$HOME/test-res"
#len=${#IPS[@]}
#echo $len
#exit
#PLAYER_AMOUNT=`cat $EXPATH/PLAYER_AMOUNT`
#echo $PLAYER_AMOUNT
mkdir -p $EXPATH
#rm -rf $EXPATH/*


#rm -f $EXPATH/ip.txt

echo "" > ~/.ssh/known_hosts

#for IPE in $(seq 2 $(($PLAYER_AMOUNT + 1)))
#do
#	#echo "---"
#        echo "10.1.1.$IPE"  >> "$EXPATH/ip.txt"
#done

# bash all.sh kill
# bash all.sh createip
# bash all.sh copy

SPECPATH=`date +%y-%m-%d_%H%M%S`
echo "Note: The results will appear in $EXPATH/$SPECPATH/ ..."
mkdir -p $EXPATH/$SPECPATH/

for DBS in $DBSIZE
do
	# echo DBS $DBS
	# bash all.sh createdb $DBS
	for PLYAM in $PAMOUNT
	do
		echo "-------------------------------------------------"
		echo "--- Starting Test of $PLYAM with DB size $DBS "
		echo "-------------------------------------------------"
		bash all.sh createipfile $PLYAM
		echo -e "\n---- ip.txt ----"
		cat files_for_copy/ip.txt
		echo -e	"---------------"
		echo -e "\n[ ] Killing all players main before starting new test..."
		bash all.sh kill
		echo "[ ] Copy test data to all players..."
		bash all.sh copy
		# echo PLYAM $PLYAM
		for PLY in $(seq 1 $(($PLYAM - 1)))
		do
			# echo PLY $PLY
			# echo res-p$PLY-pa$PLYAM-dbs$DBS.txt
			# echo ${IPS[$PLY]}
			# ssh -o StrictHostKeyChecking=no ${IPS[$PLY]} "~/python3 gen_cfg_file.py $DBS" > $EXPATH/res-p$PLY-pa$PLYAM-dbs$DBS.txt &
			echo "[ ] Starting Player $PLY! - ${IPS[$PLY]}"
			ssh -o StrictHostKeyChecking=no ${IPS[$PLY]} "python3 gen_cfg_file.py $DBS && python3 gen_data_file.py common_data.txt data.txt $DBS 0 && ~/main $PLY cfg.txt 2>&1" > $EXPATH/$SPECPATH/res-p$PLY-pa$PLYAM-dbs$DBS.txt &
		done
		sleep 2s
		echo "[ ] Starting player 0! - ${IPS[0]}"
		echo 		 "-----------------------------------------------"
		echo 		 "--- Test of $PLYAM with DB size $DBS is running "
		/usr/bin/time -f "---        Test finished in %E " ssh -o StrictHostKeyChecking=no ${IPS[0]} "python3 gen_cfg_file.py $DBS && python3 gen_data_file.py common_data.txt data.txt $DBS 0 && ~/main 0 cfg.txt 2>&1" > $EXPATH/$SPECPATH/res-p0-pa$PLYAM-dbs$DBS.txt
		echo             "-----------------------------------------------"
		echo "[ ] Copy timing data from player 0..."
		scp ${IPS[0]}:~/timing.csv $EXPATH/$SPECPATH/timing-p0-pa$PLYAM-dbs$DBS.csv
		echo "[ ] Copy timing data from player 1..."
		scp ${IPS[1]}:~/timing.csv $EXPATH/$SPECPATH/timing-p1-pa$PLYAM-dbs$DBS.csv
		echo "[ ] Cooling down... 60 sec"
		sleep 60s
	done
done

# sudo apt install libgmp-dev libssl-dev libboost-all-dev
# sudo apt-get install build-essential g++ python-dev autotools-dev libicu-dev build-essential libbz2-dev libboost-all-dev
