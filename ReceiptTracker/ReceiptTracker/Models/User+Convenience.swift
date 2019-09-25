//
//  User+Convenience.swift
//  ReceiptTracker
//
//  Created by Jordan Christensen on 9/24/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

extension User {
    @discardableResult convenience init(firstName: String, lastName: String, username: String, email: String, password: String, createdAt: Date, updatedAt: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        if let identifier = Int32("\(Int.random(in: 1...2_147))\(Int.random(in: 1...483_647)))") {
            self.identifier = identifier
        } else {
            self.identifier = Int32.random(in: 1...2_147_483_647)
        }
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.email = email
        self.password = password
        self.createdAt = dateFormatter.string(from: createdAt)
        self.updatedAt = dateFormatter.string(from: updatedAt)
    }
    
    var userRepresentation: UserRepresentation? {
        guard let firstName = firstName, let lastName = lastName,
            let username = username, let email = email,
            let password = password, let createdAt = createdAt,
            let updatedAt = updatedAt else { return nil }
        
        return UserRepresentation(identifier: identifier, firstName: firstName, lastName: lastName, username: username, email: email, password: password, createdAt: createdAt, updatedAt: updatedAt)
    }
    
    var userLogin: UserLogin? {
        guard let userId = username, let password = password else { return nil }
        
        return UserLogin(userId: userId, password: password)
    }
    
    var userSignup: UserSignup? {
        guard let firstName = firstName, let lastName = lastName,
            let email = email, let username = username,
            let password = password else { return nil }
        
        return UserSignup(firstName: firstName, lastName: lastName, email: email, username: username, password: password)
    }
}
