//
//  AddPostViewController.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 09/06/2022.
//

import UIKit
import DropDown

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    @IBOutlet weak var titleTV: UITextField!
    @IBOutlet weak var locationTV: UITextField!
    @IBOutlet weak var descriptionTV: UITextField!
    @IBOutlet weak var difficultyTV: UITextField!
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var myDropDownView: UIView!
    @IBOutlet weak var dropdownButton: UIButton!
    @IBOutlet weak var difficultyLabel: UILabel!
    
    let myDropDown = DropDown()
    let difficultyValuesArray = ["Easy", "Medium", "Hard"]
    var selectedDifficulty = "Easy"
    
    @IBAction func isTappeddropdownButton(_ sender: Any) {
        myDropDown.show()
    }
    
    @IBAction func openGallery(_ sender: Any) {
        takePicture(source: .photoLibrary)
    }
    
    @IBAction func openCamera(_ sender: Any) {
        takePicture(source: .camera)
    }
    
    @IBAction func save(_ sender: Any) {
        let post = Post()
        post.id = UUID().uuidString
        
        //Todo add user's userName.
        post.userName = "Noam"
        post.title = titleTV.text
        post.location = locationTV.text
        post.description = descriptionTV.text
        post.difficulty = self.selectedDifficulty
        post.isPostDeleted = "false"

        if let image = selectedImage{
            Model.instance.uploadImage(name: post.id!, image: image) { url in
                post.photo = url
                Model.instance.add(post: post){
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
        }else{
            post.photo = ""
            Model.instance.add(post: post){
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        difficultyLabel.text = "Easy"

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
