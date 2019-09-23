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
    @discardableResult convenience init(name: String, username: String, password: String, identifier: Int64, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        //        self.name = name
        self.username = username
        self.password = password
        self.userid = identifier
    }
    
    @discardableResult convenience init?(userRepresentation: UserRepresentation, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        
        guard let id = userRepresentation.identifier else { return nil }
        
        //        self.name = name
        self.username = username
        self.password = password
        self.userid = Int64(id)
    }
    
    var userRepresentation: UserRepresentation {
        return UserRepresentation(username: username, password: password, identifier: Int(userid))
    }
}
