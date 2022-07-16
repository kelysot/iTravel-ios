//
//  UserDetailsViewController.swift
//  iTravel-ios
//
//  Created by Bar Elimelech on 10/06/2022.
//

import UIKit

class UserDetailsViewController: UIViewController, EditUserDelegate {
    func editUser(user: User) {
        self.user = user
    }

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var fullnameTxt: UILabel!
    @IBOutlet weak var usernameTxt: UILabel!
    var isConnected = true
    
    var user:User?{
        didSet{
            if(fullnameTxt != nil){
                getUserDetails()
            }
        }
    }
    
    @IBAction func logoutBtn(_ sender: UIBarButtonItem) {
        Model.instance.signOut(){
            success in
            if success {
                self.isConnected = false
                print("logged out")
                let loginVC = self.storyboard?.instantiateViewController(identifier: "login")
                loginVC?.modalPresentationStyle = .fullScreen
                self.present(loginVC!, animated: true, completion: {
                    self.navigationController?.popToRootViewController(animated: false)
                    self.tabBarController?.selectedIndex = 0
                })
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
       if isConnected {
            getUserDetails()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func getUserDetails(){
        Model.instance.checkIfUserLoggedIn(){ success in
            if success {
                Model.instance.getUserDetails{
                    user in
                    if user != nil {
                        self.user = user
                        self.fullnameTxt.text = user.fullName
                        self.usernameTxt.text = user.nickName
                        
                        if let urlStr = user.photo {
                            if (!urlStr.elementsEqual("avatar")){
                                let url = URL(string: urlStr)
                                self.photo?.kf.setImage(with: url)
                            }else{
                                self.photo.image = UIImage(named: "avatar")
                            }
                            
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openEditUser"){
            let dvc = segue.destination as! EditUserViewController
            dvc.user = user
            dvc.delegate = self
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
