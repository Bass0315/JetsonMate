:<<!
if [ `grep -c "worker start" ip.log` -ne '0' ];then
	echo "OK"
else
	echo "ERROR"
fi



iperf -s -D &
iperf3_process=$!
echo ${iperf3_process}



loop=1

if (( ${loop} == 1 )); then 
	echo "OK"
else
	echo "NO"
fi
!

function displayResul(){
    if [ "$1" -eq 1 ]; then
        echo 	" -	-	-	-	-	-"
        echo 	" -					-"
	echo -e " -\033[32m		succssed		\033[0m-"
        echo 	" -					-"
        echo 	" -	-	-	-	-	-"
    else
        echo    " -	-	-	-	-	-"
        echo    " -					-"
        echo -e " -\033[31m		 failed			\033[0m-"
        echo    " -					-"
        echo    " -	-	-	-	-	-"

    fi
}

displayResul 1
displayResul 0
