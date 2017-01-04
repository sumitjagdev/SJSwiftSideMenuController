//
//  ViewController.swift
//  SJSwiftSideMenuController
//
//  Created by Sumit Jagdev on 01/04/2017.
//  Copyright (c) 2017 Sumit Jagdev. All rights reserved.
//

import UIKit
import SJSwiftSideMenuController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let image : UIImage = UIImage(named: "menu") as UIImage! {
            SJSwiftSideMenuController .showLeftNavigationButtonWithImage(image: image)
            SJSwiftSideMenuController .showRightNavigationButtonWithImage(image: image)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

