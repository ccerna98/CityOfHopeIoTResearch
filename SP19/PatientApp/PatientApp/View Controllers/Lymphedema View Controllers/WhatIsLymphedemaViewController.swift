//
//  WhatIsLymphedemaViewController.swift
//  PatientApp
//
//  Created by Engineering on 4/24/20.
//  Copyright © 2020 Darien Joso. All rights reserved.
//

import UIKit

class WhatIsLymphedemaViewController: UIViewController, UIScrollViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

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
