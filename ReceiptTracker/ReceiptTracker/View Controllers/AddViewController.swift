//
//  AddViewController.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class AddViewController: UIViewController {
    
    @IBOutlet var receiptImageView: UIImageView!
    @IBOutlet weak var merchantTextField: UITextField!
    @IBOutlet weak var purchaseDateTextField: UITextField!
    @IBOutlet weak var purchaseAmountTextField: UITextField!
    @IBOutlet weak var addReceiptButton: UIButton!
    @IBOutlet weak var receiptDetailsLabel: UILabel!
    
    var imagePicker: ImagePicker!
    
    lazy var currencyFormatter: NumberFormatter = {
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            formatter.locale = Locale(identifier: "en_US")
            
    //        formatter.currencyCode = "USD"
            
            formatter.currencySymbol = "$"
            formatter.maximumFractionDigits = 2
            formatter.minimumFractionDigits = 2
            return formatter
        }()
    
    var receiptController: ReceiptController?
    var receipt: Receipt?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        setUI()
        
        purchaseAmountTextField.placeholder = currencyFormatter.string(from: NSNumber(value: 0))
        
        if let receipt = receipt {
            title = receipt.merchant
            merchantTextField.text = receipt.merchant
            purchaseDateTextField.text = receipt.purchaseDate
            purchaseAmountTextField.text = "\(receipt.amount)"
            addReceiptButton.setTitle("Update Receipt", for: .normal)
            if let data = receipt.image {
                receiptImageView.image = UIImage(data: data)
            }
        }
    }
    
    func setUI() {
        navigationController?.navigationBar.barTintColor = .background
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.text]
        navigationController?.navigationBar.tintColor = .text
        
        view.backgroundColor = .background
        receiptDetailsLabel.textColor = .text
    }
    
    @IBAction func addPhoto(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func addReceipt(_ sender: UIButton) {
        guard let receiptController = receiptController, let merchant = merchantTextField.text,
            let amountString = purchaseAmountTextField.text, let amount = Double(amountString) else { return }
        
        if let receipt = receipt {
            if let image = receiptImageView.image, let imageData = image.pngData() {
                receiptController.update(receipt: receipt, purchaseDate: Date(), merchant: merchant, amount: amount, notes: nil, tagName: nil, tagDescription: nil, categoryId: 1, image: imageData)
            } else {
                receiptController.update(receipt: receipt, purchaseDate: Date(), merchant: merchant, amount: amount, notes: nil, tagName: nil, tagDescription: nil, categoryId: 1)
            }
        } else {
            if let image = receiptImageView.image, let imageData = image.pngData() {
                receiptController.createReceipt(purchaseDate: Date(), merchant: merchant, amount: amount, notes: nil, tagName: nil, tagDescription: nil, categoryId: 1, image: imageData); #warning("Finish implementation in code and storyboard")
            } else {
                receiptController.createReceipt(purchaseDate: Date(), merchant: merchant, amount: amount, notes: nil, tagName: nil, tagDescription: nil, categoryId: 1); #warning("Finish implementation in code and storyboard")
            }
        }
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

extension AddViewController: ImagePickerDelegate {
    func didSelect(image: UIImage?) {
        self.receiptImageView.image = image
    }
}
