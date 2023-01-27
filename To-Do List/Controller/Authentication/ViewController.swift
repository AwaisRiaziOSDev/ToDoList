//
//  ViewController.swift
//  To-Do List
//
//  Created by Awais Malik on 25/01/2023.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    lazy var networkManager = Network()
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // sign in by email or password
    @IBAction func signInAction(_ sender: UIButton){
        let email = txtEmail.text ?? ""
        let password = txtPassword.text ?? ""
        if self.authenticationFieldValidation(email: email, password: password){
            self.showProgressView(views: self.view)
            networkManager.signInUser(email: email, pass: password) { success, msg  in
                self.hideProgressView()
                if success{
                    let vc = HomeVC.instantiateFromStoryboard("Home")
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    self.showAlertMessage(message: msg)
                }
            }
        }
       
    }
    
    
    // move to signup screen for create new account
    @IBAction func signUpAction(_ sender: UIButton){
        let vc = SignUpVC.instantiateFromStoryboard("Main")
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

