#!/bin/bash
clear
printf "\n\n\tHello $USER Welcome to the Benchmarking Project\n\t"
printf "\n\tToday is \t";date
printf "\n\tNumber of user login :\t" ; who | wc -l
printf "\n\tEnter the Starting matrix Size for Matrix Multiplication: ";
read MstartI;
printf "\n\tEnter the Largest Matrix  Size for Matrix Multiplication";
read Mlast;
printf "\n\tEnter the Step Size for Matrix Multiplication";
read MStepsize;
NOW=$(date +"%F_%T");
sudo g++ -Ofast -msse2 -std=c++0x MaxPerformanceReturnsGFLOPStoScript.cpp -o Maxper -pthread  

#dstat -t -a --noheaders --output performancestat.csv &
printf "\n\t Now executing the Matrix Multiplication benchmark : \n\t"
for i in 1 2 3 4 5 6 7
  do
	Mstart=$MstartI;
	ResultFile="Result-$NOW-$Mstart-$Mlast.csv"
	while [ $Mstart -le $Mlast ]
	do
 		./Maxper ${Mstart} ${ResultFile}
 		Mstart=$(($Mstart + $MStepsize));
	done
  done
#pkill dstat
printf "\tMaximum maintained FLOPS for Matrix Multiplication Benchmark is : \n\t"
awk '$0>x{x=$0};END{print x}' ${ResultFile}
NOW=$(date +"%F_%T");
sudo g++ -Ofast -msse2 -std=c++0x testLuMultiThreadedDynamic.cpp -o eqnsolve 

printf "\n\n\t Now executing the Equation Solve benchmark without Thread at : $NOW \n\t "
printf "\n\tEnter the Starting matrix Size for Equation Solve: ";
read SstartI;
printf "\n\tEnter the Largest Matrix  Size for Equation Solve:";
read Slast;
printf "\n\tEnter the Step Size for Equation Solve:";
read SStepsize;
#for i in 1 2 3 4 5 6 7
 # do
	Sstart=$SstartI;
	ResultFile="Result-$NOW-$Sstart-$Slast.csv"
	while [ $Sstart -le $Slast ]
	do
 		./eqnsolve ${Sstart} ${ResultFile}
 		Sstart=$(($Sstart + $SStepsize));
	done
 # done
printf "\tMaximum maintained FLOPS for Equation Solve Benchmark is : \n\t"
awk '$0>x{x=$0};END{print x}' ${ResultFile}
echo "Benchmarking has been completed.";
echo "Please find the results in Results.csv file in Current folder."
exit 0
