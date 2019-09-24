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
    @discardableResult convenience init(identifier: Int64, firstName: String, lastName: String, username: String, email: String, password: String, createdAt: Date, updatedAt: Date, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        self.init(context: context)
        
        self.identifier = identifier
        self.firstName = firstName
        self.lastName = lastName
        self.username = username
        self.email = email
        self.password = password
        self.createdAt = createdAt
        self.updatedAt = updatedAt
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
