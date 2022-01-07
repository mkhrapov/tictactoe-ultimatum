//
//  BoardState.swift
//  TicTacToeUltimatum
//
//  Created by Maksim Khrapov on 5/16/19.
//  Copyright © 2019 Maksim Khrapov.
//
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

let OPEN = 0
let CROS = 1
let NOUG = 2
let DONE = 3


final class BoardState {
    
    
    var cells: [Int] // OPEN, CROS, NOUG
    var allowedSegments: [Bool] // which segments the next move is allowed in
    var closedSegments: [Int] // OPEN if segment can still be played in, CROS or NOUG if CROS or NOUG already won there
    // DONE if the segment is full but not won by anyone
    var gameWon: Int // OPEN if not won, CROS or NOUG if won, DONE if a draw
    var finalStrikeStart = -1
    var finalStrikeEnd = -1
    var player: Int
    var mostRecent: Int = 100
    
    
    
    
    init() {
        cells = Array(repeating: OPEN, count: 81)
        allowedSegments = Array(repeating: true, count: 9)
        closedSegments = Array(repeating: OPEN, count: 9)
        gameWon = OPEN
        player = CROS
    }
    
    
    func isTerminal() -> Bool {
        return gameWon != OPEN
    }
    
    
    func legalPlay(_ x: Int, _ y: Int) -> Bool {
        if gameWon != OPEN {
            return false
        }
        
        if x < 0 || x > 8 || y < 0 || y > 8 {
            return false
        }
        
        let i = y*9 + x
        
        // check if click was in allowed segment
        let clickSegment = ownSection(x, y)
        if !allowedSegments[clickSegment] {
            // segment not allowed
            return false
        }
        
        // check to see if the cell itself is not already occupied
        if cells[i] != 0 {
            return false
        }
        
        return true
    }
    
    
    func allLegalMoves() -> [(Int, Int)] {
        var res: [(Int, Int)] = []
        
        for x in 0..<9 {
            for y in 0..<9 {
                if legalPlay(x, y) {
                    res.append((x, y))
                }
            }
        }
        
        return res
    }
    
    
    func clone() -> BoardState {
        let child = BoardState()
        
        child.cells = self.cells
        child.allowedSegments = self.allowedSegments
        child.closedSegments = self.closedSegments
        child.gameWon = self.gameWon
        child.player = self.player
        
        return child
    }
    
    
    func set(_ x: Int, _ y: Int) -> Bool {
        if !legalPlay(x, y) {
            return false
        }
        
        let cell = y*9 + x
        let section = ownSection(x, y)
        mostRecent = cell
        
        // set position
        cells[cell] = player
        if won(player, section) {
            closedSegments[section] = player
            if entireGameWonBy(player) {
                gameWon = player
            }
            else if entireBoardIsFull() {
                gameWon = DONE
            }
        }
        else if full(section) {
            closedSegments[section] = DONE
            if entireBoardIsFull() {
                gameWon = DONE
            }
        }
        
        
        // figure out next set of allowed positions
        for i in 0..<9 {
            allowedSegments[i] = false
        }
        
        if gameWon == OPEN {
            let nextSection = targetSection(x, y)
            if segmentClosed(nextSection) {
                for i in 0..<9 {
                    if !segmentClosed(i) {
                        allowedSegments[i] = true
                    }
                }
            }
            else {
                allowedSegments[nextSection] = true
            }
        }
        
        if player == CROS {
            player = NOUG
        }
        else {
            player = CROS
        }
        
        return true
    }
    
    
    func segmentClosed(_ i: Int) -> Bool {
        if closedSegments[i] == 0 {
            return false
        }
        else {
            return true
        }
    }
    
    
    func won(_ who: Int, _ segment: Int) -> Bool {
        let locations = sectionLocations(segment)
        
        let listOfIndexes = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ]
        
        for indexes in listOfIndexes {
            if  cells[locations[indexes[0]]] == who &&
                cells[locations[indexes[1]]] == who &&
                cells[locations[indexes[2]]] == who     {
                return true
            }
        }
        
        return false
    }
    
    
    func full(_ segment: Int) -> Bool {
        let locations = sectionLocations(segment)
        
        for i in locations {
            if cells[i] == OPEN {
                return false
            }
        }
        
        return true
    }
    
    
    func entireGameWonBy(_ who: Int) -> Bool {
        let listOfIndexes = [
            [0, 1, 2],
            [3, 4, 5],
            [6, 7, 8],
            [0, 3, 6],
            [1, 4, 7],
            [2, 5, 8],
            [0, 4, 8],
            [2, 4, 6]
        ]
        
        for indexes in listOfIndexes {
            if  closedSegments[indexes[0]] == who &&
                closedSegments[indexes[1]] == who &&
                closedSegments[indexes[2]] == who     {
                finalStrikeStart = indexes[0]
                finalStrikeEnd = indexes[2]
                return true
            }
        }
        return false
    }
    
    
    func entireBoardIsFull() -> Bool {
        for i in closedSegments {
            if i == OPEN {
                return false
            }
        }
        return true
    }
    
    
    func ownSection(_ x: Int, _ y: Int) -> Int {
        return 3*(y/3) + (x/3)
    }
    
    
    func targetSection(_ x: Int, _ y: Int) -> Int {
        return 3*(y%3) + (x%3)
    }
    
    
    func sectionLocations(_ section: Int) -> [Int] {
        var locations = [0, 1, 2, 9, 10, 11, 18, 19, 20]
        
        if section < 3 {
            for i in 0..<9 {
                locations[i] += section*3
            }
        }
        else if section < 6 {
            for i in 0..<9 {
                locations[i] += 27 + (section - 3)*3
            }
        }
        else {
            for i in 0..<9 {
                locations[i] += 54 + (section - 6)*3
            }
        }
        
        return locations
    }
}

