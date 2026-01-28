//
//  ViewController.swift
//  LifeCounter
//
//  Created by Katie Hsu on 1/28/26.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var playerOneLives: UILabel!
    @IBOutlet weak var playerTwoLives: UILabel!
    @IBOutlet var playerLost: UILabel!
    
    var playerOneScore = 20
    var playerTwoScore = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // hide loss label
        playerLost.isHidden = true
        
    }

    @IBAction func p1AddOne(_ sender: Any) {
        playerOneScore += 1
        playerOneLives.text = "Player 1 Life Counter: \(playerOneScore)"
        checkLoss()
    }
    
    @IBAction func p1AddFive(_ sender: Any) {
        playerOneScore += 5
        playerOneLives.text = "Player 1 Life Counter: \(playerOneScore)"
        checkLoss()
    }
    
    @IBAction func p1SubOne(_ sender: Any) {
        playerOneScore -= 1
        playerOneLives.text = "Player 1 Life Counter: \(playerOneScore)"
        checkLoss()
    }
    
    @IBAction func p1SubFive(_ sender: Any) {
        playerOneScore -= 5
        playerOneLives.text = "Player 1 Life Counter: \(playerOneScore)"
        checkLoss()
    }
    
    @IBAction func p2AddOne(_ sender: Any) {
        playerTwoScore += 1
        playerTwoLives.text = "Player 2 Life Counter: \(playerTwoScore)"
        checkLoss()
    }
    
    @IBAction func p2AddFive(_ sender: Any) {
        playerTwoScore += 5
        playerTwoLives.text = "Player 2 Life Counter: \(playerTwoScore)"
        checkLoss()
    }
    
    @IBAction func p2SubOne(_ sender: Any) {
        playerTwoScore -= 1
        playerTwoLives.text = "Player 2 Life Counter: \(playerTwoScore)"
        checkLoss()
    }
    
    @IBAction func p2SubFive(_ sender: Any) {
        playerTwoScore -= 5
        playerTwoLives.text = "Player 2 Life Counter: \(playerTwoScore)"
        checkLoss()
    }
    
    func checkLoss() {
        if playerOneScore <= 0 {
            playerLost.isHidden = false
            playerLost.text = "Player 1 LOSES!"
        } else if playerTwoScore <= 0 {
            playerLost.isHidden = false
            playerLost.text = "Player 2 LOSES!"
        } else {
            playerLost.isHidden = true
        }
    }
    
    
    
}

