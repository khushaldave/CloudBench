/*
*   @Author  : Khushal Dave
*   @Purpose : Main Class for executing benchmarking Code
*   @Date    : 4th July 2014

*   @Compiler Flags used : -Ofast -msse2 -std=c++0x  

*  -Ofast     : For highly optimized code for maths 
*  -msse2      : enabling vectorization sse2 
*  -std=c++0x  : To tell compiler to support C++11 standard version

*   @Linker Flags used : -pthread  // for thread support
*   @Project-Details : MSC(Cloud Computing) Research Dissertation
*/

#include "Eigen/Dense"
#include <iostream>
#include <ctime>
#include <chrono>
#include <thread>
#include <ratio>
#include <mutex>
#include <pthread.h>
#include <cstring>
#include <omp.h>
#include <fstream>


using namespace std;
using namespace Eigen;
using std::chrono::system_clock;
std::mutex mtx,iomutex;
std::ofstream ofs,olog;


    long N;
    int Num_Of_Threads;
    long long Num_Of_Op;
    long double mInopsCount=0.0;
    MatrixXi X = MatrixXi::Random( N, N);
    MatrixXi Y = MatrixXi::Random( N, N);
    std::vector<std::thread> threads;
    string ResultFileName;
    long double totalTime=0.0;

double diffclock(clock_t clock1,clock_t clock2);
void CalculateResult(int,int);
const std::string currentTimeStamp();

int main( int argc, char *argv[] ) 
{
    if ( argc != 3 ) {
        printf("ERROR: Needs 3 arguments -- Size of Matrix, Number of Threads, File Name \n");
        return -1;
    }
    
    long N = atoi( argv[1] );
    Num_Of_Op=(long long)N*N*N;
    ResultFileName=argv[2];
    X = MatrixXi::Random( N, N);
    Y = MatrixXi::Random( N, N);
    olog.open ("LogsA1.txt", std::ofstream::out | std::ofstream::app);
    ofs.open (ResultFileName, std::ofstream::out | std::ofstream::app);
     if(ofs==NULL||olog==NULL)
     {
        cerr<<"Could not open the Results file."<<endl;
     }
     unsigned int n = std::thread::hardware_concurrency();
    olog << n << " concurrent threads are supported.\n";
   olog<< endl<<" ******************************** "<< "Measuring performance at "<< currentTimeStamp() <<"  ****************************" <<endl;
     int numCPU = sysconf( _SC_NPROCESSORS_ONLN );


     olog<< endl<<"Number of Independent Cores in this System are : " <<numCPU<< endl;

    std::chrono::time_point<std::chrono::system_clock> start,end;
    start = std::chrono::system_clock::now();
     Eigen::initParallel();

 
   for(int j=0;j<numCPU;j++)
   {
    threads.push_back(std::thread(CalculateResult,j+1,N)); 
   }
    for (auto& th : threads) th.join();

    end = std::chrono::system_clock::now();
    std::chrono::duration<double> elapsed =end-start;
    olog<< "Elapsed time: " << elapsed.count()<<endl;
    ofs.precision(10);
    ofs<<mInopsCount<<endl;
    ofs.close();
    //CalculatePerformance
    olog<<endl<<'\t'<< "Performance tests have been executed Successfully."<< endl;
    olog<<endl<<'\t'<< "Please find the results in Console in the Current exection shell"<<'\n'<<'\n';
    return 0;
}

void CalculateResult(int thread_id,int order)
{
    std::this_thread::get_id();
    MatrixXi R;
    std::chrono::time_point<std::chrono::system_clock> tstart,tend;
    tstart = std::chrono::system_clock::now();

    R.noalias() = X * Y ;
    tend = std::chrono::system_clock::now();
    std::chrono::duration<double> elapsed = tend-tstart;
    mtx.lock();
   // std::lock_guard<std::mutex> lk(iomutex);
    mInopsCount+=((2*(Num_Of_Op/1000000))/(long double)(elapsed.count()));
    mtx.unlock();

}


// This will display the current date/time in the format YYYY-MM-DD.HH:mm:ss
// ****** returning const because we are returning buf here ******
const std::string currentTimeStamp() {
   
    struct tm  timestruct;
    time_t     timenow = time(0);
    char       buf[80];
    timestruct = *localtime(&timenow);
    strftime(buf, sizeof(buf), "%Y-%m-%d.%X", &timestruct);

    return buf;
}





