//
//  AboutMeViewController.swift
//  slideout
//
//  Created by Kevin on 22/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {

    @IBOutlet weak var menuNabBtnAboutMe: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        if revealViewController() != nil {
            menuNabBtnAboutMe.target = revealViewController()
            menuNabBtnAboutMe.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }



}
