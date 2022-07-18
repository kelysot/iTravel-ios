//
//  AddPostViewController.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 09/06/2022.
//

import UIKit
import DropDown
import SwiftUI

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    @IBOutlet weak var titleTV: UITextField!
    @IBOutlet weak var descriptionTv: UITextView!
    @IBOutlet weak var locationTv: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var difficultyView: UIView!
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var mediumBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    @IBOutlet weak var addLocationBtn: UIButton!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var takePicBtn: UIButton!
    @IBOutlet weak var libraryBtn: UIButton!
    
    var selectedDifficulty = "Easy"
    var username:String = ""
    var coordinate = ""
    var userPosts: [String]? = []
    let greenColor = UIColor(red: 0.52, green: 0.58, blue: 0.51, alpha: 1.00)
    let whiteColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    
    @IBAction func openGallery(_ sender: Any) {
        takePicture(source: .photoLibrary)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        takePicture(source: .camera)
    }
    
    @IBAction func easyBtn(_ sender: UIButton) {
        changeButtonColor(backgroundColor: greenColor, textColor: whiteColor, btn: easyBtn)
        changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: mediumBtn)
        changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: hardBtn)
        selectedDifficulty = "Easy"
    }
    
    @IBAction func mediumBtn(_ sender: UIButton) {
        changeButtonColor(backgroundColor: greenColor, textColor: whiteColor, btn: mediumBtn)
        changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: easyBtn)
        changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: hardBtn)
        selectedDifficulty = "Medium"
    }
    
    @IBAction func hardBtn(_ sender: UIButton) {
        changeButtonColor(backgroundColor: greenColor, textColor: whiteColor, btn: hardBtn)
        changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: mediumBtn)
        changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: easyBtn)
        selectedDifficulty = "Hard"
    }
    
    @IBAction func save(_ sender: Any) {
        easyBtn.isEnabled = false
        mediumBtn.isEnabled = false
        hardBtn.isEnabled = false
        addLocationBtn.isEnabled = false
        postBtn.isEnabled = false
        cancelBtn.isEnabled = false
        takePicBtn.isEnabled = false
        libraryBtn.isEnabled = false
        titleTV.isUserInteractionEnabled = false
        descriptionTv.isUserInteractionEnabled = false
        locationTv.isUserInteractionEnabled = false

        let post = Post()
        post.id = UUID().uuidString
        if self.isValidTitle(title: self.titleTV.text!) == false {
            self.myAlert(title: "Faild to add post", msg: "Please add title")
        } else if self.isValidDescription(description: self.descriptionTv.text!) == false {
            self.myAlert(title: "Faild to add post", msg: "Please add description")
        } else if self.isValidLocation(location: self.locationTv.text!) == false{
            self.myAlert(title: "Faild to add post", msg: "Please add location")
        }
        else{
        Model.instance.getUserDetails(){
            user in
            if user != nil {
                self.username = user.email!
                post.userName = self.username
                post.title = self.titleTV.text
                post.description = self.descriptionTv.text
                post.difficulty = self.selectedDifficulty
                post.location = self.locationTv.text
                post.isPostDeleted = "false"
                post.coordinate = self.coordinate

                if user.posts == nil {
                    self.userPosts = []
                } else {
                    self.userPosts = user.posts
                }
                
                if let image = self.selectedImage{
                    Model.instance.uploadImage(name: post.id!, image: image) { url in
                        post.photo = url
                        Model.instance.add(post: post){
                            self.userPosts?.append(post.id!)
                            Model.instance.updateUserPosts(user: user, posts: self.userPosts!){
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }
                }else{
                    post.photo = "nature"
                    Model.instance.add(post: post){
                        self.userPosts?.append(post.id!)
                        Model.instance.updateUserPosts(user: user, posts: self.userPosts!){
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                
            }
        }
        }
        
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Design UI:
        titleTV.layer.cornerRadius = 10
        titleTV.setLeftPaddingPoints(15)
        titleTV.setRightPaddingPoints(15)
        
        locationTv.layer.cornerRadius = 10
        locationTv.setLeftPaddingPoints(15)
        locationTv.setRightPaddingPoints(15)
        
        descriptionTv.layer.cornerRadius = 10
        
        difficultyView.layer.cornerRadius = difficultyView.frame.height / 2
        difficultyView.clipsToBounds = true
        
        easyBtn.layer.cornerRadius = easyBtn.frame.height / 2
        mediumBtn.layer.cornerRadius = mediumBtn.frame.height / 2
        hardBtn.layer.cornerRadius = hardBtn.frame.height / 2
        
        img.layer.cornerRadius = 10;
        locationTv.isUserInteractionEnabled = false

    }
    
    
    func takePicture(source: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = source;
        imagePicker.allowsEditing = true
        if (UIImagePickerController.isSourceTypeAvailable(source))
        {
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    var selectedImage: UIImage?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        selectedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage
        self.img.image = selectedImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func changeButtonColor(backgroundColor: UIColor, textColor: UIColor, btn: UIButton) {
        btn.tintColor = textColor
        btn.backgroundColor = backgroundColor
    }
    
    func setLocation(location: String, coordinate: String) {
        self.locationTv.text = location
        self.coordinate = coordinate
        print(self.coordinate)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "location"){
            let dvc = segue.destination as! MapViewController
            dvc.delegate = self
        }
    }
    
    func myAlert(title:String, msg: String){
        easyBtn.isEnabled = true
        mediumBtn.isEnabled = true
        hardBtn.isEnabled = true
        addLocationBtn.isEnabled = true
        postBtn.isEnabled = true
        cancelBtn.isEnabled = true
        takePicBtn.isEnabled = true
        libraryBtn.isEnabled = true
        titleTV.isUserInteractionEnabled = true
        descriptionTv.isUserInteractionEnabled = true
        locationTv.isUserInteractionEnabled = false

        let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okButton)
        ViewController().dismiss(animated: false){ () -> Void in
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func isValidTitle(title:String) -> Bool{
        if title.count == 0 {
            return false
        }
        return true
    }
    
    func isValidDescription(description:String) -> Bool{
        if description.count == 0 {
            return false
        }
        return true
    }
    
    func isValidLocation(location:String) -> Bool{
        if location.count == 0 {
            return false
        }
        return true
    }
    
    
}
