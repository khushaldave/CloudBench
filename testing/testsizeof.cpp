#include <iostream>
float f;
int i;
double d;
int main()
{
              std::cout << "int: "     << sizeof(i)        << ' '
              << "float: "        << sizeof(f)       << ' '
              << "double: " << sizeof(d) << ' ';
}