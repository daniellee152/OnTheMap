//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Le Dat on 6/2/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import UIKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func findLocationTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showAnnotation", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showAnnotation"{
            if let locationVC = segue.destination as? LocationViewController {
                locationVC.link = self.urlTextField.text
                locationVC.location = self.locationTextField.text
            }
        }
    }
    
}
