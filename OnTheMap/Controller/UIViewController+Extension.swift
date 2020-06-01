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
    }
    
    @IBAction func addUserLocationTapped(_ sender: UIBarButtonItem) {

    }
    
}
