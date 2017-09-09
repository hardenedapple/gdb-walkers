#include <iostream>
#include <iterator>
#include <algorithm>
#include <tuple>
#include <random>
#include <list>
#include <vector>
#include <utility>
#include <map>


using namespace std;

/*
   vimcmd: let &makeprg="g++ -Wall -W -g % -o %:r"
   Some functions to create a few STL containers.
   I should then be able to test my walkers on these containers.
 */

// Just create a random container so I can test my gdb extensions on it.
template<typename container, typename Iter>
void create_container(Iter start, Iter end)
{
  container rand_container(start, end);
after_defined:
  return;
}

int main(int argc, char *argv[])
{
  if (argc != 2) {
      fprintf(stderr, "Usage: %s <seed>\n", argv[0]);
      exit(EXIT_FAILURE);
  }

  random_device rd;
  mt19937 gen(rd());
  gen.seed(stoi(string(argv[1])));
  uniform_int_distribution<> dis;

  // We generate the random numbers first, then use them to create the
  // containers we want later.
  // This is because we want the same numbers each time (for testing purposes)
  // and hence want to save the values rather than reseed and generate for each
  // new container type.
  vector<int> rand_elements;
  generate_n(back_inserter(rand_elements),
	     10,
	     [&]() { return dis(gen); });

  auto begin_it = rand_elements.begin();
  auto end_it = rand_elements.end();

  create_container<list<int>>(begin_it, end_it);
  create_container<vector<int>>(begin_it, end_it);

  // All things that require an iterator over pairs.
  // Make an iterator over pairs where the key is an index and the value is the
  // random element at that index.
  // This means that the order should be preserved in things like std::map
  vector<pair<int, int>> rand_pairs;
  for (size_t i = 0; i < rand_elements.size(); ++i)
    rand_pairs.push_back(pair<int, int>(i, rand_elements[i]));

  auto pair_begin_it = rand_pairs.begin();
  auto pair_end_it = rand_pairs.end();
  create_container<map<int, int>>(pair_begin_it, pair_end_it);

  return 0;
}
