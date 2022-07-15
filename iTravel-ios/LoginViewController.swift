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
        
        
        // Design UI:
        emailTxt.layer.cornerRadius = 10
        emailTxt.setLeftPaddingPoints(15)
        emailTxt.setRightPaddingPoints(15)
        
        passwordTxt.layer.cornerRadius = 10
        passwordTxt.setLeftPaddingPoints(15)
        passwordTxt.setRightPaddingPoints(15)
        
//        loginBtn.layer.cornerRadius = 25
    }
    
    @IBAction func backFromSignup(segue: UIStoryboardSegue){
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toSignupPage"){
            let dvc = segue.destination as! SignupViewController
            
        }else if(segue.identifier == "toHomePage"){
//            let dvc = segue.destination as! UserDetailsViewController
//            Model.instance.getUserDetails(){
//                user in
//                if user != nil {
//                    let pt = user
//                    dvc.user = pt
//                }
//            }
//            
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


//extension UITextField {
//    func setLeftPaddingPoints(_ amount:CGFloat){
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
//        self.leftView = paddingView
//        self.leftViewMode = .always
//    }
//    func setRightPaddingPoints(_ amount:CGFloat) {
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
//        self.rightView = paddingView
//        self.rightViewMode = .always
//    }
//}
