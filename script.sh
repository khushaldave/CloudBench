clear
echo "Hello $USER Welcome to the Benchmarking Project"
echo "Today is ";date
echo "Number of user login :" ; who | wc -l
echo "Enter the Starting matrix Size : ";
read Mstart;
echo "Enter the Largest Matrix  Size";
read Mlast;
echo "Enter the Step Size";
read Ssize;
echo "Enter the Number of Threads";
read numThreads;
NOW=$(date +"%F");
ResultFile="Result-$NOW-$Mstart-$Mlast-$numThreads.csv"
g++ -Ofast -msse2 -std=c++0x BenchDynamic.cpp -o BenchDynamic -pthread  
	while [ $Mstart -le $Mlast ]
	do
 		./BenchDynamic ${Mstart} ${numThreads} ${ResultFile}
 		Mstart=$(($Mstart + $Ssize));
	done

echo "Benchmarking has been completed.";
echo "Please find the results in Results.csv file in Current folder."
exit 0
