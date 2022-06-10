//
//  UserDetailsViewController.swift
//  iTravel-ios
//
//  Created by Bar Elimelech on 10/06/2022.
//

import UIKit

class UserDetailsViewController: UIViewController {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var fullnameTxt: UILabel!
    @IBOutlet weak var usernameTxt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserDetails()
        // Do any additional setup after loading the view.
    }
    
    func getUserDetails(){
        Model.instance.getUserDetails{
            user in
            self.fullnameTxt.text = user.fullName
            self.usernameTxt.text = user.nickName
            if let urlStr = user.photo{
                let url = URL(string: urlStr)
                self.photo.kf.setImage(with: url)
            }
            print("TAG USER Details          ::::: \(user.fullName)")

        }
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
