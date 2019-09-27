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
    @IBOutlet weak var categoryPicker: UIPickerView!
    
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
    
    var addDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }; #warning("Delete after implementing UIDatePicker")
    
    var receiptController: ReceiptController?
    var receipt: Receipt?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        self.categoryPicker.delegate = self
        self.categoryPicker.dataSource = self
        
        setUI()
        
        purchaseAmountTextField.placeholder = currencyFormatter.string(from: NSNumber(value: 0))
        
        if let receipt = receipt {
            title = receipt.merchant
            merchantTextField.text = receipt.merchant
            purchaseDateTextField.text = "\(addDateFormatter.string(from: dateFormatter.date(from: receipt.purchaseDate ?? "") ?? Date()))"
            purchaseAmountTextField.text = "\(receipt.amount)"
            addReceiptButton.setTitle("Update Receipt", for: .normal)
            categoryPicker.selectRow(Int(receipt.categoryId), inComponent: 0, animated: true)
            if let data = receipt.image {
                receiptImageView.image = UIImage(data: data)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
         let categoryInt = Int16(categoryPicker.selectedRow(inComponent: 0))
        
        if let receipt = receipt {
            if let image = receiptImageView.image, let imageData = image.pngData() {
                receiptController.update(receipt: receipt, purchaseDate: Date(), merchant: merchant, amount: amount, notes: nil, tagName: nil, tagDescription: nil, categoryId: categoryInt, image: imageData)
            } else {
                receiptController.update(receipt: receipt, purchaseDate: Date(), merchant: merchant, amount: amount, notes: nil, tagName: nil, tagDescription: nil, categoryId: categoryInt)
            }
        } else {
            if let image = receiptImageView.image, let imageData = image.pngData() {
                receiptController.createReceipt(purchaseDate: Date(), merchant: merchant, amount: amount, notes: nil, tagName: nil, tagDescription: nil, category: ReceiptCategory(name: "", id: 1), image: imageData)
            } else {
                receiptController.createReceipt(purchaseDate: Date(), merchant: merchant, amount: amount, notes: nil, tagName: nil, tagDescription: nil, category: ReceiptCategory(name: "", id: 1))
            }
        }
        navigationController?.popViewController(animated: true)
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

extension AddViewController: ImagePickerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    func didSelect(image: UIImage?) {
        self.receiptImageView.image = image
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return sections.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return sections[row]
    }
}
