#include <stdio.h>
#include <stdlib.h>

union posit
{
  float f;
  unsigned int i;
};

union posit pi, ONE, P_100, Min;

int main(int argc, char *argv[])
{
  pi.i = 0x4c90fdaa;    // value of Pi = 3.141592651605606
  ONE.i = 0x40000000;   // value 1 in posit format
  P_100.i = 0x6a400000; // value 100 in posit
  Min.i = 0x00000001;   // value of minimum posit
  printf("---------------- Posit custom function start ----------------\n");

  union posit temp, temp_count;
  volatile union posit sum, count, mid_value;

  sum.i = 0x00000000; // initial sum to 0
  temp.i = 0x40000000;
  count.i = 0x00000000;
  temp_count.i = 0x78331115;

  int i = 0;
  for (i;; i++)
  {
    mid_value.f = ONE.f / (P_100.f * count.f + pi.f);
    if (temp_count.f != count.f)
    {
      sum.f += mid_value.f;
    }

    if (mid_value.f == Min.f)
    {
      printf("[%d - %08x], %08x, %08x \n Value of mid_value reach minimum. Program finish\n", i, count.i, sum.i, mid_value.i);
      break;
    }
    else if (temp_count.f == count.f)
    {
      printf("[%d - %08x], %08x, %08x \n Value of n is equal to previous n. Program finish\n", i, temp.i, sum.i, mid_value.i);
      break;
    }
    else if (temp.f != sum.f)
    {
      // printf("[%d], %08x \n", i, sum.i);
      if (i % 5000 == 0)
      {
        printf("[%d - %08x], %08x, %08x \n", i, count.i, sum.i, mid_value.i);
      }
      // continue;
    }
    else if (temp.f == sum.f)
    {
      printf("[%d - %08x], %08x, %08x \n value same finish calulation \n", i, count.i, sum.i, mid_value.i);
      break;
    }
    else
    {
      printf("error \n");
    }
    temp.f = sum.f;
    temp_count.f = count.f;
    count.f += ONE.f;
  }

  i--; // as in the final loop, the value is the same.

  printf("\n reverse calculation \n");
  printf("initial [%d], %08x \n", i, sum.i);
  for (i; i >= 0; i--)
  {
    count.f -= ONE.f;
    //mid_value.f = ONE.f / (P_100.f * count.f + pi.f);
    //sum.f -= mid_value.f;
    if (i % 5000 == 0)
    {
      printf("[%d - %08x], %08x, %08x \n", i, count.i, sum.i, mid_value.i);
    }
    sum.f -= mid_value.f;
    mid_value.f = ONE.f / (P_100.f * count.f + pi.f);
    //count.f -= ONE.f;
  }
  //printf("\nreverse final value [%d], %08x \n", i, sum.i);
  printf("Finish reverse calculation. \n");

  printf("----------------- Posit custom function end -----------------\n");

  return EXIT_SUCCESS;
}