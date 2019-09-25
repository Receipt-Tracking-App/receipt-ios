//
//  AddViewController.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet var receiptImageView: UIView!
    @IBOutlet weak var merchantTextField: UITextField!
    @IBOutlet weak var purchaseDateTextField: UITextField!
    @IBOutlet weak var purchaseAmountTextField: UITextField!
    
    var receiptController: ReceiptController?
    var receipt: Receipt?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let receipt = receipt {
            merchantTextField.text = receipt.merchant
//            purchaseDateTextField = receipt.purchaseDate // TODO: Make receipt purchaseDate a formattedDate
            purchaseAmountTextField.text = "\(receipt.amount)"
            
        }
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        // TODO: Implement addPhoto
    }
    
    @IBAction func addReceipt(_ sender: UIButton) {
        guard let receiptController = receiptController, let merchant = merchantTextField.text,
            let amountString = purchaseAmountTextField.text, let amount = Double(amountString) else { return }
        receiptController.createReceipt(purchaseDate: Date(), merchant: merchant, amount: amount, notes: nil, tagName: nil, tagDescription: nil, categoryId: 1, createdAt: Date(), updatedAt: Date()); #warning("Finish implementation in code and storyboard")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
