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
        // Do any additional setup after loading the view.
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

