//
//  LoginViewUI.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/26/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

@IBDesignable
class LoginView: UIView {

    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet{
        self.layer.cornerRadius = cornerRadius
        }
    }

    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            self.layer.borderWidth = borderWidth
        }
    }

    @IBInspectable var borderColor: UIColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1){
        didSet{
            self.layer.borderColor = borderColor.cgColor
        }
    }
}
