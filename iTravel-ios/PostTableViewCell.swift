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

        if (!imageV.elementsEqual("")){
            let url = URL(string: imageV)
            img?.kf.setImage(with: url)
        }else{
            img.image = UIImage(named: "nature")
        }
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
