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
    
    var delegate: EditUserDelegate?
    
    @IBOutlet weak var fullnameTxt: UITextField!
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var photo: UIImageView!
    
    
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
        // Do any additional setup after loading the view.
        if user != nil {
            updateDisplay()
        }
        //        Model.instance.getUserDetails(){
        //            user in
        //            if user != nil {
        //                self.usernameTxt.text = user.nickName
        //                self.fullnameTxt.text = user.fullName
        //            }
        //        }
    }
    
    func updateDisplay(){
        
        fullnameTxt.text = user?.fullName
        usernameTxt.text = user?.nickName
        
        if let urlStr = user?.photo {
            let url = URL(string: urlStr)
            photo.kf.setImage(with: url)
        }
    }

    
    
    @IBAction func saveBtn(_ sender: UIButton){
        
        let newUser = User()
        newUser.email = user?.email
        newUser.fullName = self.fullnameTxt.text
        newUser.nickName = self.usernameTxt.text
        newUser.posts = user?.posts
        newUser.photo = user?.photo
        
        
        if let image = selectedImage{
            Model.instance.uploadImage(name: newUser.fullName!, image: image) { url in
                newUser.photo = url
                Model.instance.editUser(user: newUser){
                    if self.passwordTxt.text != nil{
                        Model.instance.updateUserPassword(password: self.passwordTxt.text!){
                            success in
                            if success {
                                print("EDIT USER PASSWORD word")
                                self.delegate?.editUser(user: newUser)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    } else {
                        self.delegate?.editUser(user: newUser)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
                
            }
        }else{
            Model.instance.editUser(user: newUser){
                if self.passwordTxt.text != nil{
                    Model.instance.updateUserPassword(password: self.passwordTxt.text!){
                        success in
                        if success == true {
                            print("EDIT USER PASSWORD word")
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
        
        //        let newUser = User()
        //        Model.instance.getUserDetails(){
        //            user in
        //            if user != nil {
        //                newUser.email = user.email
        //                newUser.posts = user.posts
        //                newUser.photo = user.photo
        //
        //                newUser.nickName = self.usernameTxt.text
        //                newUser.fullName = self.fullnameTxt.text
        //
        //                if let image = self.selectedImage{//if selected image is null - new var with the same name
        //                    Model.instance.uploadImage(name: newUser.nickName!, image: image){
        //                        url in
        //                        newUser.photo = url
        //                    }
        //                }else{
        //                    newUser.photo = ""
        //                }
        //
        //                Model.instance.editUser(user: newUser){
        //                    success in
        //                    if success {
        //                        print("EDIT USER work")
        //                        if self.passwordTxt.text != nil{
        //                            Model.instance.updateUserPassword(password: self.passwordTxt.text!){
        //                                success in
        //                                if success {
        //                                    print("EDIT USER PASSWORD word")
        //                                }
        //                            }
        //                        }
        //                        self.delegate?.editUser(user: newUser)
        //                        self.navigationController?.popViewController(animated: true)
        //                    } else {
        //                        print("EDIT USER doesnt work")
        //
        //                    }
        //                }
        //            } else {
        //                print("User if null")
        //            }
        //        }
        
        
        
        //        let newUser = User()
        //
        //        Model.instance.getUserDetails(){
        //            user in
        //            if user != nil {
        //                newUser.email = user.email
        //                newUser.posts = user.posts
        //                newUser.photo = user.photo
        //
        //                newUser.nickName = self.usernameTxt.text
        //                newUser.fullName = self.fullnameTxt.text
        //
        //
        //                if let image = self.selectedImage{
        //                    Model.instance.uploadImage(name: newUser.nickName!, image: image) { url in
        //                        newUser.photo = url
        //                        Model.instance.editUser(user: newUser){
        //                            success in
        //                            if success{
        //                                if self.passwordTxt.text != nil{
        //                                    Model.instance.updateUserPassword(password: self.passwordTxt.text!){
        //                                        success in
        //                                        if success {
        //                                            print("EDIT USER PASSWORD word")
        //                                            self.delegate?.editUser(user: newUser)
        //                                            self.navigationController?.popViewController(animated: true)
        //                                        }
        //                                    }
        //                                }
        //
        //                            }
        //                        }
        //
        //                    }
        //                } else {
        //                    Model.instance.editUser(user: newUser){success in
        //                        if success{
        //                            if self.passwordTxt.text != nil{
        //                                Model.instance.updateUserPassword(password: self.passwordTxt.text!){success in
        //                                    if success {
        //                                        self.delegate?.editUser(user: newUser)
        //                                        self.navigationController?.popViewController(animated: true)
        //                                    }
        //                                }
        //                            }
        //
        //                        }
        //                    }
        //                }
        //
        //            }
        //        }
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
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

