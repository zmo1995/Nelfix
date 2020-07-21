//
//  LoginViewController.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 4/17/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    private let segIDtoMain = "LoginToMain"
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBOutlet weak var stackview: UIStackView!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

  
    @IBAction func SignInBtnPressed(_ sender: UIButton) {
        if let email = emailField.text , let password = passwordField.text
        {
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if let e = error
                {
                    let alert = UIAlertController(title: "Error!", message: e.localizedDescription , preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: .default) { (action) in
                        alert.dismiss(animated: true, completion: nil)
                    }
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                else
                {
                    self.performSegue(withIdentifier: self.segIDtoMain, sender: self)
                }
            }
        }
        
    }
    
    
    
    

}
