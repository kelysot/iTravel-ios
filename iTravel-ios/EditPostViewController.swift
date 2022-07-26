//
//  EditPostViewController.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 09/06/2022.
//

import UIKit
import DropDown

protocol EditPostDelegate {
    func editPost(post: Post)
}

class EditPostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    var delegate: EditPostDelegate?
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var titleTV: UITextField!
    @IBOutlet weak var locationTv: UITextField!
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var difficultyView: UIView!
    @IBOutlet weak var descriptionTv: UITextView!
    @IBOutlet weak var easyBtn: UIButton!
    @IBOutlet weak var mediumBtn: UIButton!
    @IBOutlet weak var hardBtn: UIButton!
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var changeLocationBtn: UIButton!
    @IBOutlet weak var libraryBtn: UIButton!
    @IBOutlet weak var takePicBtn: UIButton!
    @IBOutlet weak var deletePhotoBtn: UIButton!
    @IBOutlet weak var deletePostBtn: UIBarButtonItem!
    
    
    let greenColor = UIColor(red: 0.52, green: 0.58, blue: 0.51, alpha: 1.00)
    let whiteColor = UIColor(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
    
    @IBAction func deleteImage(_ sender: Any) {
        post?.photo = "nature"
        img.image = UIImage(named: "nature")
        self.selectedImage = UIImage(named: "nature")
        
    }
    
    var selectedDifficulty = ""
    
    var post:Post?{
        didSet{
            if(titleTV != nil){
                updateDisplay()
            }
        }
    }
    
    func updateDisplay(){
        titleTV.text = post?.title
        locationTv.text = post?.location
        descriptionTv.text = post?.description
        
        if let difficulty = post?.difficulty {
            if(difficulty.elementsEqual("Easy")) {
                changeButtonColor(backgroundColor: greenColor, textColor: whiteColor, btn: easyBtn)
                changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: mediumBtn)
                changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: hardBtn)
                self.selectedDifficulty = "Easy"
            } else if(difficulty.elementsEqual("Medium")) {
                changeButtonColor(backgroundColor: greenColor, textColor: whiteColor, btn: mediumBtn)
                changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: easyBtn)
                changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: hardBtn)
                self.selectedDifficulty = "Medium"
            } else if(difficulty.elementsEqual("Hard")) {
                changeButtonColor(backgroundColor: greenColor, textColor: whiteColor, btn: hardBtn)
                changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: mediumBtn)
                changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: easyBtn)
                self.selectedDifficulty = "Hard"
            }
        }
        
        if let urlStr = post?.photo {
            if (!urlStr.elementsEqual("nature")){
                let url = URL(string: urlStr)
                img?.kf.setImage(with: url)
            }else{
                img.image = UIImage(named: "nature")
            }
        }
    }
    
    @IBAction func openGallery(_ sender: Any) {
        takePicture(source: .photoLibrary)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        takePicture(source: .camera)
    }
    
    var callBack: ((_ post: Post)-> Void)?
    
    func enabledButtons() {
        easyBtn.isEnabled = true
        mediumBtn.isEnabled = true
        hardBtn.isEnabled = true
        changeLocationBtn.isEnabled = true
        saveBtn.isEnabled = true
        cancelBtn.isEnabled = true
        takePicBtn.isEnabled = true
        libraryBtn.isEnabled = true
        titleTV.isUserInteractionEnabled = true
        descriptionTv.isUserInteractionEnabled = true
        locationTv.isUserInteractionEnabled = false
        deletePhotoBtn.isEnabled = true
        deletePostBtn.isEnabled = true
    }
    
    @IBAction func editBtn(_ sender: Any) {
        easyBtn.isEnabled = false
        mediumBtn.isEnabled = false
        hardBtn.isEnabled = false
        changeLocationBtn.isEnabled = false
        saveBtn.isEnabled = false
        cancelBtn.isEnabled = false
        takePicBtn.isEnabled = false
        libraryBtn.isEnabled = false
        titleTV.isUserInteractionEnabled = false
        descriptionTv.isUserInteractionEnabled = false
        locationTv.isUserInteractionEnabled = false
        deletePhotoBtn.isEnabled = false
        deletePostBtn.isEnabled = false
        
        let newPost = Post()
        newPost.id = post!.id
        
        if self.isValidTitle(title: self.titleTV.text!) == false {
            self.myAlert(title: "Faild to edit post", msg: "Please add title")
            enabledButtons()
        } else if self.isValidDescription(description: self.descriptionTv.text!) == false {
            self.myAlert(title: "Faild to edit post", msg: "Please add description")
            enabledButtons()
        } else if self.isValidLocation(location: self.locationTv.text!) == false{
            self.myAlert(title: "Faild to edit post", msg: "Please add location")
            enabledButtons()
        }
        else{
            Model.instance.getUserDetails(){
                user in
                if user != nil{
                    //Todo add user's userName.
                    newPost.userName = user.email
                    newPost.title = self.titleTV.text
                    newPost.location = self.locationTv.text
                    newPost.description = self.descriptionTv.text
                    newPost.difficulty = self.selectedDifficulty
                    newPost.photo = self.post?.photo
                    newPost.isPostDeleted = "false"
                    newPost.coordinate = "" //Add coordinate
                    
                    if let image = self.selectedImage{
                        Model.instance.uploadImage(name: newPost.id!, image: image) { url in
                            newPost.photo = url
                            Model.instance.editPost(post: newPost){
                                self.delegate?.editPost(post: newPost)
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                    }else{
                        Model.instance.editPost(post: newPost){
                            self.delegate?.editPost(post: newPost)
                            self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func deleteBtn(_ sender: Any) {
        let alert = UIAlertController(title: "Delete post", message: "Are you sure you want to delete post?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [self] UIAlertAction in
            var deletedPost = Post()
            deletedPost = self.post!
            deletedPost.isPostDeleted = "true"
            Model.instance.editPost(post: deletedPost){
                self.navigationController?.popToRootViewController(animated: true)
            }        }))
        present(alert, animated: true, completion: nil)
        
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
    
    override func viewDidLoad() {
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        super.viewDidLoad()
        
        if post != nil {
            updateDisplay()
        }
        
        // Update UI:
        titleTV.layer.cornerRadius = 10
        titleTV.setLeftPaddingPoints(15)
        titleTV.setRightPaddingPoints(15)
        
        descriptionTv.layer.cornerRadius = 10
        
        locationTv.layer.cornerRadius = 10
        locationTv.setLeftPaddingPoints(15)
        locationTv.setRightPaddingPoints(15)
        
        difficultyView.layer.cornerRadius = difficultyView.frame.height / 2
        difficultyView.clipsToBounds = true
        
        easyBtn.layer.cornerRadius = easyBtn.frame.height / 2
        mediumBtn.layer.cornerRadius = mediumBtn.frame.height / 2
        hardBtn.layer.cornerRadius = hardBtn.frame.height / 2
        
        img.layer.cornerRadius = 10;
        locationTv.isUserInteractionEnabled = false
        self.spinner.stopAnimating()
    }
    
    func changeButtonColor(backgroundColor: UIColor, textColor: UIColor, btn: UIButton) {
        btn.tintColor = textColor
        btn.backgroundColor = backgroundColor
    }
    
    func setLocation(location: String) {
        self.locationTv.text = location
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
    
    func myAlert(title:String, msg: String){
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
