#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <time.h>

/*
 * Basic binary tree structure written solely to demo my gdb walkers.
 */

typedef struct node {
    struct node* children[2];
    int32_t datum;
} node_t;

typedef enum direction_t {
    smaller = 0,
    larger = 1
} direction;


bool insert_entry(node_t *root, int32_t datum)
{
    if (root == NULL) {
        fprintf(stderr, "insert_entry(): Require non-NULL 'root'\n");
        return false;
    }

    node_t *newnode = calloc(1, sizeof(node_t));
    if (newnode == NULL) {
        fprintf(stderr, "insert_entry(): Failed to malloc memory\n");
        return false;
    }
    newnode->datum = datum;

    node_t *cur = root;
    while (cur) {
        direction dir = cur->datum < datum ? larger : smaller;
        node_t *subtree = cur->children[dir];
        if (subtree == NULL) {
            cur->children[dir] = newnode;
            return true;
        }
        cur = subtree;
    }

    // Should never get here
    abort();
    return false;
}

void free_tree(node_t *root)
{
    if (root) {
        free_tree(root->children[larger]);
        free_tree(root->children[smaller]);
        free(root);
    }
}

node_t *create_tree(int32_t root_datum)
{
    node_t *root = calloc(1, sizeof(node_t));
    root->datum = root_datum;
    return root;
}

node_t *create_random_tree(uint32_t seed)
{
    srand(seed);
    node_t *root = create_tree(rand());

    for (int i = 0; i < 10; ++i) {
        if (!insert_entry(root, rand())) {
            fprintf(stderr, "Error inserting entry number %d\n", i);
            free_tree(root);
            return NULL;
        }
    }

    return root;
}

int main(int argc, char *argv[])
{
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <seed>\n", argv[0]);
        exit(EXIT_FAILURE);
    }

    uint32_t seed = atoi(argv[1]);
    node_t *tree_root = create_random_tree(seed);
    free_tree(tree_root);
    return 0;
}
