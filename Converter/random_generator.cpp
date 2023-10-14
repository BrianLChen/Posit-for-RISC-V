#include <iostream>
#include <random>
#include <set>
#include <iomanip>
#include <windows.h>
#include <chrono>

int main()
{
    // std::random_device rd;

    auto currentTime = std::chrono::system_clock::now();

    // ת��Ϊ����
    auto milliseconds = std::chrono::duration_cast<std::chrono::milliseconds>(currentTime.time_since_epoch());

    // ��ȡ��������Ϊ����
    unsigned long seed = static_cast<unsigned long>(milliseconds.count());

    std::default_random_engine generator(seed);
    std::uniform_real_distribution<double> distribution(0.0, 0.5); // ��Χ��(0, 1]

    std::set<double> uniqueNumbers; // ���ڴ洢Ψһ������ļ���

    while (uniqueNumbers.size() < 20)
    {
        double randomValue = distribution(generator);
        std::cout << std::showpoint << std::fixed << std::setprecision(25) << ": " << randomValue << std::endl;

        // ���������Ƿ��Ѵ���
        // if (uniqueNumbers.find(randomValue) == uniqueNumbers.end()) {
        uniqueNumbers.insert(randomValue);
        Sleep(10);
        // }
    }

    // // ������ɵĲ�ͬ��˫���ȸ�����
    // int count = 1;
    // for (double number : uniqueNumbers)
    // {
    //     std::cout << std::showpoint << std::fixed << std::setprecision(25) << ": " << number << std::endl;
    //     count++;
    // }

    return 0;
}