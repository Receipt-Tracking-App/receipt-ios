//
//  ReceiptTableViewCell.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        updateViews()
    }
    
    var receipt: Receipt? {
        didSet {
            updateViews()
        }
    }
    
    var cellDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }
    
    func updateViews() {
        if let receipt = receipt, let createdAt = receipt.createdAt {
            storeName.text = receipt.merchant
            amountLabel.text = "$\(receipt.amount)"
            dateLabel.text = "\(cellDateFormatter.string(from: dateFormatter.date(from: createdAt) ?? Date()))"
        }
    }

    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
