#include <iostream>
#include <bitset>
#include <string>

using namespace std;

int transfer();
int Separate();
void decimalToBinary(unsigned &binaryResult, int decimalNumber);

int main()
{
    // bool a, b;
    // cout << "input b = ";
    // cin >> b;
    // a = ~b;
    // cout << sizeof(b) << endl;
    // cout << a << endl;
    // cout << bitset<10>(b) << "," << bitset<10>(a) << endl;
    // transfer();
    unsigned temp = Separate();
    unsigned output;
    decimalToBinary(output, temp);
    cout << "�����Ʊ�ʾ: " << bitset<32>(output) << endl;

        return 0;
}

int transfer()
{
    int32_t integer;
    uint32_t fraction;
    cin >> integer >> fraction;
    cout << integer << "." << fraction << endl;
    cout << bitset<32>(integer + fraction) << endl;

    return 0;
}

int Separate()
{
    double decimalNumber;

    // ����ʮ����С��
    std::cout << "����һ��ʮ����С��: ";
    std::cin >> decimalNumber;

    // ��С��ת��Ϊ�ַ���
    std::string decimalString = std::to_string(decimalNumber);

    // ����С�����λ��
    size_t decimalPointPos = decimalString.find('.');

    unsigned unsignedIntegerPart;

    // ����ҵ�С����
    if (decimalPointPos != std::string::npos)
    {
        // ��ȡ�������ֲ�ת��Ϊ�޷�������
        std::string integerPart = decimalString.substr(0, decimalPointPos);
        unsignedIntegerPart = std::stoul(integerPart);

        // ��ȡС�����ֲ�ת��Ϊ�޷�������
        std::string decimalPart = decimalString.substr(decimalPointPos + 1);
        unsigned unsignedDecimalPart = std::stoul(decimalPart);

        // ������
        std::cout << "��������: " << unsignedIntegerPart << std::endl;
        std::cout << "С������: " << unsignedDecimalPart << std::endl;
        // return unsignedIntegerPart;
    }
    else
    {
        // ���û��С���㣬��������Ϊ��������
         unsignedIntegerPart = std::stoul(decimalString);
        std::cout << "��������: " << unsignedIntegerPart << std::endl;
        std::cout << "С������: 0" << std::endl;
        // return unsignedIntegerPart;
    }
        return unsignedIntegerPart;

    // return 0;
}

void decimalToBinary(unsigned &binaryResult, int decimalNumber)
{
    binaryResult = 0; // ��ʼ�������ƽ��Ϊ0

    int bitPosition = 0; // λ��λ��

    while (decimalNumber > 0)
    {
        // ȡ�����λ
        int remainder = decimalNumber % 2;

        // �����λ��������ƽ��
        binaryResult += remainder << bitPosition;

        // ����ʮ��������׼��������һλ
        decimalNumber /= 2;

        // ����λ��λ��
        ++bitPosition;
    }
}