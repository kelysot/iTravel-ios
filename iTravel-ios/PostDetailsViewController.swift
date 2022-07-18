//
//  PostDetailsViewController.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 09/06/2022.
//

import UIKit
import MapKit

class PostDetailsViewController: UIViewController, EditPostDelegate {
    func editPost(post: Post) {
        self.post = post
    }
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionTv: UITextView!
    @IBOutlet weak var editPostBtn: UIBarButtonItem!
    
    var post:Post?{
        didSet{
            if(titleLabel != nil){
                updateDisplay()
            }
        }
    }
    
    func updateDisplay(){
        titleLabel.text = post?.title
        userNameLabel.text = post?.userName
        locationLabel.text = post?.location
        difficultyLabel.text = post?.difficulty
        descriptionTv.text = post?.description

        if let urlStr = post?.photo {
            if (!urlStr.elementsEqual("nature")){
                let url = URL(string: urlStr)
                postImage?.kf.setImage(with: url)
            }else{
                postImage.image = UIImage(named: "nature")
            }
            
        }
        
        Model.instance.getUserDetails(){
            user in
            if user != nil{
                if let urlUserStr = user.photo {
                    if (!urlUserStr.elementsEqual("")){
                        let url = URL(string: urlUserStr)
                        self.userImage?.kf.setImage(with: url)
                    }else{
                        self.userImage.image = UIImage(named: "avatar")
                    }
                    
                }
                
                if user.nickName == self.post?.userName {
                    self.editPostBtn.isEnabled = true
                    self.editPostBtn.tintColor = UIColor.systemBlue
                
                } else {
                    self.editPostBtn.isEnabled = false
                    self.editPostBtn.tintColor = UIColor.clear
                }
            }
        }
    }

    
    override func viewDidLoad() {
        self.spinner.startAnimating()
        super.viewDidLoad()

        if post != nil {
            updateDisplay()
        }
        
        difficultyLabel.layer.masksToBounds = true
        difficultyLabel.layer.cornerRadius = 5
        
        postImage.clipsToBounds = true
        postImage.layer.cornerRadius = 7
        
        userImage.clipsToBounds = true
        userImage.layer.cornerRadius = userImage.frame.height / 2
        
        self.spinner.hidesWhenStopped = true
        self.spinner.stopAnimating()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openEditPost"){
            let dvc = segue.destination as! EditPostViewController
            dvc.post = post
            dvc.delegate = self
        }
    }


}

