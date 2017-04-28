//
//  FavorTabBarController.swift
//  slideout
//
//  Created by Kevin on 25/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//
//
//  FavorTabBarController.swift
//  slideout
//
//  Created by Kevin on 22/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import UIKit

class FavorTabBarController:  UITabBarController{
    

    @IBOutlet weak var menuNavBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            menuNavBtn.target = revealViewController()
            menuNavBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }
    
    
    
    
    
}
