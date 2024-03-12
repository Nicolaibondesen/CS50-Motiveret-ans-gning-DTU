#include <cs50.h>
#include <stdio.h>

int main(void)

{
    int n;
    do
    {
    n = get_int("Height");
    }
        while (n > 8 || n < 1);

    for (int line = 0; line < n; line++)
    {
      for (int space = n-line; space > 1; space--)
      {
        printf(" ");
      }
      for (int hash = 0; hash <= line; hash++)
      {
        printf("#");
      }
      printf("\n");
    }
}
