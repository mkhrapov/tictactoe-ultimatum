//
//  monte_carlo_tree_search.h
//  TicTacToeUltimatum
//
//  Created by Maksim Khrapov on 5/18/19.
//  Copyright © 2019 Maksim Khrapov. 
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#ifndef monte_carlo_tree_search_h
#define monte_carlo_tree_search_h

#include <inttypes.h>


typedef struct board_state {
    int8_t cells[81];
    int8_t allowedSegments[9];
    int8_t closedSegments[9];
    int8_t player;
    int8_t gameWon;
} board_state;


int monte_carlo_tree_search(int iter_count, board_state *);



#endif /* monte_carlo_tree_search_h */
