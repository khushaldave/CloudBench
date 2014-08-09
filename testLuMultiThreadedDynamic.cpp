#include "Eigen/Dense"
#include <iostream>
#include <ctime>
#include <chrono>
#include <mutex>
#include <cstring>
#include <fstream>
#include <thread>
#include <pthread.h>

using namespace std;
using namespace Eigen;
using std::chrono::system_clock;
std::ofstream ofs,olog;
string ResultFileName;
std::mutex mtx,iomutex;

 long N;
 double ops=0.0,flopscount=0.0;
 std::vector<std::thread> threads;
 MatrixXd A = MatrixXd::Random( N, N);
 MatrixXd B = MatrixXd::Random( N, N);
 //MatrixXd X = MatrixXd::Random( N, N);
 void calculateResult(int,int);

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
     Eigen::initParallel();
    int numCPU = sysconf( _SC_NPROCESSORS_ONLN );
	ops = ( double )( ((2 * N * N * N ) / 3.0) + (2.0 * ( double ) ( N * N )));	
    std::chrono::time_point<std::chrono::system_clock> start,end;
    start = std::chrono::system_clock::now();

    for(int j=0;j<numCPU;j++)
    {
      threads.push_back(std::thread(calculateResult,j+1,N)); 
    }
    for (auto& th : threads) th.join();

   
   end = std::chrono::system_clock::now();
    std::chrono::duration<double> elapsed =end-start;
    olog<< "Elapsed time: " << elapsed.count()<<endl;
    ofs.precision(10);
    //ofs<<(ops/elapsed.count())/1000000<<endl;
    ofs<<flopscount<<endl;

	// olog<< "Here is the (unique) solution X to the equation AX=B:" << endl <<"Number of Equations are : "<< N<< endl;
	// olog<< "Relative error: " << (A*X-B).norm() / B.norm() << endl;
}
void calculateResult(int thread_id,int N)
{
    std::this_thread::get_id();
    MatrixXd X;
    std::chrono::time_point<std::chrono::system_clock> tstart,tend;
    tstart = std::chrono::system_clock::now();
    {
        X.noalias() = A.lu().solve(B);
    }
    tend = std::chrono::system_clock::now();
    std::chrono::duration<double> elapsed = tend-tstart;
    mtx.lock();
    //std::lock_guard<std::mutex> lk(iomutex);
    flopscount+=(((ops/1000000))/(long double)(elapsed.count()));
    mtx.unlock();
    olog<<elapsed.count()<<endl;
  //  olog<< "Here is the (unique) solution X to the equation AX=B:" << endl <<"Number of Equations are : "<< N<< endl;
	//olog<< "Relative error: " << (A*X-B).norm() / B.norm() << endl;
}