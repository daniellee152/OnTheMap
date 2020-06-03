//
//  UIViewController+Extension.swift
//  OnTheMap
//
//  Created by Le Dat on 5/28/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import UIKit

extension UIViewController{
    @IBAction func logoutTapped(_ sender: UIBarButtonItem) {
        MapClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func refreshTapped(_ sender: UIBarButtonItem) {
        MapClient.getStudentLocation { (students, error) in
            if error != nil {
                self.alert(ofTitle: "Error Freshing Data", message: error?.localizedDescription ?? "")
            }
            StudentModel.location = students
        }
        print("refresh tapped")
    }
    
    @IBAction func addUserLocationTapped(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addLocation", sender: nil)
    }
    
    func alert(ofTitle: String, message : String){
        let alertVC = UIAlertController(title: ofTitle, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertVC.addAction(action)
        present(alertVC, animated: true)
    }

    
}
