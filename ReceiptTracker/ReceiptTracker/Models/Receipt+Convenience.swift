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
    convenience init(identifier: Int64, purchaseDate: Date, merchant: String, amount: Double, notes: String, createdAt: Date, updatedAt: Date, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.identifier = identifier
        self.purchaseDate = purchaseDate
        self.merchant = merchant
        self.amount = amount
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    @discardableResult convenience init?(receiptRepresentation: ReceiptRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.identifier = receiptRepresentation.identifier
        self.purchaseDate = receiptRepresentation.purchaseDate
        self.merchant = receiptRepresentation.merchant
        self.amount = receiptRepresentation.amount
        self.notes = receiptRepresentation.notes
        self.createdAt = receiptRepresentation.createdAt
        self.updatedAt = receiptRepresentation.updatedAt
    }
}
