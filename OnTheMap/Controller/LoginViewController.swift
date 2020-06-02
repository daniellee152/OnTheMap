//
//  ViewController.swift
//  OnTheMap
//
//  Created by Le Dat on 5/27/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKUIDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func loginTapped(_ sender: UIButton) {
        setLoggingIn(true)
        MapClient.login(username: self.emailTextField.text ?? "", password: self.passwordTextField.text ?? "", completion: handleLoginResponse(success:error:)) 
    }
    
    func handleLoginResponse(success: Bool, error: Error?){
        if success{
            MapClient.getStudentLocation(completion: handleGetStudentLocation(students:error:))
            MapClient.getPublicUser { (response, error) in
                if error != nil{
                    print("error getting public user profile")
                }
            }
            self.performSegue(withIdentifier: "completeLogin", sender: nil)
            self.setLoggingIn(false)
        }else{
            self.showLoginFailure(message: error?.localizedDescription ?? "")
        }
    }
    
    func handleGetStudentLocation(students : [StudentInfo], error: Error?){
        if error != nil{
            print("error getting student location")
        }
        StudentModel.loccation = students
 
    }
    
    @IBAction func SignUpTapped(_ sender: UIButton) {
        setLoggingIn(true)
        UIApplication.shared.open(MapClient.Endpoints.webAuth.url, options: [:]) { (success) in
            self.setLoggingIn(false)
        }
    }
    
    
    func showLoginFailure(message: String) {
        let alertVC = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.setLoggingIn(false)
            self.emailTextField.text = ""
            self.passwordTextField.text = ""
        })
        alertVC.addAction(action)
        show(alertVC, sender: nil)
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
        signUpButton.isEnabled = !loggingIn
    }
}

