//
//  GoalsViewController.swift
//  PatientApp
//
//  Created by Darien Joso on 3/5/19.
//  Copyright © 2019 Darien Joso. All rights reserved.
//

import UIKit

class GoalsViewController: UIViewController {

    let colorTheme = UIColor(named: "yellow")!
    
    // Subviews
    let headerView = Header()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarItem.selectedImage = UIImage(named: "goals")!
        self.tabBarItem.title = "Goals"
        
        setupViews()
        setupConstraints()
    }
    
    private func setupViews() {
        headerView.updateHeader(text: "Goals", color: colorTheme, fsize: 30)
        
        self.view.addSubview(headerView)
    }
    
    private func setupConstraints() {
        setupHeaderConstraints()
    }
    
    private func setupHeaderConstraints() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
    }
}