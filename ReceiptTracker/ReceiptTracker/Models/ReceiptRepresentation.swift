//
//  ReceiptRepresentation.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation

struct ReceiptRepresentation: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case purchaseDate = "purchase_date"
        case merchant
        case amount
        case notes
        case tagName
        case tagDescription
        case categoryId
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    var identifier: Int32
    var purchaseDate: String
    var merchant: String
    var amount: Double
    var notes: String?
    var tagName: String?
    var tagDescription: String?
    var categoryId: Int16
    var createdAt: String
    var updatedAt: String
}

struct PostReceipt: Codable {
    var purchaseDate: String
    var merchant: String
    var amount: Double
    var notes: String?
    var tagName: String?
    var tagDescription: String?
    var categoryId: Int16
}

struct ReceiptInfo: Codable {
  //var error: Blah
    var receipts: ReceiptList
}

struct ReceiptList: Codable {
  //var id: Blah
    var receipts: [GetReceipt]
}

struct GetReceipt: Codable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case purchaseDate = "purchase_date"
        case merchant
        case amount
        case notes
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case categories
    }
    
    var identifier: Int32
    var purchaseDate: String
    var merchant: String
    var amount: String
    var notes: String?
    var createdAt: String
    var updatedAt: String
    var categories: [GetCategory]
}

struct GetCategory: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case mainCategoryId = "receipt_main_category_id"
    }
    
    var name: String
    var mainCategoryId: Int16
}
