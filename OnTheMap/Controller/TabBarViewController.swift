//
//  TabBarViewController.swift
//  OnTheMap
//
//  Created by Le Dat on 6/3/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        MapClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        //        MapClient.getStudentLocation { (students, error) in
        //            if error != nil {
        //                print("error refresh tapped")
        //            }
        //            StudentModel.location = students
        //        }
    }
    
    @IBAction func addUserLocationTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addLocation", sender: nil)
    }
    
    
}
