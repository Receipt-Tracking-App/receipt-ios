//
//  ReceiptTableViewCell.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell {
    
    var receipt: Receipt? {
        didSet {
            updateViews()
        }
    }

    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func updateViews() {
        guard let receipt = receipt else { return }
        storeLabel.text = receipt.merchant
        amountLabel.text = "\(receipt.amount)"
//        dateLabel.text = receipt.purchaseDate    // TODO: Make receipt purchaseDate a formattedDate string
    }
}
