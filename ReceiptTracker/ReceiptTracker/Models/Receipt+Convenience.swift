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
    convenience init(purchaseDate: Date, merchant: String, amount: Double, notes: String?, tagName: String?, tagDescription: String?, category: ReceiptCategory, createdAt: Date, updatedAt: Date, image: Data? = nil, context: NSManagedObjectContext) {
        self.init(context: context)
        
      
        
        self.identifier = identifier
        self.purchaseDate = dateFormatter.string(from: purchaseDate)
        self.merchant = merchant
        self.amount = amount
        self.notes = notes
        self.tagName = tagName
        self.tagDescription = tagDescription
        self.category = NSOrderedSet(array: [category])
        self.createdAt = dateFormatter.string(from: createdAt)
        self.updatedAt = dateFormatter.string(from: updatedAt)
        self.image = image
    }
    
    @discardableResult convenience init?(receiptRepresentation: GetReceipt, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        guard let amount = Double(receiptRepresentation.amount) else { return }
        
        self.identifier = Int32(receiptRepresentation.identifier)
        self.purchaseDate = receiptRepresentation.purchaseDate
        self.merchant = receiptRepresentation.merchant
        self.amount = amount
        self.notes = receiptRepresentation.notes
        self.categoryId = Int16(receiptRepresentation.categories[0].mainCategoryId)
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
