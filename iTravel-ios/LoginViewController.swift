//
//  LoginViewController.swift
//  iTravel-ios
//
//  Created by Bar Elimelech on 08/06/2022.
//

import UIKit

class LoginViewController: UIViewController {

    let userDefault = UserDefaults.standard

    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBAction func loginBtn(_ sender: UIButton) {
        Model.instance.signIn(email: self.emailTxt.text!, password: self.passwordTxt.text!){ success in
            if success{
                self.navigationController?.popViewController(animated: true)
            } else {
                let alertController = UIAlertController(title: "Faild to log in", message: "Email or password is incorrect", preferredStyle: .alert)
                let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alertController.addAction(okButton)
                self.dismiss(animated: false){ () -> Void in
                     self.present(alertController, animated: true, completion: nil)
                }
            }
        }
    }
    @IBAction func signupBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "toSignupPage", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        Model.instance.checkIfUserLoggedIn(){
            success in
            if success{
                self.performSegue(withIdentifier: "toHomePage", sender: nil)
            }
        }

        emailTxt.layer.cornerRadius = 10
        emailTxt.setLeftPaddingPoints(15)
        emailTxt.setRightPaddingPoints(15)
        
        passwordTxt.layer.cornerRadius = 10
        passwordTxt.setLeftPaddingPoints(15)
        passwordTxt.setRightPaddingPoints(15)
    }
    
    @IBAction func backFromSignup(segue: UIStoryboardSegue){
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toSignupPage"){
            let dvc = segue.destination as! SignupViewController
            
        }
    }


}
