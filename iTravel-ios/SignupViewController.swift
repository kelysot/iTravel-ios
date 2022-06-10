//
//  SignupViewController.swift
//  iTravel-ios
//
//  Created by Bar Elimelech on 08/06/2022.
//

import UIKit

class SignupViewController: UIViewController, UIImagePickerControllerDelegate &
    UINavigationControllerDelegate {
    
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
        
        if let image = selectedImage{//if selected image is null - new var with the same name
            Model.instance.uploadImage(name: user.nickName!, image: image){
                url in
                user.photo = url
                Model.instance.createUser(email: user.email!, password: self.password.text!){ success in
                    if success == true{
                        Model.instance.add(user: user){
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                    else{
                        // create the alert
                        let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: .alert)
                        // add an action (button)
                        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                        // show the alert
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            
                
            }
        }else{
            Model.instance.createUser(email: user.email!, password: self.password.text!){ success in
                if success == true{
                    Model.instance.add(user: user){
                        self.navigationController?.popViewController(animated: true)
                    }
                } else {
                    // create the alert
                    let alert = UIAlertController(title: "My Title", message: "This is my message.", preferredStyle: .alert)
                    // add an action (button)
                    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    // show the alert
                    self.present(alert, animated: true, completion: nil)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
