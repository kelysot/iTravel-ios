//
//  SignupViewController.swift
//  iTravel-ios
//
//  Created by Bar Elimelech on 08/06/2022.
//

import UIKit

class SignupViewController: UIViewController {
    
    var isExist = false

    @IBAction func fullname(_ sender: UITextField) {
    }
    @IBAction func username(_ sender: UITextField) {
    }
    @IBAction func email(_ sender: UITextField) {
    }
    @IBAction func password(_ sender: UITextField) {
    }
    @IBAction func verifyPassword(_ sender: UITextField) {
    }
    @IBAction func cancelBtn(_ sender: UIButton) {
        performSegue(withIdentifier: "backToLogin", sender: self)

    }
    @IBAction func signupBtn(_ sender: UIButton) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
