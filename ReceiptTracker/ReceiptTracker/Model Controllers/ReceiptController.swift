//
//  ReceiptController.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

enum HTTPMethod: String {
    case get = "GET"
    case put = "PUT"
    case post = "POST"
    case delete = "DELETE"
}

class ReceiptController {
    let baseURL = URL(string: "https://lambda-receipt-tracker.herokuapp.com/api")!

    init() {
        fetchReceiptsFromServer()
    }

    func createReceipt(purchaseDate: Date, merchant: String, amount: Double, notes: String?, tagName: String?, tagDescription: String?, categoryId: Int16, createdAt: Date, updatedAt: Date, context: NSManagedObjectContext) {
        let receipt = Receipt(purchaseDate: purchaseDate, merchant: merchant, amount: amount, notes: notes, tagName: tagName, tagDescription: tagDescription, categoryId: categoryId, createdAt: createdAt, updatedAt: updatedAt, context: context)

        put(receipt: receipt)
        CoreDataStack.shared.save()
    }

    func update(receipt: Receipt, purchaseDate: Date, merchant: String, amount: Double, notes: String?, tagName: String?, tagDescription: String?, categoryId: Int16) {
        receipt.purchaseDate = purchaseDate
        receipt.merchant = merchant
        receipt.amount = amount
        receipt.notes = notes
        receipt.tagName = tagName
        receipt.tagDescription = tagDescription
        receipt.categoryId = categoryId
        receipt.updatedAt = Date()

        put(receipt: receipt)
        CoreDataStack.shared.save()
    }

    func delete(receipt: Receipt) {

        CoreDataStack.shared.mainContext.delete(receipt)
        deleteEntryFromServer(receipt: receipt)
        CoreDataStack.shared.save()
    }

    private func put(receipt: Receipt, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL // .appendingPathComponent(identifier) TODO: Append userID and receiptID
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue

        do {
            request.httpBody = try JSONEncoder().encode(receipt.postReceipt)
        } catch {
            NSLog("Error encoding Receipt: \(error)")
            completion(error)
            return
        }

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error PUTting receipt to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    func deleteEntryFromServer(receipt: Receipt, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL // .appendingPathComponent(identifier) TODO: Append receiptID
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting receipt from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    func fetchReceiptsFromServer(completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL // .appendingPathComponent(identifier) TODO: Append userID

        URLSession.shared.dataTask(with: requestURL) { (data, _, error) in

            if let error = error {
                NSLog("Error fetching receipts from server: \(error)")
                completion(error)
                return
            }

            guard let data = data else {
                NSLog("No data returned from data task")
                completion(NSError())
                return
            }

            var receiptReps: [ReceiptRepresentation] = []

            do {
                receiptReps = try JSONDecoder().decode([String: ReceiptRepresentation].self, from: data).map({$0.value})
                self.updateReceipts(with: receiptReps)
            } catch {
                NSLog("Error decoding JSON data: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    private func updateReceipts(with representations: [ReceiptRepresentation]) {
        //TODO: Remake updateReceipts function
    }

    private func update(receipt: Receipt, with receiptRepresentation: ReceiptRepresentation) {
        receipt.identifier = receiptRepresentation.identifier
        receipt.purchaseDate = receiptRepresentation.purchaseDate
        receipt.merchant = receiptRepresentation.merchant
        receipt.amount = receiptRepresentation.amount
        receipt.notes = receiptRepresentation.notes
        receipt.createdAt = receiptRepresentation.createdAt
        receipt.updatedAt = receiptRepresentation.updatedAt
    }
}
