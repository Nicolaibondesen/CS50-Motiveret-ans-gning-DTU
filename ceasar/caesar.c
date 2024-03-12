#include <cs50.h>
#include <stdio.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>

void cipher_text(string input, int key);

int main(int argc, string argv[])
{
    if (argc == 2)
    {

        for (int i = 0; i < strlen(argv[1]); i++)
        {
            if (isdigit(argv[1][i]) == false)
            {
                printf("Usage: ./caesar key\n");
                return 1;
            }
        }


        int key = atoi(argv[1]);

        string input = get_string("Plaintext: ");

        printf("ciphertext: ");

        cipher_text(input, key);
    }
    else
    {
        printf("Usage: ./caesar key\n");
        return 1;
    }

    printf("\n");
}

void cipher_text(string input, int key)
{
    for (int i = 0; i < strlen(input); i++)
    {
        if (input[i] >= 'a' && input[i] <= 'z')
        {
            printf("%c", ((input[i] - 'a' + key) % 26) + 'a');
        }

        if (input[i] >= 'A' && input[i] <= 'Z')
        {
            printf("%c", ((input[i] - 'A' + key) % 26) + 'A');
        }

        else if (isalpha(input[i]) == false)
        {
            printf("%c", input[i]);
        }

    }
}
