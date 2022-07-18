//
//  SignupViewController.swift
//  iTravel-ios
//
//  Created by Bar Elimelech on 08/06/2022.
//

import UIKit

class SignupViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBAction func openCamera(_ sender: UIButton) {
        takePicture(source: .camera)
    }
    @IBAction func openGallery(_ sender: UIButton) {
        takePicture(source: .photoLibrary)
    }
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var verifyPassword: UITextField!
    
    @IBAction func signupBtn(_ sender: UIButton) {
        let user = User()
        user.email = email.text
        user.fullName = fullname.text
        user.nickName = username.text
        let isvalidPassword = self.checkPassword(password: self.password.text!)
        let isValidEmail = self.isValidEmail(email.text!)
        if isvalidPassword == false {
            myAlert(title: "Faild to sign up", msg: "Password should be at least 6 characters")
        } else if password.text != verifyPassword.text{
            myAlert(title: "Faild to sign up", msg: "Password and confirm password doesn't match")
        } else if isValidEmail == false {
            myAlert(title: "Faild to sign up", msg: "Email is not valid")
        }
        
        else {
            if let image = selectedImage{//if selected image is null - new var with the same name
                Model.instance.uploadImage(name: user.nickName!, image: image){
                    url in
                    user.photo = url
                    Model.instance.checkIfUserExist(email: user.email!){ success in
                        if success == true{
                            self.myAlert(title: "Faild to sign up", msg: "Email already exist")
                        }
                        else {
                            Model.instance.createUser(email: user.email!, password: self.password.text!){ success in
                                if success == true {
                                    Model.instance.add(user: user){
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                            }
                        }
                    }
                }
            }else{
                user.photo = "avatar"
                Model.instance.checkIfUserExist(email: user.email!){ success in
                    if success == true{
                        self.myAlert(title: "Faild to sign up", msg: "Email already exist")
                    }
                    else {
                        Model.instance.createUser(email: user.email!, password: self.password.text!){ success in
                            if success == true{
                                Model.instance.add(user: user){
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    func takePicture(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source
        imagePicker.allowsEditing = true
        
        if (UIImagePickerController.isSourceTypeAvailable(source)) {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    var selectedImage: UIImage?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage
        
        self.userImage.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    func checkPassword(password:String)->Bool{
        if(password.count < 6){
            return false
        }
        return true
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func myAlert(title:String, msg: String){
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        self.dismiss(animated: false){ () -> Void in
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Update UI:
        fullname.layer.cornerRadius = 10
        fullname.setLeftPaddingPoints(15)
        fullname.setRightPaddingPoints(15)
        
        username.layer.cornerRadius = 10
        username.setLeftPaddingPoints(15)
        username.setRightPaddingPoints(15)
        
        email.layer.cornerRadius = 10
        email.setLeftPaddingPoints(15)
        email.setRightPaddingPoints(15)
        
        password.layer.cornerRadius = 10
        password.setLeftPaddingPoints(15)
        password.setRightPaddingPoints(15)
        
        verifyPassword.layer.cornerRadius = 10
        verifyPassword.setLeftPaddingPoints(15)
        verifyPassword.setRightPaddingPoints(15)
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
