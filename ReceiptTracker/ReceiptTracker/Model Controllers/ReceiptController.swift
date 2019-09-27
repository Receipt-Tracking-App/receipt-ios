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
        receipt.categoryId = category.id

        post(receipt: receipt)
        CoreDataStack.shared.save()
    }

    func update(receipt: Receipt, purchaseDate: Date, merchant: String, amount: Double, notes: String?, tagName: String?, tagDescription: String?, category: ReceiptCategory, image: Data? = nil) {
        receipt.purchaseDate = dateFormatter.string(from: purchaseDate)
        receipt.merchant = merchant
        receipt.amount = amount
        receipt.notes = notes
        receipt.tagName = tagName
        receipt.tagDescription = tagDescription
        receipt.category = NSOrderedSet(array: [category])
        receipt.image = image
        receipt.updatedAt = dateFormatter.string(from: Date())

        putUpdate(receipt: receipt)
        CoreDataStack.shared.save()
    }

    func delete(receipt: Receipt) {
        CoreDataStack.shared.mainContext.delete(receipt)
        deleteReceiptFromServer(receipt: receipt)
        CoreDataStack.shared.save()
    }

    private func post(receipt: Receipt, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("receipts")
        
        guard let bearer = UserController.shared.bearer else {
            NSLog("Unable to derive token from bearer. Is user logged in?")
            completion(NetworkError.noAuth)
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")

        do {
            request.httpBody = try JSONEncoder().encode(receipt.postReceipt)
        } catch {
            NSLog("Error encoding Receipt: \(error)")
            completion(error)
            return
        }

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Status code from post \(response.statusCode)")
                completion(nil)
                return
            }
            
            if let error = error {
                NSLog("Error POSTing receipt to server: \(error)")
                completion(error)
                return
            }
            
            guard let data = data else {
                NSLog("No data returned on line: \(#line)")
                completion(nil)
                return
            }
            
            do {
                let id = try JSONDecoder().decode(ReceiptResponceRep.self, from: data)
                receipt.identifier = id.receiptId
            } catch {
                NSLog("Unable to decode from JSON on line \(#line) with error: \(error)")
            }
            completion(nil)
        }.resume()
    }
    
    private func putUpdate(receipt: Receipt, completion: @escaping ((Error?) -> Void) = { _ in }) {
        let requestURL = baseURL.appendingPathComponent("receipts")
                                .appendingPathComponent("\(receipt.identifier)")
        
        guard let bearer = UserController.shared.bearer else {
            NSLog("Unable to derive token from bearer. Is user logged in?")
            completion(NetworkError.noAuth)
            return
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = HTTPMethod.put.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")
        
        do {
            request.httpBody = try JSONEncoder().encode(receipt.postReceipt)
        } catch {
            NSLog("Error encoding Receipt: \(error)")
            completion(error)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Status code from putUpdate \(response.statusCode)")
                completion(nil)
                return
            }
            
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
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(bearer.token)", forHTTPHeaderField: "Authorization")

        URLSession.shared.dataTask(with: request) { (_, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Status code from deleteReceiptFromServer \(response.statusCode)")
                completion(nil)
                return
            }
            
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
        

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse,
                response.statusCode != 200 {
                print("Status code \(response.statusCode)")
                completion(nil)
                return
            }
            
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

    private func updateReceipts(with representations: [GetReceipt], context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        context.performAndWait {
            for receiptRep in representations {
                let receipt = fetchSingleReceiptFromPersistentStore(receiptID: receiptRep.identifier)
                
                if let receipt = receipt {
                    if receipt.purchaseDate != receiptRep.purchaseDate ||
                        receipt.merchant != receiptRep.merchant ||
                        receipt.amount != Double(receiptRep.amount) ||
                        receipt.notes != receiptRep.notes ||
                        receipt.createdAt != receiptRep.createdAt ||
                        receipt.updatedAt != receiptRep.updatedAt {
                        self.update(receipt: receipt, with: receiptRep)
                    }
                } else {
                    Receipt(receiptRepresentation: receiptRep)
                }
            }
        }
    }
    
    private func fetchSingleReceiptFromPersistentStore(receiptID: Int32, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) -> Receipt? {
        let fetchRequest: NSFetchRequest<Receipt> = Receipt.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %ld", receiptID)
        
        var receipt: Receipt?
        
        context.performAndWait {
            do {
                receipt = try context.fetch(fetchRequest).first
            } catch {
                NSLog("Error fetching item with identifier: \(receiptID). Error: \(error)")
            }
        }
        return receipt
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
