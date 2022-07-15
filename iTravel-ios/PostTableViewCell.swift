//
//  PostTableViewCell.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 05/06/2022.
//

import UIKit
import Kingfisher

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionTV: UITextView!
    @IBOutlet weak var view: UIView!
    
    var title = "" {
        didSet{
            if(titleLabel != nil){
                titleLabel.text = title
            }
        }
    }
    
    var location = "" {
        didSet{
            if(locationLabel != nil){
                locationLabel.text = location
            }
        }
    }
    
    var userName = "" {
        didSet{
            if(userNameLabel != nil){
                userNameLabel.text = userName
            }
        }
    }
    
//    var description = "" {
//        didSet{
//            if(descriptionTV != nil){
//                descriptionTV.text = description
//            }
//        }
//    }
    
    var imageV = "" {
        didSet{
            if(img != nil){
                if (!imageV.elementsEqual("")){
                    let url = URL(string: imageV)
                    img?.kf.setImage(with: url)
                }else{
                    img.image = UIImage(named: "nature")
                }
            }
        }
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.text = title
        locationLabel.text = location
        userNameLabel.text = userName
//        descriptionTV.text = description

        if (!imageV.elementsEqual("")){
            let url = URL(string: imageV)
            img?.kf.setImage(with: url)
        }else{
            img.image = UIImage(named: "nature")
        }
        
        // Design UI:
        view.layer.cornerRadius = 10;
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.2
        view.layer.shadowRadius = 4
        view.layer.shadowOffset = CGSize(width: 0, height: 2.7)
        img.layer.cornerRadius = 10;
        img.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
