//
//  BoardStateInt8.swift
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


func bool2Int8(_ b: Bool) -> Int8 {
    if b {
        return 1
    }
    return 0
}


final class BoardStateInt8 {
    var player: Int8
    var gameWon: Int8
    var allowedSegments: [Int8]
    var closedSegments: [Int8]
    var cells: [Int8]
    
    init(_ bs: BoardState) {
        gameWon = Int8(bs.gameWon)
        player = Int8(bs.player)
        
        cells = []
        allowedSegments = []
        closedSegments = []
        
        for i in 0..<9 {
            allowedSegments.append(bool2Int8(bs.allowedSegments[i]))
            closedSegments.append(Int8(bs.closedSegments[i]))
        }
        
        for i in 0..<81 {
            cells.append(Int8(bs.cells[i]))
        }
    }
}
