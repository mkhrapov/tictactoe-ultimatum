//
//  SettingsViewController.swift
//  TicTacToeUltimatum
//
//  Created by Maksim Khrapov on 5/16/19.
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
import UIKit

class SettingsViewController: UIViewController {
    
    let explText = [
        "Humans play both sides.",
        "AI plays Crosses.",
        "AI plays Noughts."
    ]
    
    let gameStyleKey = "gameStyleKey"
    let aiLevelKey = "aiLevelKey"
    
    
    @IBOutlet weak var gameStyleSegControl: UISegmentedControl!
    @IBOutlet weak var aiLevelSegControl: UISegmentedControl!
    @IBOutlet weak var explLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Settings"
        
        let gameStyle = UserDefaults.standard.integer(forKey: gameStyleKey)
        explLabel.text = explText[gameStyle]
        gameStyleSegControl.selectedSegmentIndex = gameStyle
        
        let aiLevel = UserDefaults.standard.integer(forKey: aiLevelKey)
        aiLevelSegControl.selectedSegmentIndex = aiLevel
        
    }
    
    
    
    @IBAction func gameStyleSegControlPressed(_ sender: Any) {
        let gameStyle = gameStyleSegControl.selectedSegmentIndex
        explLabel.text = explText[gameStyle]
        UserDefaults.standard.set(gameStyle, forKey: gameStyleKey)
    }
    
    
    @IBAction func aiLevelSegControlPressed(_ sender: Any) {
        let aiLevel = aiLevelSegControl.selectedSegmentIndex
        UserDefaults.standard.set(aiLevel, forKey: aiLevelKey)
    }
}
