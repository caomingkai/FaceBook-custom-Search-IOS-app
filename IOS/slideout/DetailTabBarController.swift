//
//  DetailTabBarController.swift
//  slideout
//
//  Created by Kevin on 25/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import UIKit
import EasyToast
import FacebookCore
import FacebookShare


class DetailTabBarController: UITabBarController {

    
    var favorStatus: String!
    var resultData = ResultData.sharedResultData
    var id: String!
    var name: String!
    var thumbImgURL: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        id = resultData.id
        name = resultData.name
        thumbImgURL = resultData.thumbImgURL
        print(name)
    }
    
    @IBAction func optionBtn(_ sender: UIBarButtonItem) {
        if ( checkFavorStatus() ){
            self.favorStatus = "Remove from favorites"
        }else{
            self.favorStatus = "Add to favorites"
        }
        
        let optionAlert: UIAlertController = UIAlertController(title: "menu", message: nil, preferredStyle: .actionSheet)
        let favorAction = UIAlertAction(title: self.favorStatus, style: .default) { (action: UIAlertAction) in self.favorAction() }
        let shareAction = UIAlertAction(title: "share", style: .default) { (action: UIAlertAction) in
            self.shareAction()  }
        let cancelAction = UIAlertAction(title: "cancel", style: .destructive, handler: nil)
        
        optionAlert.addAction(favorAction)
        optionAlert.addAction(shareAction)
        optionAlert.addAction(cancelAction)
        
        
        self.present(optionAlert, animated: true, completion: nil)
    }
    

    
    func favorAction(){
        let favorLib = UserDefaults.standard
        if self.favorStatus == "Add to favorites"{
            favorLib.setValue( dataPack( id: resultData.id ) , forKey: resultData.id )
            self.view.showToast("Added to Favorites!", position: .bottom, popTime: 2, dismissOnTap: false)
        }else{
            favorLib.removeObject(forKey: resultData.id )
            self.view.showToast("Removed from Favorites!", position: .bottom, popTime: 2, dismissOnTap: false)
        }
    }

    
    
    func showShareDialog<C: ContentProtocol>(_ content: C, mode: ShareDialogMode) {
        let dialog = ShareDialog(content: content)
        dialog.presentingViewController = self
        dialog.failsOnInvalidData = true
        dialog.mode = mode
        dialog.completion = { result in
            switch result {
            case .success:
                self.view.showToast("Shared!", position: .bottom, popTime: 2, dismissOnTap: false)
            case .cancelled:
                self.view.showToast("Cancelled!", position: .bottom, popTime: 2, dismissOnTap: false)
            default:
                print("~~~~~~Error In ShareDialog~~~~~~~")
            }
        }
        do {
            try dialog.show()
        } catch (let error) {
            
            let alertController = UIAlertController(title: "Invalid share content", message: "Failed to present share dialog with error \(error)",  preferredStyle: .alert)
            
            present(alertController, animated: true, completion: nil)
        }
    }
    

    
    
    func shareAction(){
        let urlStr: String = "https://www.facebook.com/\(id!)"
        let urlImgStr: String = thumbImgURL
        print("*************************")
        print(name)
        print( URL(string: urlImgStr)!)
        let content = LinkShareContent(url: URL(string: urlStr)!,
                                       title: name,
                                       description: "FB Share for CSCI571",
                                       imageURL: URL(string: urlImgStr)!)
        
       showShareDialog(content, mode: .automatic)
    }


    

    
    
    
    func dataPack( id : String ) -> [String: String]{
        
        var dataPack: [String: String] =  ["type": "" , "name": "" , "thumbImgURL": ""]
        
        dataPack["name"] = resultData.name
        dataPack["thumbImgURL"] = resultData.thumbImgURL
        
        switch resultData.type{
        case "user":
            dataPack["type"] = "user"
        case "page":
            dataPack["type"] = "page"
        case "event":
            dataPack["type"] = "event"
        case "place":
            dataPack["type"] = "place"
        case "group":
            dataPack["type"] = "group"
        default:
            print("From dataPack()-favorAction()-DetailTabBarController")
        }
        
        return dataPack
    }
    
    
    
    func checkFavorStatus() -> Bool{
        let favorLib = UserDefaults.standard
        if favorLib.object(forKey: resultData.id) != nil{
            return true
        }else{
            return false
        }
    }
    
    
    
    
}

