//
//  ViewController.swift
//  ArtFlow
//
//  Created by Quinn Trang on 3/1/21.
//

import UIKit

class ViewController: UIViewController {
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    
    override func loadView() {
        super.loadView()
        safeArea = view.layoutMarginsGuide
        
        setupTableView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemRed

        // Do any additional setup after loading the view.
    }
    
    func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: safeArea.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }


}

