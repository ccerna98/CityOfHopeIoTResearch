//
//  BISInstructionsViewController.swift
//  PatientApp
//
//  Created by Engineering on 4/30/20.
//  Copyright © 2020 Darien Joso. All rights reserved.
//

import UIKit

class BISInstructionsViewController: UIViewController, UIScrollViewDelegate {
    
    //subview
    let headerView = Header()
    
    //private variables
    private let colorTheme = UIColor(named: "yellow")!
    
    @IBOutlet weak var scrollView: UIScrollView!{
    didSet{
            scrollView.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //make and constrain the pretty header
        headerView.updateHeader(text: "BIS Device Instructions", color: hsbShadeTint(color: colorTheme, sat: 0.25), fsize: 30)
        self.view.addSubview(headerView)
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        headerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        headerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 100.0).isActive = true
        
        //constrain the scroll view. these have high priority than the priority set in the storyboard
        scrollView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 10).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
         scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        
        
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    //stop scrolling in the horizontal direction
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
 
    

    

}
