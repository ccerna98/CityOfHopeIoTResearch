//
//  WhatIsLymphedemaViewController.swift
//  PatientApp
//
//  Created by Engineering on 4/24/20.
//  Copyright © 2020 Darien Joso. All rights reserved.
//

import UIKit

class WhatIsLymphedemaViewController: UIViewController, UIScrollViewDelegate {
    
    //subview
    let headerView = Header()
    
    //private variables
    private let colorTheme = UIColor(named: "pink")!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //create the nice header with the necessary constraints
        headerView.updateHeader(text: "Lymphedema", color: hsbShadeTint(color: colorTheme, sat: 0.25), fsize: 30)
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 121).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
    }
    
    
    
    
    @IBOutlet weak var scrollView: UIScrollView!{
    didSet{
            scrollView.delegate = self
        }
    }
    

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //stop scrolling in the horizontal direction
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
