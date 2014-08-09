#!/bin/bash
clear
printf "*****************************************  WELCOME  *******************************************"
printf "\n\tHello $USER Welcome to the Benchmarking Project\n\t"
printf "\n\tToday is : ";date
printf "\n\tNumber of user login :\t" ; who | wc -l
printf "\n\tEnter the Starting matrix Size for Matrix Multiplication : ";
read MstartI;
printf "\tEnter the Largest Matrix  Size for Matrix Multiplication : ";
read Mlast;
printf "\tEnter the Step Size for Matrix Multiplication : ";
read MStepsize;
NOW=$(date +"%F_%T");
sudo g++ -Ofast -msse2 -std=c++0x MaxPerformanceReturnsGFLOPStoScript.cpp -o MaxperD -pthread  

#dstat -t -a --noheaders --output performancestat.csv &
printf "\n\tNow executing the Matrix Multiplication benchmark for Double Data Type: \n"
for i in 1 2 3 4 5 6 7
  do
	Mstart=$MstartI;
	ResultFile="Result-$NOW-$Mstart-$Mlast.csv"
	while [ $Mstart -le $Mlast ]
	do
 		./MaxperD ${Mstart} ${ResultFile}
 		Mstart=$(($Mstart + $MStepsize));
	done
  done
#pkill dstat
printf "\tMaximum maintained FLOPS for Matrix Multiplication Benchmark with DOUBLE data type is GFLOPS :\t"
awk '$0>x{x=$0};END{print x}' ${ResultFile}
rm ${ResultFile}
printf "\n\tNow performing the Benchmark with FLOAT data values : \n"

sudo g++ -Ofast -msse2 -std=c++0x MaxPerformanceGFLOPSforFloat.cpp -o MaxperF -pthread  
NOW=$(date +"%F_%T");
for i in 1 2 3 4 5 6 7
  do
	Mstart=$MstartI;
	ResultFile="Result-$NOW-$Mstart-$Mlast.csv"
	while [ $Mstart -le $Mlast ]
	do
 		./MaxperF ${Mstart} ${ResultFile}
 		Mstart=$(($Mstart + $MStepsize));
	done
  done
#pkill dstat
printf "\n\tMaximum maintained FLOPS for Matrix Multiplication with FLOAT Benchmark is : "
awk '$0>x{x=$0};END{print x}' ${ResultFile}
rm ${ResultFile}
printf "\n\tNow performing the Benchmark with INTEGER data values : \n"

sudo g++ -Ofast -msse2 -std=c++0x MaxPerformanceGINOPSforInt.cpp -o MaxperI -pthread  
NOW=$(date +"%F_%T");
for i in 1 2 3 4 5 6 7
  do
	Mstart=$MstartI;
	ResultFile="Result-$NOW-$Mstart-$Mlast.csv"
	while [ $Mstart -le $Mlast ]
	do
 		./MaxperI ${Mstart} ${ResultFile}
 		Mstart=$(($Mstart + $MStepsize));
	done
  done
#pkill dstat
printf "\n\tMaximum maintained FLOPS for Matrix Multiplication with INTEGER Benchmark is : "
awk '$0>x{x=$0};END{print x}' ${ResultFile}
rm ${ResultFile}
NOW=$(date +"%F_%T");
sudo g++ -Ofast -msse2 -std=c++0x testLuMultiThreadedDynamic.cpp -o eqnsolve -pthread

printf "\n\tNow executing the Equation Solve benchmark with Multi-thread at : $NOW \n "
printf "\n\tEnter the Starting matrix Size for Equation Solve : ";
read SstartI;
printf "\n\tEnter the Largest Matrix  Size for Equation Solve : ";
read Slast;
printf "\n\tEnter the Step Size for Equation Solve : ";
read SStepsize;
for i in 1 2 3 4 5 6 7
 do
	Sstart=$SstartI;
	ResultFile="Result-$NOW-$Sstart-$Slast.csv"
	while [ $Sstart -le $Slast ]
	do
 		./eqnsolve ${Sstart} ${ResultFile}
 		Sstart=$(($Sstart + $SStepsize));
	done
  done
printf "\n\tMaximum maintained FLOPS for Equation Solve Benchmark is : "
awk '$0>x{x=$0};END{print x}' ${ResultFile}
printf "FLOPS"
rm ${ResultFile}
NOW=$(date +"%F_%T");
sudo g++ -Ofast -msse2 -std=c++0x testLuBasic.cpp -o eqnsolveThread 

printf "\n\tNow executing the Equation Solve benchmark without Thread at : $NOW \n\t "
for i in 1 2 3 4 5 6 7
 do
	Sstart=$SstartI;
	ResultFile="Result-$NOW-$Sstart-$Slast.csv"
	while [ $Sstart -le $Slast ]
	do
 		./eqnsolveThread ${Sstart} ${ResultFile}
 		Sstart=$(($Sstart + $SStepsize));
	done
  done
printf "\tMaximum maintained FLOPS for Equation Solve Benchmark is : "
awk '$0>x{x=$0};END{print x}' ${ResultFile}
printf "FLOPS"
rm ${ResultFile}
printf "\n\n\tBenchmarking has been completed.";
#printf "\n\tPlease find the results in Results.csv file in Current folder."
exit 0
