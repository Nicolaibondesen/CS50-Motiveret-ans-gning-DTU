// Implements a dictionary's functionality

#include <ctype.h>
#include <stdbool.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <strings.h>

#include "dictionary.h"

// Represents a node in a hash table
typedef struct node
{
    char word[LENGTH + 1];
    struct node *next;
} node;


// TODO: Choose number of buckets in hash table
const unsigned int N = 26;

unsigned int total_words = 0;

// Hash table
node *table[N];

// Returns true if word is in dictionary, else false
bool check(const char *word)
{
    int hashCheck;
    node *ptr = NULL;

    hashCheck = hash(word);
    ptr = table[hashCheck];

    while (ptr != NULL)
    {
        if (strcasecmp(word, ptr -> word) == 0)
        {
            return true;
        }
        else
        {
        ptr = ptr -> next;
        }

    }
    return false;

}

// Hashes word to a number
unsigned int hash(const char *word)
{
    unsigned int hashValue = 0;

    for (int i = 0; word[i] != '\0'; i++)

    {
        hashValue += tolower(word[i]);
    }
    return hashValue % N;
}

// Loads dictionary into memory, returning true if successful, else false
bool load(const char *dictionary)
{

    char buffer[LENGTH + 1];
    FILE *source = fopen(dictionary, "r");
    if (source == NULL)
    {
        printf("Dictionary not found");
        return false;
    }

    while (fscanf(source, "%s\n", buffer) != EOF)
    {
        node *nn = malloc(sizeof(node));

        if (nn == NULL)
        {
            fclose(source);
            return false;
        }

        strcpy(nn -> word, buffer);
        nn -> next = NULL;


        int h = hash(buffer);

        if (table[h] == NULL)
        {
            table[h] = nn;
        }
        else
        {
        nn -> next = table[h];
        table[h] = nn;
        }
        total_words++;

    }
    fclose(source);
    return true;


}

// Returns number of words in dictionary if loaded, else 0 if not yet loaded
unsigned int size(void)
{

    return total_words;
}

// Unloads dictionary from memory, returning true if successful, else false
bool unload(void)
{
   node *tmp = NULL;
   node *cursor = NULL;

  for (int i = 0; i < N; i++)
  {
    cursor = table[i];
    tmp=table[i];

    while(cursor != NULL)
    {

        tmp = cursor;
        cursor = cursor -> next;
        free(tmp);

    }
  }
  return true;

}

