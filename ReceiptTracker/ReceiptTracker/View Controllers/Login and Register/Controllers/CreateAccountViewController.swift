//
//  CreateAccountViewController.swift
//  ReceiptTracker
//
//  Created by Uptiie on 9/23/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func signUp(_ sender: Any) {
        guard let firstName = firstNameTextField.text, let lastName = lastNameTextField.text,
            let username = usernameTextField.text, let email = emailTextField.text,
            let password = passwordTextField.text else {
                let alert = UIAlertController(title: "Unable to create account", message: "One or more fields is empty. All fields are required.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                
                return
        }
        
        if !username.isEmpty && (username.count < 4 || username.count > 12) {
            let alert = UIAlertController(title: "Invalid username", message: "Your username must be between 4-12 characters.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        } else if !password.isEmpty && (password.count < 4 || password.count > 12) {
            let alert = UIAlertController(title: "Invalid password", message: "Your password must be between 4-12 characters.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        
        let newUser = User(firstName: firstName, lastName: lastName, username: username, email: email, password: password, createdAt: Date(), updatedAt: Date())

        
        UserController.shared.signUp(with: newUser) { (error) in
            if let error = error {
                NSLog("Unable to create account: \(error)")
                
                DispatchQueue.main.async {
                    var alert = UIAlertController()
                    if error.rawValue == NetworkError.invalidInput.rawValue {
                        alert = UIAlertController(title: "Unable to create account", message: "This username or email is taken. Please log in, or use a different email/username.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    } else if error.rawValue == NetworkError.badResponse.rawValue {
                        alert = UIAlertController(title: "Unable to create account", message: "There was a network error. Please make sure you have a strong connection.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    }
                    self.present(alert, animated: true, completion: nil)
                }
            } else  {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "SignupSuccessfulSegue", sender: self)
                }
            }
        }
    }
    
    @IBAction func backToLoginTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
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
