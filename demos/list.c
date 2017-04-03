#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

/*
 * Basic linked list written solely to demo gdb walker linked-list
 */

typedef struct list {
    struct list *next;
    int32_t datum;
} list_t;


bool insert_entry(list_t **head, int32_t datum)
{
    if (head == NULL) {
        fprintf(stderr, "insert_entry(): Require non-NULL 'head'\n");
        return false;
    }

    list_t *newnode = calloc(1, sizeof(list_t));
    if (newnode == NULL) {
        fprintf(stderr, "insert_entry(): Failed to malloc memory\n");
        return false;
    }
    newnode->datum = datum;

    // Insert at head because I'm lazy.
    newnode->next = *head;
    *head = newnode;
    return true;
}

void free_list(list_t *head)
{
    while (head) {
      list_t *next = head->next;
      free(head);
      head = next;
    }
}

list_t *create_random_list(uint32_t seed)
{
    srand(seed);
    list_t *head = NULL;

    for (int i = 0; i < 10; ++i) {
        if (!insert_entry(&head, rand())) {
            fprintf(stderr, "Error inserting entry number %d\n", i);
            free_list(head);
            return NULL;
        }
    }

    return head;
}

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <seed>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    uint32_t seed = atoi(argv[1]);
    list_t *list_head = create_random_list(seed);
    free_list(list_head);
    return 0;
}
