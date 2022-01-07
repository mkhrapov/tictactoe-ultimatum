//
//  monte_carlo_tree_search.c
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


#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>


#include "monte_carlo_tree_search.h"

#define OPEN 0
#define CROS 1
#define NOUG 2
#define DONE 3

int calc_legal_moves(board_state *, int *);
int calc_smart_moves(board_state *, int *, int, int *);
int is_smart_move(board_state *, int);
void set(board_state *, int);
int playout(board_state *);
int is_terminal(board_state *);
int random_int(int);
int legal_move(board_state *, int);
int own_section(int);
int target_section(int);
int won(board_state *, int, int);
int entire_game_won_by(board_state *, int);
int entire_board_is_full(board_state *);
int full(board_state *, int);
void pretty_print(float *);


int section_locations[9][9] = {
    { 0,  1,  2,  9, 10, 11, 18, 19, 20},
    { 3,  4,  5, 12, 13, 14, 21, 22, 23},
    { 6,  7,  8, 15, 16, 17, 24, 25, 26},
    {27, 28, 29, 36, 37, 38, 45, 46, 47},
    {30, 31, 32, 39, 40, 41, 48, 49, 50},
    {33, 34, 35, 42, 43, 44, 51, 52, 53},
    {54, 55, 56, 63, 64, 65, 72, 73, 74},
    {57, 58, 59, 66, 67, 68, 75, 76, 77},
    {60, 61, 62, 69, 70, 71, 78, 79, 80}
};

int list_of_indexes[8][3] = {
    {0, 1, 2},
    {3, 4, 5},
    {6, 7, 8},
    {0, 3, 6},
    {1, 4, 7},
    {2, 5, 8},
    {0, 4, 8},
    {2, 4, 6}
};


int monte_carlo_tree_search(int iter_count, board_state *bs) {
    float scores[81];
    int legal_move_count;
    int legal_moves[81];
    int winner;
    int smart_move_count; // smart move is a move that does not immediately result in opponent win
    int smart_moves[81];
    board_state child;
    
    for(int i = 0; i < 81; i++) {
        scores[i] = 0.0;
        legal_moves[i] = -1;
        smart_moves[i] = -1;
    }
    
    legal_move_count = calc_legal_moves(bs, legal_moves);
    
    /*
        check for dumb moves
        if all moves are dumb - pick ramdom move from all legal moves
        if only one move not dumb - use that
        if two or moves are not dumb - run Monte Carlo Tree Search to pick among those
     */
    
    smart_move_count = calc_smart_moves(bs, legal_moves, legal_move_count, smart_moves);
    
    if(smart_move_count == 0) {
        return legal_moves[random_int(legal_move_count)];
    }
    else if(smart_move_count == 1) {
        return smart_moves[0];
    }
    
    // else pick from two or more smart moves
    
    for(int counter = 0; counter < iter_count; counter++) {
        for(int move_idx = 0; move_idx < smart_move_count; move_idx++) {
            int move = smart_moves[move_idx];
            memcpy(&child, bs, sizeof(board_state));
            set(&child, move);
            winner = playout(&child);
            if (winner == bs->player) {
                scores[move] += 1.0;
            }
            else if (winner == DONE) {
                scores[move] += 0.05;
            }
            
        }
        
        /*
        if((counter+1) % 100 == 0) {
            printf("%d\n", counter + 1);
            pretty_print(scores);
        }
        */
    }
    
    float max = 0.0;
    int winning_move = 0;
    
    for(int i = 0; i < 81; i++) {
        if (scores[i] > max) {
            winning_move = i;
            max = scores[i];
        }
    }
    
    return winning_move;
}


int calc_smart_moves(board_state *bs, int *legal_moves, int legal_move_count, int *smart_moves) {
    int counter = 0;
    
    for(int move_idx = 0; move_idx < legal_move_count; move_idx++) {
        int move = legal_moves[move_idx];
        if(is_smart_move(bs, move) == 1) {
            smart_moves[counter] = move;
            counter++;
        }
    }
    
    return counter;
}


int is_smart_move(board_state *bs, int move) {
    board_state current;
    board_state child;
    memcpy(&current, bs, sizeof(board_state));
    set(&current, move);
    int opponent = current.player;
    if(is_terminal(&current) == 1) {
        return 1;
    }
    
    int legal_move_count;
    int legal_moves[81];
    
    for(int i = 0; i < 81; i++) {
        legal_moves[i] = -1;
    }
    
    legal_move_count = calc_legal_moves(&current, legal_moves);
    
    for(int move_idx = 0; move_idx < legal_move_count; move_idx++) {
        int child_move = legal_moves[move_idx];
        memcpy(&child, &current, sizeof(board_state));
        set(&child, child_move);
        if(is_terminal(&child) == 1 && child.gameWon == opponent) {
            return 0;
        }
    }
    
    return 1;
}


