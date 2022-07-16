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
    
    @IBOutlet weak var titleTV: UITextField!
    @IBOutlet weak var locationTV: UITextField!
    @IBOutlet weak var descriptionTV: UITextField!
    @IBOutlet weak var img: UIImageView!
    
    
    @IBOutlet weak var myDropDownView: UIView!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBAction func deleteImage(_ sender: Any) {
        post?.photo = "nature"
        img.image = UIImage(named: "nature")
        self.selectedImage = UIImage(named: "nature")

    }
    
    let myDropDown = DropDown()
    let difficultyValuesArray = ["Easy", "Medium", "Hard"]
    var selectedDifficulty = ""
    
    @IBAction func isTappeddropdownButton(_ sender: Any) {
        myDropDown.show()
    }
    
    var post:Post?{
        didSet{
            if(titleTV != nil){
                updateDisplay()
            }
        }
    }
    
    func updateDisplay(){
        titleTV.text = post?.title
        locationTV.text = post?.location
        descriptionTV.text = post?.description
        difficultyLabel.text = post?.difficulty
        self.selectedDifficulty = (post?.difficulty)!
        
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
                newPost.location = self.locationTV.text
                newPost.description = self.descriptionTV.text
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if post != nil {
            updateDisplay()
        }
        
        myDropDown.anchorView = myDropDownView
        myDropDown.dataSource = difficultyValuesArray
        
        myDropDown.bottomOffset = CGPoint(x: 0, y: (myDropDown.anchorView?.plainView.bounds.height)!)
        myDropDown.topOffset = CGPoint(x: 0, y: -(myDropDown.anchorView?.plainView.bounds.height)!)
        myDropDown.direction = .bottom
        
        myDropDown.selectionAction = { (index: Int, item: String) in
            self.difficultyLabel.text = self.difficultyValuesArray[index]
            self.selectedDifficulty = self.difficultyValuesArray[index]
            self.difficultyLabel.textColor = .black
        }
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
