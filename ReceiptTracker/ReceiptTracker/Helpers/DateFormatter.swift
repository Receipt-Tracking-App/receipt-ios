//
//  DateFormatter.swift
//  ReceiptTracker
//
//  Created by Jordan Christensen on 9/26/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation

var dateFormatter: DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
}
