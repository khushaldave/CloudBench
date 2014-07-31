clear
echo "Hello $USER Welcome to the Benchmarking Project"
echo "Today is ";date
echo "Number of user login :" ; who | wc -l
echo "Enter the Starting matrix Size : ";
read MstartI;
echo "Enter the Largest Matrix  Size";
read Mlast;
echo "Enter the Step Size";
read Ssize;
#echo "Enter the Number of Threads";
#read numThreads;
#echo "Enter the Total number of readings that needs to be taken";
#read numReadings;
#for i in `seq 2 $numReadings`
#do
#    echo "$i"
#echo "Enter the Number of threads for $i ";
#read numThreads[i-1];
#echo $numThreads[i-1];
#done
numThreads0="1";
numThreads1="2";
numThreads2="4";
numThreads3="8";
NOW=$(date +"%F");
g++ -Ofast -msse2 -std=c++0x BenchDynamic.cpp -o BenchDynamic -pthread  

for i in 1 2 3 4 5 6 7
  do
  	Mstart=$MstartI;
	ResultFile="Result-$NOW-$Mstart-$Mlast-${numThreads0}.csv"
	Mstart=$MstartI;
	while [ $Mstart -le $Mlast ]
	do
 		./BenchDynamic ${Mstart} ${numThreads0} ${ResultFile}
 		Mstart=$(($Mstart + $Ssize));
	done
	Mstart=$MstartI;
	ResultFile="Result-$NOW-$Mstart-$Mlast-${numThreads1}.csv"
		while [ $Mstart -le $Mlast ]
	do
 		./BenchDynamic ${Mstart} ${numThreads1} ${ResultFile}
 		Mstart=$(($Mstart + $Ssize));
	done

	Mstart=$MstartI;
	ResultFile="Result-$NOW-$Mstart-$Mlast-${numThreads2}.csv"
	while [ $Mstart -le $Mlast ]
	do
 		./BenchDynamic ${Mstart} ${numThreads2} ${ResultFile}
 		Mstart=$(($Mstart + $Ssize));
	done

	Mstart=$MstartI;
	ResultFile="Result-$NOW-$Mstart-$Mlast-${numThreads3}.csv"
	while [ $Mstart -le $Mlast ]
	do
 		./BenchDynamic ${Mstart} ${numThreads3} ${ResultFile}
 		Mstart=$(($Mstart + $Ssize));
	done
  done
echo "Benchmarking has been completed.";
echo "Please find the results in Results.csv file in Current folder."
exit 0
