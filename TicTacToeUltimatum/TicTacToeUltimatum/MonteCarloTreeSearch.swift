//
//  MonteCarloTreeSearch.swift
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


import Foundation


final class MonteCarloTreeSearch {
    let boardState: BoardState
    
    
    init(_ boardState: BoardState) {
        self.boardState = boardState
    }
    
    
    func basic(_ iterCount: Int) -> (Int, Int) {
        let moves = boardState.allLegalMoves()
        let whoami = boardState.player
        var counts: [Double] = Array(repeating: 0.0, count: moves.count)
        
        for _ in 0..<iterCount {  // was c
            for i in 0..<counts.count {
                let (x, y) = moves[i]
                let child = boardState.clone()
                _ = child.set(x, y)
                let res = playout(child)
                if res == whoami {
                    counts[i] += 1.0
                }
                else if res == DONE {
                    counts[i] += 0.05  // What would a good value be?
                }
            }
            
            /*
            print(c)
            if c % 100 == 0 {
                prettyPrint(counts)
            }
 */
        }
        
        let maxCount = counts.max()!
        let maxIndex = counts.firstIndex(of: maxCount)!
        
        //prettyPrint(counts)
        
        return moves[maxIndex]
    }
    
    
    func playout(_ state: BoardState) -> Int {
        while !state.isTerminal() {
            let moves = state.allLegalMoves()
            if moves.count == 0 {
                break
            }
            let index = Int.random(in: 0..<moves.count)
            let (x, y) = moves[index]
            _ = state.set(x, y)
        }
        
        return state.gameWon
    }
    
    
    func prettyPrint(_ counts: [Double]) {
        for y in 0..<9 {
            for x in 0..<9 {
                let i = y*9 + x
                print(String(format: " %7.1f", counts[i]), terminator: "")
            }
            print()
        }
    }
    
    
    
    func bridge_to_c(_ iterCount: Int) -> (Int, Int) {
        let bs_p = UnsafeMutablePointer<board_state>.allocate(capacity: 1)
        
        let bs_int8 = BoardStateInt8(boardState)
        
        bs_p.pointee.player = bs_int8.player
        bs_p.pointee.gameWon = bs_int8.gameWon
        
        bs_p.pointee.allowedSegments = (
            bs_int8.allowedSegments[0],
            bs_int8.allowedSegments[1],
            bs_int8.allowedSegments[2],
            bs_int8.allowedSegments[3],
            bs_int8.allowedSegments[4],
            bs_int8.allowedSegments[5],
            bs_int8.allowedSegments[6],
            bs_int8.allowedSegments[7],
            bs_int8.allowedSegments[8]
        )
        
        bs_p.pointee.closedSegments = (
            bs_int8.closedSegments[0],
            bs_int8.closedSegments[1],
            bs_int8.closedSegments[2],
            bs_int8.closedSegments[3],
            bs_int8.closedSegments[4],
            bs_int8.closedSegments[5],
            bs_int8.closedSegments[6],
            bs_int8.closedSegments[7],
            bs_int8.closedSegments[8]
        )
        
        bs_p.pointee.cells = (
            bs_int8.cells[0],
            bs_int8.cells[1],
            bs_int8.cells[2],
            bs_int8.cells[3],
            bs_int8.cells[4],
            bs_int8.cells[5],
            bs_int8.cells[6],
            bs_int8.cells[7],
            bs_int8.cells[8],
            bs_int8.cells[9],
            bs_int8.cells[10],
            bs_int8.cells[11],
            bs_int8.cells[12],
            bs_int8.cells[13],
            bs_int8.cells[14],
            bs_int8.cells[15],
            bs_int8.cells[16],
            bs_int8.cells[17],
            bs_int8.cells[18],
            bs_int8.cells[19],
            bs_int8.cells[20],
            bs_int8.cells[21],
            bs_int8.cells[22],
            bs_int8.cells[23],
            bs_int8.cells[24],
            bs_int8.cells[25],
            bs_int8.cells[26],
            bs_int8.cells[27],
            bs_int8.cells[28],
            bs_int8.cells[29],
            bs_int8.cells[30],
            bs_int8.cells[31],
            bs_int8.cells[32],
            bs_int8.cells[33],
            bs_int8.cells[34],
            bs_int8.cells[35],
            bs_int8.cells[36],
            bs_int8.cells[37],
            bs_int8.cells[38],
            bs_int8.cells[39],
            bs_int8.cells[40],
            bs_int8.cells[41],
            bs_int8.cells[42],
            bs_int8.cells[43],
            bs_int8.cells[44],
            bs_int8.cells[45],
            bs_int8.cells[46],
            bs_int8.cells[47],
            bs_int8.cells[48],
            bs_int8.cells[49],
            bs_int8.cells[50],
            bs_int8.cells[51],
            bs_int8.cells[52],
            bs_int8.cells[53],
            bs_int8.cells[54],
            bs_int8.cells[55],
            bs_int8.cells[56],
            bs_int8.cells[57],
            bs_int8.cells[58],
            bs_int8.cells[59],
            bs_int8.cells[60],
            bs_int8.cells[61],
            bs_int8.cells[62],
            bs_int8.cells[63],
            bs_int8.cells[64],
            bs_int8.cells[65],
            bs_int8.cells[66],
            bs_int8.cells[67],
            bs_int8.cells[68],
            bs_int8.cells[69],
            bs_int8.cells[70],
            bs_int8.cells[71],
            bs_int8.cells[72],
            bs_int8.cells[73],
            bs_int8.cells[74],
            bs_int8.cells[75],
            bs_int8.cells[76],
            bs_int8.cells[77],
            bs_int8.cells[78],
            bs_int8.cells[79],
            bs_int8.cells[80]
        )
        
        let res = monte_carlo_tree_search(Int32(iterCount), bs_p)
        bs_p.deallocate()
        
        let x: Int = Int(res) % 9
        let y: Int = Int(res) / 9
        return (x, y)
    }
 

    
}
