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

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var fullnameTxt: UILabel!
    @IBOutlet weak var usernameTxt: UILabel!
    var isConnected = true
    var data = [Post]()
    var selectedRow = 0
    var refreshControl = UIRefreshControl()
    var flag = false
    
    var user:User?{
        didSet{
            if(fullnameTxt != nil){
                getUserDetails()
                flag = true
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
        self.spinner.hidesWhenStopped = true
        self.spinner.startAnimating()
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        if (isConnected) && (flag != true) {
            getUserDetails()
            flag = true
        }
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action:
                                        #selector(reload),
                                       for: .valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString("Loading List...")
        Model.postDataNotification.observe {
            self.reload()
        }
        reload()
        
        // Do any additional setup after loading the view.
        // Design UI:
        photo.layer.cornerRadius = photo.frame.height / 2
        photo.clipsToBounds = true
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
    
    @objc func reload(){
        if self.refreshControl.isRefreshing == false {
            self.refreshControl.beginRefreshing()
        }
        var alreadyThere = Set<Post>()
        if alreadyThere.count == 0{
            self.refreshControl.endRefreshing()
        }
        Model.instance.getAllPosts(){
            posts in
            for post in posts {
                let status = String(post.isPostDeleted!)
                let createdBy = String(post.userName!)
                
                if status.elementsEqual("false") && createdBy.elementsEqual((self.user?.email)!){
                    alreadyThere.insert(post)
                }
            }

            self.data = [Post]()
            
            for idx in alreadyThere.indices {
                let p = alreadyThere[idx]
                self.data.append(p)
            }
            self.data.sort(by: { $0.lastUpdated > $1.lastUpdated })
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
            self.spinner.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action:
                                        #selector(reload),
                                       for: .valueChanged)
        self.refreshControl.attributedTitle = NSAttributedString("Loading List...")
        
        Model.postDataNotification.observe {
            self.reload()
        }
        reload()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openEditUser"){
            let dvc = segue.destination as! EditUserViewController
            dvc.user = user
            dvc.delegate = self
        }
        else if(segue.identifier == "openPostDetails"){
            let dvc = segue.destination as! PostDetailsViewController
            let pt = data[selectedRow]
            dvc.post = pt
        }
    }
}

extension UserDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        let p = data[indexPath.row]
        cell.title = p.title!
        cell.location = p.location!
        cell.imageV = p.photo!
        
        Model.instance.getUser(byId: (p.userName)!){
            user in
            if user[0] != nil{
                cell.userName = user[0].nickName!
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Selcted row at \(indexPath.row)")
        selectedRow = indexPath.row
        performSegue(withIdentifier: "openPostDetails", sender: self)
    }
    
}
