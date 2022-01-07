//
//  BoardView.swift
//  TicTacToeUltimatum
//
//  Created by Maksim Khrapov on 5/16/19.
//  Copyright © 2019 Maksim Khrapov. All rights reserved.
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
import UIKit

func makeColor(_ red: Int, _ green: Int, _ blue: Int) -> CGColor {
    let scale:CGFloat = 255.0
    
    return UIColor(
        red: CGFloat(red)/scale,
        green: CGFloat(green)/scale,
        blue: CGFloat(blue)/scale,
        alpha: 1.0
        ).cgColor
}


let xBgColor = makeColor(212, 229, 247) // lighter version of FG color
let xColor = makeColor(28, 134, 238) // dodgerblue2
let oColor = makeColor(255, 127, 0) // darkorange1
let oBgColor = makeColor(255, 217, 179) // lighter version of FG color
let finalStrikeColor = makeColor(255, 0, 0) // just make it red for now



class BoardView: UIView {
    var boardState: BoardState?
    var indicator: UIActivityIndicatorView?
    var shouldDisplayIndicator = false
    
    
    func setBoardState(_ bs: BoardState) {
        boardState = bs
        self.setNeedsDisplay()
    }
    
    
    func displayIndicator(_ b: Bool) {
        shouldDisplayIndicator = b
    }
    
    
    func activityIndicator() {
        if shouldDisplayIndicator {
            if indicator == nil {
                indicator = UIActivityIndicatorView(style: .whiteLarge)
                indicator!.color = UIColor.black
                indicator!.hidesWhenStopped = true
            }
            indicator!.center = CGPoint(x: bounds.midX, y: bounds.midY)
            self.addSubview(indicator!)
            indicator!.startAnimating()
        }
        else {
            if indicator != nil {
                indicator!.stopAnimating()
                indicator!.removeFromSuperview()
            }
        }
    }
    
    
    
    
    
    override func draw(_ rect: CGRect) {
        guard let boardState = boardState else {
            return
        }
        
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        let draw = Draw(context, bounds, boardState)
        draw.draw()
        activityIndicator()
    }
    
    
    class Draw {
        let context: CGContext
        let rect: CGRect
        let boardState: BoardState
        
        
        init(_ c: CGContext, _ r: CGRect, _ bs: BoardState) {
            context = c
            rect = r
            boardState = bs
        }
        
        
        func draw() {
            fillWhite()
            allowedSegments()
            mostRecentCell()
            positions()
            lightLines()
            winners()
            heavyLines()
            finalStrike()
        }
        
        
        func fillWhite() {
            context.setFillColor(UIColor.white.cgColor)
            context.fill(rect)
        }
        
        
        func mostRecentCell() {
            if boardState.mostRecent >= 0 && boardState.mostRecent <= 80 {
                if boardState.player == NOUG {
                    context.setFillColor(xBgColor)
                }
                else {
                    context.setFillColor(oBgColor)
                }
                
                let size = rect.height/9.0
                let x = boardState.mostRecent % 9
                let y = boardState.mostRecent / 9
                
                let x1 = rect.minX + CGFloat(x)*size
                let y1 = rect.minY + CGFloat(y)*size
                
                let rect1 = CGRect(x: x1, y: y1, width: size, height: size)
                context.fill(rect1)
            }
        }
        
        
        func allowedSegments() {
            if boardState.player == CROS {
                context.setFillColor(xBgColor)
            }
            else {
                context.setFillColor(oBgColor)
            }
            
            for y in 0..<3 {
                for x in 0..<3 {
                    if boardState.allowedSegments[y*3 + x] {
                        fillSegment(x, y)
                    }
                }
            }
        }
        
        
        func fillSegment(_ x: Int, _ y: Int) {
            let size = rect.height/3.0
            
            let x1 = rect.minX + CGFloat(x)*size
            let y1 = rect.minY + CGFloat(y)*size
            
            let rect1 = CGRect(x: x1, y: y1, width: size, height: size)
            context.fill(rect1)
        }
        
        
        func winners() {
            for y in 0..<3 {
                for x in 0..<3 {
                    let i = y*3 + x
                    if boardState.closedSegments[i] == 1 {
                        context.setFillColor(UIColor.white.cgColor)
                        fillSegment(x, y)
                        bigX(x, y)
                    }
                    else if boardState.closedSegments[i] == 2 {
                        context.setFillColor(UIColor.white.cgColor)
                        fillSegment(x, y)
                        bigO(x, y)
                    }
                }
            }
        }
        
        
        func positions() {
            for y in 0..<9 {
                for x in 0..<9 {
                    let i = y*9 + x
                    if boardState.cells[i] == 1 {
                        cross(x, y)
                    }
                    else if boardState.cells[i] == 2 {
                        nought(x, y)
                    }
                }
            }
        }
        
        
        func cross(_ x: Int, _ y: Int) {
            let cellSize = rect.width / 9.0
            let dx = cellSize / 5.0
            let x1 = rect.minX + CGFloat(x)*cellSize + dx
            let x2 = rect.minX + CGFloat(x)*cellSize + cellSize - dx
            let y1 = rect.minY + CGFloat(y)*cellSize + dx
            let y2 = rect.minY + CGFloat(y)*cellSize + cellSize - dx
            
            context.setStrokeColor(xColor)
            context.setLineWidth(6)
            context.beginPath()
            context.move(to: CGPoint(x: x1, y: y1))
            context.addLine(to: CGPoint(x: x2, y: y2))
            context.move(to: CGPoint(x: x2, y: y1))
            context.addLine(to: CGPoint(x: x1, y: y2))
            context.strokePath()
        }
        
        
        func bigX(_ x: Int, _ y: Int) {
            let cellSize = rect.width / 3.0
            let dx = cellSize / 5.0
            let x1 = rect.minX + CGFloat(x)*cellSize + dx
            let x2 = rect.minX + CGFloat(x)*cellSize + cellSize - dx
            let y1 = rect.minY + CGFloat(y)*cellSize + dx
            let y2 = rect.minY + CGFloat(y)*cellSize + cellSize - dx
            
            context.setStrokeColor(xColor)
            context.setLineWidth(12)
            context.beginPath()
            context.move(to: CGPoint(x: x1, y: y1))
            context.addLine(to: CGPoint(x: x2, y: y2))
            context.move(to: CGPoint(x: x2, y: y1))
            context.addLine(to: CGPoint(x: x1, y: y2))
            context.strokePath()
        }
        
        
        func nought(_ x: Int, _ y: Int) {
            let cellSize = rect.width / 9.0
            let x1 = rect.minX + CGFloat(x)*cellSize + cellSize/2
            let y1 = rect.minY + CGFloat(y)*cellSize + cellSize/2
            context.setStrokeColor(oColor)
            context.setLineWidth(6)
            context.beginPath()
            context.addArc(center: CGPoint(x: x1, y: y1), radius: cellSize/2 - 8.0, startAngle: 0.0, endAngle: CGFloat(2*Double.pi), clockwise: false)
            context.strokePath()
        }
        
        
        func bigO(_ x: Int, _ y: Int) {
            let cellSize = rect.width / 3.0
            let x1 = rect.minX + CGFloat(x)*cellSize + cellSize/2
            let y1 = rect.minY + CGFloat(y)*cellSize + cellSize/2
            context.setStrokeColor(oColor)
            context.setLineWidth(12)
            context.beginPath()
            context.addArc(center: CGPoint(x: x1, y: y1), radius: cellSize/2 - 16.0, startAngle: 0.0, endAngle: CGFloat(2*Double.pi), clockwise: false)
            context.strokePath()
        }
        
        
        func heavyLines() {
            context.setStrokeColor(UIColor.black.cgColor)
            context.setLineWidth(4)
            
            context.beginPath()
            
            // horizontal lines
            context.move(to: CGPoint(x: rect.minX, y: rect.minY + 2))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 2))
            
