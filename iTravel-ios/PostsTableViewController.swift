//
//  PostsTableViewController.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 05/06/2022.
//

import UIKit

class PostsTableViewController: UITableViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    var data = [Post]()
    
    @IBAction func signOutBtn(_ sender: UIBarButtonItem) {
        showAlert(msg: "Are you sure you want to logout?")
    }
    
    func showAlert(msg: String) {
        let alert = UIAlertController(title: "Signout", message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Close", style: .default))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { UIAlertAction in
            self.signout()
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func signout(){
        Model.instance.signOut(){
            success in
            if success {
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
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action:
                                        #selector(reload),
                                       for: .valueChanged)
        self.refreshControl?.attributedTitle = NSAttributedString("Loading List...")
        Model.postDataNotification.observe {
            self.reload()
        }
        reload()
        
        self.spinner.hidesWhenStopped = true
    }
    
    @objc func reload(){
        self.spinner.startAnimating()
        if self.refreshControl?.isRefreshing == false {
            self.refreshControl?.beginRefreshing()
        }
        var alreadyThere = Set<Post>()
        if alreadyThere.count == 0{
            self.refreshControl?.endRefreshing()
            self.spinner.stopAnimating()
        }
        Model.instance.getAllPosts(){
            posts in
            
            for post in posts {
                let status = String(post.isPostDeleted!)
                
                if status.elementsEqual("false"){
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
            self.refreshControl?.endRefreshing()
            self.spinner.stopAnimating()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshControl = UIRefreshControl()
        self.refreshControl?.addTarget(self, action:
                                        #selector(reload),
                                       for: .valueChanged)
        self.refreshControl?.attributedTitle = NSAttributedString("Loading List...")
        
        Model.postDataNotification.observe {
            self.reload()
        }
        reload()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        let p = data[indexPath.row]
        cell.title = p.title!
        cell.location = p.location!
        cell.userName = p.userName!
        cell.imageV = p.photo!
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    var selectedRow = 0
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        NSLog("Selcted row at \(indexPath.row)")
        selectedRow = indexPath.row
        performSegue(withIdentifier: "openPostDetails", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "openPostDetails"){
            let dvc = segue.destination as! PostDetailsViewController
            let pt = data[selectedRow]
            dvc.post = pt
        }
    }
    
    
}


