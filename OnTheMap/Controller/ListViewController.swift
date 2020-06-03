//
//  ListViewController.swift
//  OnTheMap
//
//  Created by Le Dat on 5/28/20.
//  Copyright © 2020 Le Dat. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getStudentLocation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getStudentLocation()
    }
    
    func getStudentLocation(){
        MapClient.getStudentLocation { (students, error) in
            StudentModel.location = students.filter{$0.mediaURL.contains("http")}
            self.tableView.reloadData()
        }
    }
}

extension ListViewController : UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.location.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentInfo")!
        
        let student = StudentModel.location[indexPath.row]
        
        cell.textLabel?.text = "\(student.firstName) \(student.lastName)"
        cell.detailTextLabel?.text = student.mediaURL
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = StudentModel.location[indexPath.row]
        let url = URL(string: student.mediaURL)!
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
}
