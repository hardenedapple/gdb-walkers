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
   vimcmd: let &makeprg="g++ -std=c++11 -O0 -Wall -W -g % -o %:r"
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

  // Hard code the numbers that go into this vector.
  // We want the same numbers each time for testing purposes.
  vector<int> data_elements {
      1283169405,
      89128932,
      2124247567,
      1902734705,
      2141071321,
      965494256,
      108111773,
      850673521,
      1140597833,
  };
  auto begin_it = data_elements.begin();
  auto end_it = data_elements.end();

  create_container<list<int>>(begin_it, end_it);
  create_container<vector<int>>(begin_it, end_it);

  // All things that require an iterator over pairs.
  // Make an iterator over pairs where the key is an index and the value is the
  // random element at that index.
  // This means that the order should be preserved in things like std::map
  vector<pair<int, int>> rand_pairs;
  for (size_t i = 0; i < data_elements.size(); ++i)
    rand_pairs.push_back(pair<int, int>(i, data_elements[i]));

  auto pair_begin_it = rand_pairs.begin();
  auto pair_end_it = rand_pairs.end();
  create_container<map<int, int>>(pair_begin_it, pair_end_it);

  return 0;
}
