//
//  PostDetailsViewController.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 09/06/2022.
//

import UIKit

class PostDetailsViewController: UIViewController, EditPostDelegate {
    func editPost(post: Post) {
        self.post = post
    }
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var post:Post?{
        didSet{
            if(titleLabel != nil){
                updateDisplay()
            }
        }
    }
    
    func updateDisplay(){
        //Todo add user photo.
        
        titleLabel.text = post?.title
        userNameLabel.text = post?.userName
        locationLabel.text = post?.location
        difficultyLabel.text = post?.difficulty
        descriptionLabel.text = post?.description

        if let urlStr = post?.photo {
            if (!urlStr.elementsEqual("")){
                let url = URL(string: urlStr)
                postImage?.kf.setImage(with: url)
            }else{
                postImage.image = UIImage(named: "nature")
            }
            
        }
    
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        if post != nil {
            updateDisplay()
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openEditPost"){
            let dvc = segue.destination as! EditPostViewController
            dvc.post = post
            dvc.delegate = self
        }
    }


}

