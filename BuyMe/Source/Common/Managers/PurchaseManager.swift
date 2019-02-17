//
//  PurchaseManager.swift
//  BuyMe
//
//  Created by Radislav Crechet on 8/4/17.
//  Copyright © 2017 RubyGarage. All rights reserved.
//

import StoreKit

typealias ProductsRequestCompletion = (_ products: [SKProduct]?, _ error: Error?) -> Void
typealias TransactionCompletion = (_ error: Error?) -> Void
typealias RestoreCompletion = (_ isRestored: Bool, _ error: Error?) -> Void

class PurchaseManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    static let shared = PurchaseManager()
    
    var productIdentifiers = Set<String>()
    
    private var productsRequest: SKProductsRequest?
    private var productsRequestCompletion: ProductsRequestCompletion?
    private var transactionCompletion: TransactionCompletion?
    private var restoreCompletion: RestoreCompletion?
    
    // MARK: - Lifecycle
    
    private override init() {
        super.init()
        
        SKPaymentQueue.default().add(self)
    }
    
    // MARK: - Work With Data
    
    func requestProducts(completion: @escaping ProductsRequestCompletion) {
        productsRequest?.cancel()
        productsRequestCompletion = completion
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productsRequest!.delegate = self
        productsRequest!.start()
    }
    
    func buy(product: SKProduct, completion: @escaping TransactionCompletion) {
        transactionCompletion = completion
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restore(completion: @escaping RestoreCompletion) {
        restoreCompletion = completion
        
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    // MARK: - SKProductsRequestDelegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        productsRequestCompletion?(products, nil)
        resetRequestAndCompletion()
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        productsRequestCompletion?(nil, error)
        resetRequestAndCompletion()
    }
    
    // MARK: - SKProductsRequestDelegate Helpers
    
    private func resetRequestAndCompletion() {
        productsRequest = nil
        productsRequestCompletion = nil
    }

    // MARK: - SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased, .restored:
                pass(transaction: transaction)
            case .failed:
                fail(transaction: transaction)
            default:
                break;
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        self.restoreCompletion?(false, nil)
        self.resetCompletions()
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, restoreCompletedTransactionsFailedWithError error: Error) {
        self.restoreCompletion?(false, error)
        self.resetCompletions()
    }
    
    // MARK: - SKPaymentTransactionObserver Helpers
    
    private func pass(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        
        self.transactionCompletion?(nil)
        self.restoreCompletion?(true, nil)
        self.resetCompletions()
    }
    
    private func fail(transaction: SKPaymentTransaction) {
        SKPaymentQueue.default().finishTransaction(transaction)
        
        self.transactionCompletion?(transaction.error)
        self.restoreCompletion?(false, transaction.error)
        self.resetCompletions()
    }
    
    private func resetCompletions() {
        transactionCompletion = nil
        restoreCompletion = nil
    }
}
