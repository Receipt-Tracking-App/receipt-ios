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

    func createReceipt(purchaseDate: Date, merchant: String, amount: Double, notes: String?, tagName: String?, tagDescription: String?, category: ReceiptCategory, image: Data? = nil, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        let receipt = Receipt(purchaseDate: purchaseDate, merchant: merchant, amount: amount, notes: notes, tagName: tagName, tagDescription: tagDescription, category: category, createdAt: Date(), updatedAt: Date(), image: image, context: context)

        post(receipt: receipt)
        CoreDataStack.shared.save()
    }

    func update(receipt: Receipt, purchaseDate: Date, merchant: String, amount: Double, notes: String?, tagName: String?, tagDescription: String?, categoryId: Int16, image: Data? = nil) {
        receipt.purchaseDate = dateFormatter.string(from: purchaseDate)
        receipt.merchant = merchant
        receipt.amount = amount
        receipt.notes = notes
        receipt.tagName = tagName
        receipt.tagDescription = tagDescription
        receipt.categoryId = categoryId
        receipt.image = image
        receipt.updatedAt = dateFormatter.string(from: Date())

        post(receipt: receipt)
        CoreDataStack.shared.save()
    }

    func delete(receipt: Receipt) {
        CoreDataStack.shared.mainContext.delete(receipt)
        deleteReceiptFromServer(receipt: receipt)
        CoreDataStack.shared.save()
    }

    
    // Not working
    private func post(receipt: Receipt, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("receipts")
                                .appendingPathComponent("\(receipt.identifier)")
        
        guard let bearer = UserController.shared.bearer else {
            NSLog("Unable to derive token from bearer. Is user logged in?")
            completion(NetworkError.noAuth)
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONEncoder().encode(receipt.postReceipt)
        } catch {
            NSLog("Error encoding Receipt: \(error)")
            completion(error)
            return
        }

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error POSTing receipt to server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    func deleteReceiptFromServer(receipt: Receipt, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("receipts")
                                .appendingPathComponent("\(receipt.identifier)")
        
        guard let bearer = UserController.shared.bearer else {
            NSLog("Unable to derive token from bearer. Is user logged in?")
            completion(NetworkError.noAuth)
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.delete.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting receipt from server: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    // Not working
    func fetchReceiptsFromServer(completion: @escaping ((Error?) -> Void) = { _ in }) {
        guard let bearer = UserController.shared.bearer else {
            NSLog("Unable to derive token from bearer. Is user logged in?")
            completion(NetworkError.noAuth)
            return
        }
        
        let requestURL = baseURL.appendingPathComponent("receipts")
            .appendingPathComponent("users")
            .appendingPathComponent("\(bearer.userId)")
        
        
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.get.rawValue
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        

        URLSession.shared.dataTask(with: request) { (data, _, error) in
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

            var receipts: ReceiptInfo
            
            do {
//                print(String(data: data, encoding: .utf8))
                receipts = try JSONDecoder().decode(ReceiptInfo.self, from: data)
                self.updateReceipts(with: receipts.receipts.receipts)
            } catch {
                NSLog("Error decoding JSON data on line \(#line): \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }

    private func updateReceipts(with representations: [GetReceipt]) {
        let identifiersToFetch = representations.compactMap({ $0.identifier })
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var receiptsToCreate = representationsByID
        
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier IN %@", identifiersToFetch)
        
        let context = CoreDataStack.shared.container.newBackgroundContext()
        
        context.performAndWait {
            do {
                let existingReceipts = try context.fetch(fetchRequest)
                
                for receipt in existingReceipts {
                    guard let representation = representationsByID[receipt.identifier] else { continue }
                    self.update(receipt: receipt, with: representation)
                    receiptsToCreate.removeValue(forKey: receipt.identifier)
                }
                for representation in receiptsToCreate.values {
                    Receipt(receiptRepresentation: representation, context: context)
                }
                
            } catch {
                NSLog("Error fetching tasks for UUIDs: \(error)")
            }
            CoreDataStack.shared.save(context: context)
        }
    }

    private func update(receipt: Receipt, with receiptRepresentation: GetReceipt) {
        guard let amount = Double(receiptRepresentation.amount) else { return }
        receipt.identifier = receiptRepresentation.identifier
        receipt.purchaseDate = receiptRepresentation.purchaseDate
        receipt.merchant = receiptRepresentation.merchant
        receipt.amount = amount
        receipt.notes = receiptRepresentation.notes
        receipt.createdAt = receiptRepresentation.createdAt
        receipt.updatedAt = receiptRepresentation.updatedAt
        receipt.categoryId = receiptRepresentation.categories[0].mainCategoryId
    }
}
