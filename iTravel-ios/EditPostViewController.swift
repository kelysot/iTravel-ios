//
//  EditPostViewController.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 09/06/2022.
//

import UIKit

protocol EditPostDelegate {
    func editPost(post: Post)
}

class EditPostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    var delegate: EditPostDelegate?

    
    @IBOutlet weak var titleTV: UITextField!
    @IBOutlet weak var locationTV: UITextField!
    @IBOutlet weak var descriptionTV: UITextField!
    @IBOutlet weak var difficultyTV: UITextField!
    @IBOutlet weak var img: UIImageView!
    
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
        difficultyTV.text = post?.difficulty
        descriptionTV.text = post?.description

        if let urlStr = post?.photo {
            let url = URL(string: urlStr)
            img.kf.setImage(with: url)
        }
    }
    
    @IBAction func openGallery(_ sender: Any) {
        takePicture(source: .photoLibrary)
    }
    
    var callBack: ((_ post: Post)-> Void)?
    
    @IBAction func editBtn(_ sender: Any) {
        let newPost = Post()
        newPost.id = post!.id

        //Todo add user's userName.
        newPost.userName = "Noam"
        newPost.title = titleTV.text
        newPost.location = locationTV.text
        newPost.description = descriptionTV.text
        newPost.difficulty = difficultyTV.text
        newPost.photo = post?.photo

        if let image = selectedImage{
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
    
    @IBAction func cancelBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if post != nil {
            updateDisplay()
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
