#if [ `grep -c "worker start" ip.log` -ne '0' ];then
#	echo "OK"
#else
#	echo "ERROR"
#fi



#iperf -s -D &
#iperf3_process=$!
#echo ${iperf3_process}



loop=1

if (( ${loop} == 1 )); then 
	echo "OK"
else
	echo "NO"
fi
