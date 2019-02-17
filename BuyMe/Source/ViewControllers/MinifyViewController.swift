//
//  ViewController.swift
//  BuyMe
//
//  Created by Radislav Crechet on 8/2/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import UIKit

class MinifyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var realMoneyLabel: UILabel!
    @IBOutlet var bitcoinLabel: UILabel!
    @IBOutlet var ethereumLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var newsButton: UIButton!
    @IBOutlet var forecastButton: UIButton!
    
    private let cellIdentifier = "Cell"
    private let cards = CardService.cards
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureUserInterface()
    }
    
    // MARK: - Configuration
    
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func configureUserInterface() {
        realMoneyLabel.text = String(format: "%.1f", StatService.realMoney)
        bitcoinLabel.text = String(format: "%.5f", StatService.bitcoin)
        ethereumLabel.text = String(format: "%.5f", StatService.ethereum)
        newsButton.isEnabled = StoreManager.shared.isNewsEnabled
        forecastButton.isEnabled = StoreManager.shared.isForecastEnabled
    }
    
    // MARK: - Actions
    
    @IBAction func tapGestureRecognizerDidTouch(_ sender: UITapGestureRecognizer) {
        StatService.mine(withCards: cards)
        configureUserInterface()
    }

    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let card = cards[indexPath.row]
        let price = "Price: \(card.price)$"
        let profit = "Profit: " + String(format: "%.5f", card.profit) + "$"
        let count = "You have: \(StatService.numberOfCards(withId: card.id)) units"
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel?.text = card.name
        cell.detailTextLabel?.text = price + " | " + profit + " | " + count
        
        return cell
    }

    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let card = cards[indexPath.row]
        StatService.buyCard(card)
        
        configureUserInterface()
        
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
