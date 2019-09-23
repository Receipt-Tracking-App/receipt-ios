//
//  ReceiptRepresentation.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

enum CodingKeys: String, CodingKey {
    case id
    case purchaseDate = "purchase_date"
    case merchant
    case amount
    case notes
    case createdAt = "created_at"
    case updatedAt = "updated_at"
    case userID = "user_id"
}

struct ReceiptRepresentation: Codable, Equatable {
    var id: Int64
    var purchaseDate: Date
    var merchant: String
    var amount: Double
    var notes: String
    var createdAt: Date
    var updatedAt: Date
    var userID: Int64
}
