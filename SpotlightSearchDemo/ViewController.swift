//
//  ViewController.swift
//  SpotlightSearchDemo
//
//  Created by Yudiz Solutions Pvt.Ltd. on 30/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var lblName:UILabel!
    
    var resName:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblName.text = "Tapped at Spotlight 👍 \n\n" + resName
    }




}

