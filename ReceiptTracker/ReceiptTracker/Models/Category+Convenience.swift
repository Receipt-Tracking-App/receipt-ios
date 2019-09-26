//
//  Category+Convenience.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/26/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import  CoreData

extension ReceiptCategory {
    convenience init(name: String, id: Int16, context: NSManagedObjectContext) {
        self.init(context: context)
        self.name = name
        self.id = id
    }
}

