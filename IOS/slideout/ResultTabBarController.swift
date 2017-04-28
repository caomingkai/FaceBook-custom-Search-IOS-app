//
//  ResultTabBarController.swift
//  slideout
//
//  Created by Kevin on 21/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import UIKit

class ResultTabBarController: UITabBarController {

    @IBOutlet weak var menuNavBtnResultTab: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil {
            menuNavBtnResultTab.target = revealViewController()
            menuNavBtnResultTab.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }

    }


}
