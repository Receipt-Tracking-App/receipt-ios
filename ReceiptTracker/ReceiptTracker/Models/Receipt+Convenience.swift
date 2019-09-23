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
    convenience init(id: Int64, purchaseDate: Date, merchant: String, amount: Double, notes: String, createdAt: Date, updatedAt: Date, userID: Int64, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.id = id
        self.purchaseDate = purchaseDate
        self.merchant = merchant
        self.amount = amount
        self.notes = notes
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.userID = userID
    }
}
