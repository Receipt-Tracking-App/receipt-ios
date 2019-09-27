//
//  LoginViewController.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInView: UIView!
    
    @IBOutlet weak var signInButtonView: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        guard let username = usernameTextField.text, let password = passwordTextField.text else { return }
        
        let currentUser = UserLogin(userId: username, password: password)
        UserController.shared.login(with: currentUser) { (error) in
            if let error = error {
                NSLog("Unable to log in: \(error)")
                
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Unable to log in", message: "Incorrect username and/or password. Please try again.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }

            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "LoginSuccessfulSegue", sender: self)
                }
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
