//
//  Slide.swift
//  PatientApp
//
//  Created by Engineering on 4/17/20.
//  Copyright © 2020 Darien Joso. All rights reserved.
//

import UIKit
import WebKit

class Slide: UIView {
    //connects objects from slide.xib to this code
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelDesc: UILabel!

}
