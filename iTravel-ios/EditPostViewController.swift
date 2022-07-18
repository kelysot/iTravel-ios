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
            } else if(difficulty.elementsEqual("Medium")) {
                changeButtonColor(backgroundColor: greenColor, textColor: whiteColor, btn: mediumBtn)
                changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: easyBtn)
                changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: hardBtn)
            } else if(difficulty.elementsEqual("Hard")) {
                changeButtonColor(backgroundColor: greenColor, textColor: whiteColor, btn: hardBtn)
                changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: mediumBtn)
                changeButtonColor(backgroundColor: whiteColor, textColor: greenColor, btn: easyBtn)
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
    
    @IBAction func editBtn(_ sender: Any) {
        let newPost = Post()
        newPost.id = post!.id
        
        Model.instance.getUserDetails(){
            user in
            if user != nil{
                //Todo add user's userName.
                newPost.userName = user.nickName
                newPost.title = self.titleTV.text
                newPost.location = self.locationTv.text
                newPost.description = self.descriptionTv.text
                newPost.difficulty = self.selectedDifficulty
                newPost.photo = self.post?.photo
                newPost.isPostDeleted = "false"
                
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
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func deleteBtn(_ sender: Any) {
        var deletedPost = Post()
        deletedPost = post!
        deletedPost.isPostDeleted = "true"
        Model.instance.editPost(post: deletedPost){
            self.navigationController?.popToRootViewController(animated: true)
        }
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
    
}
