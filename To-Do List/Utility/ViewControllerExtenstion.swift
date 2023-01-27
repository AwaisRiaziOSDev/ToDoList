//
//  ViewControllerExtenstion.swift
//  To-Do List
//
//  Created by Awais Malik on 25/01/2023.
//

import Foundation
import UIKit
import NVActivityIndicatorView
var progressIndicatorView = UIView()
var NVActivityIndicatorViewindicator: NVActivityIndicatorView?

extension UIViewController {
    
    
    class func instantiateFromStoryboard(_ name: String = "Main") -> Self {
        return instantiateFromStoryboardHelper(name)
    }
    
    class func instantiateVCFromStoryboard(_ name: String) -> UIViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: name)
    }
    
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ name: String) -> T {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        let identifier = String(describing: self)
        let controller = storyboard.instantiateViewController(withIdentifier: identifier) as! T
        return controller
    }
    
    // for moving back screen on click back arrow or button
    @IBAction func backButtonPresses(_ sender : UIButton){
        self.navigationController?.popViewController(animated: true)
    }

    // validation for authentication feilds email, password
    func authenticationFieldValidation(email: String, password: String)-> Bool{
        
        if email == "" || !email.isValidEmail(){
            self.showAlertMessage(message: "Please provide valid email address")
            return false
        }
        if password == "" || password.count < 6{
            self.showAlertMessage(message: "Please provide six digit password")
            return false
        }
        return true
    }
    
    // for showing simple alert message
    func showAlertMessage(message: String){
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // showing alert message and do something on button action
    func showAlertWithOneButton(_ title: String, message: String, buttonTitle: String, action: @escaping ((UIAlertAction) -> ())) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: action))
        self.present(alert, animated: true, completion: nil)
    }
    
     func showAlertWithTwoButton(_ title: String, message: String, style: UIAlertController.Style = .alert, buttonTitleOne: String, buttonTitleTwo: String, handlerOne: ((UIAlertAction) -> ())?, handlerTwo: ((UIAlertAction) -> ())?) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        
            alert.addAction(UIAlertAction(title: buttonTitleOne, style: .default, handler: handlerOne))
            alert.addAction(UIAlertAction(title: buttonTitleTwo, style: .default, handler: handlerTwo))
        
            self.present(alert, animated: true, completion: nil)
        }
    
    // Create loaderView and show
    func showProgressView(views: UIView){
        progressIndicatorView.removeFromSuperview()
        progressIndicatorView.frame = CGRect(x: 0, y: 0, width: views.bounds.width, height: views.bounds.height)
        progressIndicatorView.backgroundColor = UIColor.black
        progressIndicatorView.layer.opacity = 0.6
        if let act = NVActivityIndicatorViewindicator{
            act.removeFromSuperview()
        }
        let frame =  CGRect(x: (progressIndicatorView.bounds.width/2) - 20, y: (progressIndicatorView.bounds.height/2) - 20, width: 40, height: 40)
        NVActivityIndicatorViewindicator = NVActivityIndicatorView(frame: frame, type: .ballSpinFadeLoader, color: UIColor.green, padding: 8)
        NVActivityIndicatorViewindicator?.startAnimating()
        progressIndicatorView.addSubview(NVActivityIndicatorViewindicator!)
        views.addSubview(progressIndicatorView)
       
    }
    
    // dismiss loaderView
    func hideProgressView(){
        if let act = NVActivityIndicatorViewindicator{
            act.removeFromSuperview()
        }
        progressIndicatorView.removeFromSuperview()
    }
    
}