            context.move(to: CGPoint(x: rect.minX, y: rect.minY + rect.height/3.0))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + rect.height/3.0))
            
            context.move(to: CGPoint(x: rect.minX, y: rect.minY + 2.0*rect.height/3.0))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + 2.0*rect.height/3.0))
            
            context.move(to: CGPoint(x: rect.minX, y: rect.maxY - 2))
            context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 2))
            
            // vertical lines
            context.move(to: CGPoint(x: rect.minX + 2, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX + 2, y: rect.maxY))
            
            context.move(to: CGPoint(x: rect.minX + rect.width/3.0, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX + rect.width/3.0, y: rect.maxY))
            
            context.move(to: CGPoint(x: rect.minX + 2.0*rect.width/3.0, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.minX + 2.0*rect.width/3.0, y: rect.maxY))
            
            context.move(to: CGPoint(x: rect.maxX - 2, y: rect.minY))
            context.addLine(to: CGPoint(x: rect.maxX - 2, y: rect.maxY))
            
            context.strokePath()
        }
        
        
        func lightLines() {
            context.setStrokeColor(UIColor.gray.cgColor)
            context.setLineWidth(1)
            
            context.beginPath()
            
            // horizontal lines
            for i in [1, 2, 4, 5, 7, 8] {
                let i = CGFloat(i)
                context.move(to: CGPoint(x: rect.minX, y: rect.minY + i*rect.height/9.0))
                context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + i*rect.height/9.0))
            }
            
            // vertical lines
            for i in [1, 2, 4, 5, 7, 8] {
                let i = CGFloat(i)
                context.move(to: CGPoint(x: rect.minX + i*rect.width/9.0, y: rect.minY))
                context.addLine(to: CGPoint(x: rect.minX + i*rect.width/9.0, y: rect.maxY))
            }
            
            context.strokePath()
        }
        
        
        func finalStrike() {
            if boardState.gameWon == 0 || boardState.gameWon == 3 {
                return
            }
            
            let segmentSize = rect.width / 3.0
            
            var x1 = rect.minX
            var x2 = rect.minX
            var y1 = rect.minY
            var y2 = rect.minY
            
            var dy = CGFloat(boardState.finalStrikeStart / 3) + 0.5
            var dx = CGFloat(boardState.finalStrikeStart % 3) + 0.5
            
            x1 += segmentSize*dx
            y1 += segmentSize*dy
            
            dy = CGFloat(boardState.finalStrikeEnd / 3) + 0.5
            dx = CGFloat(boardState.finalStrikeEnd % 3) + 0.5
            
            x2 += segmentSize*dx
            y2 += segmentSize*dy
            
            context.setStrokeColor(finalStrikeColor)
            context.setLineWidth(24)
            context.beginPath()
            context.move(to: CGPoint(x: x1, y: y1))
            context.addLine(to: CGPoint(x: x2, y: y2))
            context.strokePath()
        }
    }
}

