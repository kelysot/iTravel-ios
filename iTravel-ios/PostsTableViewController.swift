//
//  PostsTableViewController.swift
//  iTravel-ios
//
//  Created by Kely Sotsky on 05/06/2022.
//

import UIKit

class PostsTableViewController: UITableViewController {

    var data = [Post]()

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
    }
    
    @objc func reload(){
        if self.refreshControl?.isRefreshing == false {
            self.refreshControl?.beginRefreshing()
        }
        var alreadyThere = Set<Post>()

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
        // #warning Incomplete implementation, return the number of rows
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
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */


}


