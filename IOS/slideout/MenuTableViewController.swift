//
//  MenuTableViewController.swift
//  slideout
//
//  Created by Kevin on 25/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    
    var resultData = ResultData.sharedResultData
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // set flag indicating should show Favor screen(true), or not(false)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1{
            resultData.favorFlag = true;
        }else{
            resultData.favorFlag = false;
        }
        
        print(resultData.favorFlag)
    }
   
}
