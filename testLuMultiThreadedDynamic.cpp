#include "Eigen/Dense"
#include <iostream>
#include <ctime>
#include <chrono>
#include <mutex>
#include <cstring>
#include <fstream>

using namespace std;
using namespace Eigen;
using std::chrono::system_clock;
std::ofstream ofs,olog;
string ResultFileName;
long N;

 MatrixXd A = MatrixXd::Random( N, N);
 MatrixXd B = MatrixXd::Random( N, N);
 MatrixXd X = MatrixXd::Random( N, N);

int main(int argc, char *argv[])
{
	 if ( argc != 3 ) {
        printf("ERROR: Needs 3 arguments -- Number of Matrix, Number of Threads, File Name \n");
        return -1;
    }
    
    long N = atoi( argv[1] );
    ResultFileName=argv[2];
	A = MatrixXd::Random(N,N);
	B = MatrixXd::Random(N,N);
	olog.open ("LogsA1.txt", std::ofstream::out | std::ofstream::app);
	ofs.open (ResultFileName, std::ofstream::out | std::ofstream::app);
     if(ofs==NULL||olog==NULL)
     {
        cerr<<"Could not open the Results file."<<endl;
     }
	double ops = ( double ) ( 2 * N * N * N ) / 3.0 + 2.0 * ( double ) ( N * N );	
    std::chrono::time_point<std::chrono::system_clock> start,end;
    start = std::chrono::system_clock::now();
    {
 		X = A.lu().solve(B);
 	}
   end = std::chrono::system_clock::now();
    std::chrono::duration<double> elapsed =end-start;
    olog<< "Elapsed time: " << elapsed.count()<<endl;
    ofs.precision(10);
    ofs<<(ops/elapsed.count())/1000000<<endl;

	olog<< "Here is the (unique) solution X to the equation AX=B:" << endl <<"Number of Equations are : "<< N<< endl;
	olog<< "Relative error: " << (A*X-B).norm() / B.norm() << endl;
}