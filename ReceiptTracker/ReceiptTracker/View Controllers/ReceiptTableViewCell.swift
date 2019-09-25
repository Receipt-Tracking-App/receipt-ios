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
        guard let receipt = receipt else { return }
        
        storeName.text = receipt.merchant
        amountLabel.text = "\(receipt.amount)"
        dateLabel.text = "$\(receipt.createdAt)"
    }
    
    var receipt: Receipt? {
        didSet {
            
        }
    }

    @IBOutlet weak var storeName: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
