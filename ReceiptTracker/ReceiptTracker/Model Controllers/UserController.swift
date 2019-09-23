//
//  UserController.swift
//  ReceiptTracker
//
//  Created by Jordan Christensen on 9/24/19.
//  Copyright © 2019 Mazjap Co Technologies. All rights reserved.
//

import Foundation
import CoreData

enum NetworkError: Error {
    case encodingError
    case responseError
    case otherError(Error)
    case noData
    case badDecode
    case noToken
}

enum LoginType: String {
    case register
    case login
}

class UserController {
    static let shared = UserController()
    
    var bearer: Token?
    var user: UserRepresentation?
    
    let baseURL = URL(string: "https://lambda-receipt-tracker.herokuapp.com/api")!
    
    func signUp(with user: User, completion: @escaping (NetworkError?) -> Void) {
        let signUpURL = baseURL
            .appendingPathComponent("auth")
            .appendingPathComponent(LoginType.register.rawValue)
        
        var request = URLRequest(url: signUpURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let userSignup = user.userSignup else { return }
        
        let encoder = JSONEncoder()
        do {
            let userData = try encoder.encode(userSignup)
            
            request.httpBody = userData
        } catch {
            NSLog("Error encoding user: \(error)")
            completion(.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error creating user on server: \(error)")
                completion(.otherError(error))
                return
            }
            completion(nil)
            }.resume()
    }
    
    func login(with user: User, completion: @escaping (NetworkError?) -> Void) {
        let loginURL = baseURL
            .appendingPathComponent("auth")
            .appendingPathComponent(LoginType.register.rawValue)
        
        var request = URLRequest(url: loginURL)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let userLogin = user.userLogin else { return }
        
        let encoder = JSONEncoder()
        do {
            request.httpBody = try encoder.encode(userLogin)
        } catch {
            NSLog("Error encoding user object: \(error)")
            completion(.encodingError)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                NSLog("Error logging in: \(error)")
                completion(.otherError(error))
                return
            }
            
            guard let data = data else {
                completion(.noData)
                return
            }
            
            do {
                let bearer = try JSONDecoder().decode(Token.self, from: data)
                self.bearer = bearer
                
            } catch {
                completion(.badDecode)
                return
            }
            completion(nil)
        }.resume()
    }
}
