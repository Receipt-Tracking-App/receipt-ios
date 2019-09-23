//
//  UserRepresentation.swift
//  ReceiptTracker
//
//  Created by Jordan Christensen on 9/24/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable, Equatable {
    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case username
        case email
        case password
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    var identifier: Int64
    var firstName: String
    var lastName: String
    var username: String
    var email: String
    var password: String
    var createdAt: Date
    var updatedAt: Date
}

struct UserLogin: Codable {
    var username: String
    var password: String
}

struct UserSignup: Codable {
    var firstName: String
    var lastName: String
    var email: String
    var username: String
    var password: String
}
