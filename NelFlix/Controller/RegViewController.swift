//
//  RegViewController.swift
//  NelFlix
//
//  Created by ZHI XUAN MO on 4/17/20.
//  Copyright © 2020 zhixuan mo. All rights reserved.
//

import UIKit
import Firebase

class RegViewController: UIViewController {

    private let segIDtoProfileSetup = "RegToProfileSetup"
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func SignUpBtnPressed(_ sender: UIButton) {
        if let email = emailField.text , let password = passwordField.text
            {
                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
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
                        self.performSegue(withIdentifier: self.segIDtoProfileSetup, sender: self)
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
