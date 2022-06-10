//
//  AddPostViewController.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 09/06/2022.
//

import UIKit

class AddPostViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {

    
    @IBOutlet weak var titleTV: UITextField!
    @IBOutlet weak var locationTV: UITextField!
    @IBOutlet weak var descriptionTV: UITextField!
    @IBOutlet weak var difficultyTV: UITextField!
    @IBOutlet weak var img: UIImageView!
    
    @IBAction func openGallery(_ sender: Any) {
        takePicture(source: .photoLibrary)
    }
    
    @IBAction func save(_ sender: Any) {
        let post = Post()
        post.id = UUID().uuidString
        
        //Todo add user's userName.
        post.userName = "Noam"
        post.title = titleTV.text
        post.location = locationTV.text
        post.description = descriptionTV.text
        post.difficulty = difficultyTV.text
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

        // Do any additional setup after loading the view.
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
