//
//  EditUserViewController.swift
//  iTravel-ios
//
//  Created by Bar Elimelech on 10/06/2022.
//

import UIKit

protocol EditUserDelegate {
    func editUser(user: User)
}

class EditUserViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var openGalleryOutlet: UIButton!
    @IBOutlet weak var saveBtnOutlet: UIButton!
    @IBOutlet weak var deleteImageOutlet: UIButton!
    var delegate: EditUserDelegate?
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var photo: UIImageView!
    @IBAction func deleteImage(_ sender: Any) {
        user?.photo = "avatar"
        self.photo.image = UIImage(named: "avatar")
        self.selectedImage = UIImage(named: "avatar")
    }
    
    var user:User?{
        didSet{
            if(fullnameTxt != nil){
                updateDisplay()
            }
        }
    }
    
    var callBack: ((_ user: User)-> Void)?
    var selectedImage: UIImage?
    
    @IBAction func openGallery(_ sender: UIButton) {
        takePicture(source: .photoLibrary)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            updateDisplay()
        }
        
        // Update UI:
        fullnameTxt.layer.cornerRadius = 10
        fullnameTxt.setLeftPaddingPoints(15)
        fullnameTxt.setRightPaddingPoints(15)
        
        usernameTxt.layer.cornerRadius = 10
        usernameTxt.setLeftPaddingPoints(15)
        usernameTxt.setRightPaddingPoints(15)
        
        passwordTxt.layer.cornerRadius = 10
        passwordTxt.setLeftPaddingPoints(15)
        passwordTxt.setRightPaddingPoints(15)
        
        photo.layer.cornerRadius = photo.frame.height / 2
        photo.clipsToBounds = true
    }
    
    func updateDisplay(){
        fullnameTxt.text = user?.fullName
        usernameTxt.text = user?.nickName
        
        if let urlStr = user?.photo {
            if (!urlStr.elementsEqual("avatar")){
                let url = URL(string: urlStr)
                self.photo?.kf.setImage(with: url)
            }else{
                self.photo.image = UIImage(named: "avatar")
            }
            
        }
    }
    
    
    
    @IBAction func saveBtn(_ sender: UIButton){
        saveBtnOutlet.isEnabled = false
        openGalleryOutlet.isEnabled = false
        deleteImageOutlet.isEnabled = false
        fullnameTxt.isEnabled = false
        usernameTxt.isEnabled = false
        passwordTxt.isEnabled = false
        
        if self.isValid(text: self.usernameTxt.text!) == false {
            self.myAlert(title: "Faild to edit user", msg: "Please add username")
        } else if self.isValid(text: self.fullnameTxt.text!) == false {
            self.myAlert(title: "Faild to edit user", msg: "Please add full name")
        } else{
            
            let newUser = User()
            newUser.email = user?.email
            newUser.fullName = self.fullnameTxt.text
            newUser.nickName = self.usernameTxt.text
            newUser.posts = user?.posts
            newUser.photo = user?.photo
            
            if let image = selectedImage{
                Model.instance.uploadImage(name: newUser.nickName!, image: image) { url in
                    newUser.photo = url
                    Model.instance.editUser(user: newUser){
                        if self.passwordTxt.text != nil{
                            Model.instance.updateUserPassword(password: self.passwordTxt.text!){
                                success in
                                if success {
                                    print("EDIT USER PASSWORD work")
                                    self.delegate?.editUser(user: newUser)
                                    self.navigationController?.popViewController(animated: true)
                                } else {
                                    self.delegate?.editUser(user: newUser)
                                    self.navigationController?.popViewController(animated: true)
                                }
                            }
                        }
                    }
                }
            }else{
                Model.instance.editUser(user: newUser){
                    if self.passwordTxt.text != nil{
                        Model.instance.updateUserPassword(password: self.passwordTxt.text!){
                            success in
                            if success == true {
                                print("EDIT USER PASSWORD work")
                                self.delegate?.editUser(user: newUser)
                                self.navigationController?.popViewController(animated: true)
                            } else {
                                self.delegate?.editUser(user: newUser)
                                self.navigationController?.popViewController(animated: true)
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage
        
        self.photo.image = selectedImage
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func myAlert(title:String, msg: String){
        saveBtnOutlet.isEnabled = true
        openGalleryOutlet.isEnabled = true
        deleteImageOutlet.isEnabled = true
        fullnameTxt.isEnabled = true
        usernameTxt.isEnabled = true
        passwordTxt.isEnabled = true
        
        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        ViewController().dismiss(animated: false){ () -> Void in
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func isValid(text:String) -> Bool{
        if text.count == 0 {
            return false
        }
        return true
    }
    
    
}