/* legal_moves is an array of 81 ints */
int calc_legal_moves(board_state *bs, int *legal_moves) {
    int counter = 0;
    for(int i = 0; i < 81; i++) {
        if(legal_move(bs, i)) {
            legal_moves[counter] = i;
            counter++;
        }
    }
    return counter;
}


void set(board_state *bs, int move) {
    if(legal_move(bs, move) == 0) {
        return;
    }
    
    int current_section = own_section(move);
    bs->cells[move] = bs->player;
    
    if(won(bs, bs->player, current_section)) {
        bs->closedSegments[current_section] = bs->player;
        if(entire_game_won_by(bs, bs->player)) {
            bs->gameWon = bs->player;
        }
        else if(entire_board_is_full(bs)) {
            bs->gameWon = DONE;
        }
    }
    else if(full(bs, current_section)) {
        bs->closedSegments[current_section] = DONE;
        if(entire_board_is_full(bs)) {
            bs->gameWon = DONE;
        }
    }
    
    /* figure out next set of allowed positions */
    for(int i = 0; i < 9; i++) {
        bs->allowedSegments[i] = 0;
    }
    
    if(bs->gameWon == OPEN) {
        int next_section = target_section(move);
        if(bs->closedSegments[next_section] == OPEN) {
            bs->allowedSegments[next_section] = 1;
        }
        else {
            for(int i = 0; i < 9; i++) {
                if(bs->closedSegments[i] == OPEN) {
                    bs->allowedSegments[i] = 1;
                }
            }
        }
    }
    
    
    /* finishing touches */
    if(bs->player == CROS) {
        bs->player = NOUG;
    }
    else {
        bs->player = CROS;
    }
}


int playout(board_state *bs) {
    int legal_move_count;
    int legal_moves[81];
    
    while(!is_terminal(bs)) {
        for(int i = 0; i < 81; i++) {
            legal_moves[i] = -1;
        }
        
        legal_move_count = calc_legal_moves(bs, legal_moves);
        if(legal_move_count == 0) {
            /* printf("No legal moves. Game state %d\n", bs->gameWon); */
            break;
        }
        set(bs, legal_moves[random_int(legal_move_count)]);
    }
    
    return bs->gameWon;
}


int is_terminal(board_state *bs) {
    if(bs->gameWon != OPEN) {
        return 1;
    }
    return 0;
}


int random_int(int limit) {
    static int been_called = 0;
    
    if(been_called == 0) {
        been_called = 1;
        srand((unsigned int)time(NULL));
    }
    
    return rand() % limit;
}


int legal_move(board_state *bs, int move) {
    if(bs->gameWon != OPEN) {
        return 0;
    }
    
    if(move > 80) {
        return 0;
    }
    
    if(move < 0) {
        return 0;
    }
    
    int section = own_section(move);
    if(bs->allowedSegments[section] == 0) {
        return 0;
    }
    
    if(bs->cells[move] == OPEN) {
        return 1;
    }
    return 0;
}


int own_section(int move) {
    int y = move / 9;
    int x = move % 9;
    return 3*(y/3) + (x/3);
}


int target_section(int move) {
    int y = move / 9;
    int x = move % 9;
    return 3*(y%3) + (x%3);
}


int won(board_state *bs, int player, int sec) {
    for(int row = 0; row < 8; row++) {  /* row in list_of_indexes */
        int relative_position1 = list_of_indexes[row][0];
        int relative_position2 = list_of_indexes[row][1];
        int relative_position3 = list_of_indexes[row][2];
        
        int actual_position1 = section_locations[sec][relative_position1];
        int actual_position2 = section_locations[sec][relative_position2];
        int actual_position3 = section_locations[sec][relative_position3];
        
        if(
           bs->cells[actual_position1] == player &&
           bs->cells[actual_position2] == player &&
           bs->cells[actual_position3] == player
           ) {
            return 1;
        }
    }
    
    return 0;
}


int entire_game_won_by(board_state *bs, int player) {
    for(int row = 0; row < 8; row++) {  /* row in list_of_indexes */
        int sec1 = list_of_indexes[row][0];
        int sec2 = list_of_indexes[row][1];
        int sec3 = list_of_indexes[row][2];
        
        if(
           bs->closedSegments[sec1] == player &&
           bs->closedSegments[sec2] == player &&
           bs->closedSegments[sec3] == player
           ) {
            return 1;
        }
    }
    
    return 0;
}


int entire_board_is_full(board_state *bs) {
    for(int sec = 0; sec < 9; sec++) {
        if(bs->closedSegments[sec] == OPEN) {
            return 0;
        }
    }
    return 1;
}


int full(board_state *bs, int sec) {
    for(int i = 0; i < 9; i++) {
        int location = section_locations[sec][i];
        if(bs->cells[location] == OPEN) {
            return 0;
        }
    }
    return 1;
}


void pretty_print(float *scores) {
    for(int y = 0; y < 9; y++) {
        for(int x = 0; x < 9; x++) {
            int i = y*9 + x;
            
            printf("%10.2f", scores[i]);
        }
        printf("\n");
    }
    printf("\n\n\n");
}
