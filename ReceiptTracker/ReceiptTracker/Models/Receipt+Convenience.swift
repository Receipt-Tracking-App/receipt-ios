//
//  Receipt+Convenience.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

extension Receipt {
    convenience init(purchaseDate: Date, merchant: String, amount: Double, notes: String?, tagName: String?, tagDescription: String?, categoryId: Int16, createdAt: Date, updatedAt: Date, context: NSManagedObjectContext) {
        self.init(context: context)
        
        if let identifier = Int32("\(Int.random(in: 1...2_147))\(Int.random(in: 1...483_647)))") {
            self.identifier = identifier
        } else {
            self.identifier = Int32.random(in: 1...2_147_483_647)
        }
        self.purchaseDate = dateFormatter.string(from: purchaseDate)
        self.merchant = merchant
        self.amount = amount
        self.notes = notes
        self.tagName = tagName
        self.tagDescription = tagDescription
        self.categoryId = categoryId
        self.createdAt = dateFormatter.string(from: createdAt)
        self.updatedAt = dateFormatter.string(from: updatedAt)
    }
    
    @discardableResult convenience init?(receiptRepresentation: ReceiptRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.identifier = receiptRepresentation.identifier
        self.purchaseDate = receiptRepresentation.purchaseDate
        self.merchant = receiptRepresentation.merchant
        self.amount = receiptRepresentation.amount
        self.notes = receiptRepresentation.notes
        self.tagName = receiptRepresentation.tagName
        self.tagDescription = receiptRepresentation.tagDescription
        self.categoryId = receiptRepresentation.categoryId
        self.createdAt = receiptRepresentation.createdAt
        self.updatedAt = receiptRepresentation.updatedAt
    }
    
    var receiptRepresentation: ReceiptRepresentation? {
        guard let purchaseDate = purchaseDate, let merchant = merchant,
            let createdAt = createdAt, let updatedAt = updatedAt else { return nil }
        
        return ReceiptRepresentation(identifier: identifier, purchaseDate: purchaseDate, merchant: merchant, amount: amount, notes: notes, tagName: tagName, tagDescription: tagDescription, categoryId: categoryId, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    var postReceipt: PostReceipt? {
        guard let purchaseDate = purchaseDate, let merchant = merchant else { return nil }
        return PostReceipt(purchaseDate: purchaseDate, merchant: merchant, amount: amount, notes: notes, tagName: tagName, tagDescription: tagDescription, categoryId: categoryId)
    }
}
