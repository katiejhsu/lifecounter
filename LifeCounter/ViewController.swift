//
//  ViewController.swift
//  LifeCounter
//
//  Created by Katie Hsu on 1/28/26.
//

import UIKit

class ViewController: UIViewController {
    
    // UI elements initialized in code to replace storyboard outlets
    let playerLost = UILabel()
    let History = UILabel()
    let mainStackView = UIStackView()
    
    let addPlayerButton = UIButton(type: .system)
    
    struct Player {
        var name: String
        var life: Int
    }

    // start w 4 players
    var players: [Player] = [
        Player(name: "Player 1", life: 20),
        Player(name: "Player 2", life: 20),
        Player(name: "Player 3", life: 20),
        Player(name: "Player 4", life: 20)
    ]
    
    // player labels arr for palyer buttons
    var playerLabels: [UILabel] = []
    
    // for history
    var gameHistory: [String] = []
    
    // create players dynamically
    // A list to keep track of the text fields so you can read their values
    var playerInputFields: [UITextField] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white // Set background color
        
        setupMainStack()
        
        // hide loss label
        playerLost.isHidden = true
        
        // setup the "Add Player" button
        addPlayerButton.setTitle("Add Player", for: .normal)
        addPlayerButton.addTarget(self, action: #selector(addNewPlayer), for: .touchUpInside)
        
        // setup "view history" button
        let historyButton = UIButton(type: .system)
        historyButton.setTitle("View History", for: .normal)
        historyButton.addTarget(self, action: #selector(showHistory), for: .touchUpInside)
        mainStackView.addArrangedSubview(historyButton)
            
        // add it to the top of your stack
        mainStackView.insertArrangedSubview(addPlayerButton, at: 0)
        
        // create starting 4 players
        for i in 0..<players.count {
            addPlayerToUI(playerIndex: i)
        }
    }
    

    func addPlayerToUI(playerIndex: Int) {
        let player = players[playerIndex]
        
        // label
        let nameLabel = UILabel()
        nameLabel.text = "\(player.name): \(player.life)"
        playerLabels.append(nameLabel)
        
        // numeric life increment
        let amountInput = UITextField()
        amountInput.placeholder = "1" // placeholder 1
        amountInput.keyboardType = .numberPad
        amountInput.borderStyle = .roundedRect
        playerInputFields.append(amountInput) // store it to read later
        
        // add and sub buttons on screen, create using code
        let plusButton = UIButton(type: .system)
        plusButton.setTitle("+", for: .normal)
        plusButton.tag = playerIndex // tag the button to the player
        plusButton.addTarget(self, action: #selector(scoreAdjusted), for: .touchUpInside)
        
        let minusButton = UIButton(type: .system)
        minusButton.setTitle("-", for: .normal)
        minusButton.tag = playerIndex
        minusButton.addTarget(self, action: #selector(scoreAdjusted), for: .touchUpInside)
        
        // create stack using code
        let rowStack = UIStackView(arrangedSubviews: [nameLabel, amountInput, minusButton, plusButton])
        rowStack.axis = .horizontal
        rowStack.distribution = .fillProportionally
        rowStack.spacing = 10
            
        mainStackView.addArrangedSubview(rowStack)
    }
    
    @objc func addNewPlayer() {
        if players.count < 8 {
            let newIndex = players.count
            let newPlayer = Player(name: "Player \(newIndex + 1)", life: 20)
            players.append(newPlayer)
            addPlayerToUI(playerIndex: newIndex)
        }
        
        // hide button if we hit the limit
        if players.count == 8 {
            addPlayerButton.setTitle("Add Player: Disabled", for: .normal)
            addPlayerButton.isEnabled = false
        }
    }

    // Helper to set up the programmatic constraints for your stack
    func setupMainStack() {
        mainStackView.axis = .vertical
        mainStackView.spacing = 20
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        // Constraints to keep the UI in the safe area (away from notch/bottom bar)
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Add the loss and history labels to the stack view
        playerLost.textAlignment = .center
        mainStackView.addArrangedSubview(playerLost)
        
        History.numberOfLines = 0
        History.text = "Game Log:"
        mainStackView.addArrangedSubview(History)
    }

    @objc func scoreAdjusted(_ sender: UIButton) {
        let playerIndex = sender.tag
        let textField = playerInputFields[playerIndex]
        
        // get life inc amt from field- default 1
        let amountString = textField.text ?? ""
        let amount = Int(amountString) ?? 1
        
        // determine + or -
        // also get the action for the history log
        var action = ""
        if sender.currentTitle == "+" {
            players[playerIndex].life += amount
            action = "gained" // Set action for history
        } else {
            players[playerIndex].life -= amount
            action = "lost" // Set action for history
        }
        
        // create the history string and add it to array
        let logEntry = "\(players[playerIndex].name) \(action) \(amount) life."
        gameHistory.append(logEntry)
        
        // update UI and check loss
        updateUI()
        checkLoss()
        
        // disable addPlayer once game started and write disabled next to it
        addPlayerButton.setTitle("Add Player: Disabled", for: .normal)
        addPlayerButton.isEnabled = false
        
        // close the keyboard after clicking
        // view.endEditing(true)
    }
    
    @objc func showHistory() {
        let historyVC = HistoryViewController()
        historyVC.historyData = gameHistory // Pass the data to the new screen
        navigationController?.pushViewController(historyVC, animated: true)
    }

    func updateUI() {
        for i in 0..<players.count {
            playerLabels[i].text = "\(players[i].name): \(players[i].life)"
        }
    }
    
    func checkLoss() {
        var loserNames: [String] = []
        
        for player in players {
            if player.life <= 0 {
                loserNames.append(player.name)
            }
        }

        if loserNames.count > 0 {
            playerLost.isHidden = false
            playerLost.text = "\(loserNames.joined(separator: ", ")) lost!" // join all the losers together
        } else {
            playerLost.isHidden = true
        }
    }
}

// History Screen
import UIKit

class HistoryViewController: UIViewController {
    var historyData: [String] = []
    let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "History"
        
        setupUI()
    }

    func setupUI() {
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add a scroll view in case the history is long
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        // constraints for the scroll view
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        // create a label for every item in history
        for entry in historyData {
            let label = UILabel()
            label.text = entry
            label.numberOfLines = 0
            stackView.addArrangedSubview(label)
        }
    }
}
