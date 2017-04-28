//
//  ResultAndFavorViewController.swift
//  slideout
//
//  Created by Kevin on 23/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import UIKit
import SwiftSpinner


class ResultAndFavorViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarDelegate {
    
    // 0:0  1: 10  2:20
    var dataBlock :intptr_t = 0
    var typeIndex :intptr_t = 0
    var type = ["user", "page", "event", "place", "group" ]
    
    var IdArr = [String](repeating: "", count: 10)
    var NameArr = [String](repeating: "", count: 10)
    var ThumbImgURL = [String](repeating: "", count: 10)
    var resultData = ResultData.sharedResultData
    
    @IBOutlet weak var menuNavBtn: UIBarButtonItem!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func prev(_ sender: UIButton) {
        if( dataBlock > 0){
            dataBlock -= 10
            loadPreNextData(dataBlock: dataBlock)
            tableView.reloadData()
        }
    }
    
    @IBAction func next(_ sender: UIButton) {
        if( dataBlock < 20){
            dataBlock += 10
            loadPreNextData(dataBlock: dataBlock)
            tableView.reloadData()
        }
    }
    
    
    override func viewDidLoad() {
        SwiftSpinner.show("fetching data...")
        super.viewDidLoad()
        
        if revealViewController() != nil {
            menuNavBtn.target = revealViewController()
            menuNavBtn.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tabBar.delegate = self
        
        if resultData.usersIdArr != [""]{
            loadPreNextData(dataBlock: dataBlock)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            SwiftSpinner.show("fetching data...")
            loadPreNextData(dataBlock: dataBlock)
            tableView.reloadData() //for all items in favor mode
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        SwiftSpinner.hide()
    }
    
    
    
    func viewDidLayoutSubviews() {
        <#code#>
    }
    // Mark: Tab bar delegate
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        typeIndex = (tabBar.items?.index(of: item))!
        loadPreNextData(dataBlock: dataBlock)
        tableView.reloadData() //for all items in favor mode
    }

    
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as? ResultAndFavorCellTableViewCell{
            
            if IdArr[indexPath.row] != "" {
                if let url = URL(string: ThumbImgURL[indexPath.row] ){
                    let data = try? Data(contentsOf: url)
                    cell.thumbImg.image = UIImage(data: data!)
                }else{
                    cell.thumbImg.image = UIImage()
                }
                
                if UserDefaults.standard.object(forKey: IdArr[indexPath.row]) == nil{
                    cell.favorImg.image = UIImage(named: "emptyStar" )
                }else{
                    cell.favorImg.image = UIImage(named: "fullStar" )
                }
 
                cell.nameLabel.text = NameArr[indexPath.row]
                cell.accessoryType = .detailDisclosureButton
            }else{
                cell.thumbImg.image = UIImage()
                cell.nameLabel.text = ""
                cell.favorImg.image = UIImage()
                cell.accessoryType = .none
            }
            return cell
        }else{
            return ResultAndFavorCellTableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if IdArr[indexPath.row] != "" {
            SwiftSpinner.show("fetching data...")  //waiting screen
            resultData.id  = IdArr[indexPath.row]
            resultData.name = NameArr[indexPath.row]
            resultData.thumbImgURL = ThumbImgURL[indexPath.row]
            resultData.type = type[typeIndex]
            resultData.detailURL = "http://mingkaicao-env.us-west-1.elasticbeanstalk.com/result.php?detailId=\(resultData.id)"
            
            
            resultData.downloadDetailData() {
                
                print(self.resultData.albumsNameArr)
                print(self.resultData.albumsURLArr)
                print("------------------")
                SwiftSpinner.hide()
                self.performSegue(withIdentifier: "detailSegue", sender:AnyObject.self)
            }
        }
    }
    
    
    // load data for current page/ prev page/ next page
    func loadPreNextData(dataBlock: intptr_t){
        
        if( resultData.favorFlag == true){
            loadFavorData()
        }else{
            loadResultData()
        }
        
    }
    
    
    
    // load Result Data from search
    func loadResultData(){
        switch type[typeIndex] {
        case "user":
            loadResultTypeData(resultIdArr: resultData.usersIdArr, resultNameArr: resultData.usersNameArr, resultThumbImgURLArr: resultData.usersThumbImgURLArr)
        case "page":
            loadResultTypeData(resultIdArr: resultData.pagesIdArr, resultNameArr: resultData.pagesNameArr, resultThumbImgURLArr: resultData.pagesThumbImgURLArr)
        case "event":
            loadResultTypeData(resultIdArr: resultData.eventsIdArr, resultNameArr: resultData.eventsNameArr, resultThumbImgURLArr: resultData.eventsThumbImgURLArr)
        case "place":
            loadResultTypeData(resultIdArr: resultData.placesIdArr, resultNameArr: resultData.placesNameArr, resultThumbImgURLArr: resultData.placesThumbImgURLArr)
        case "group":
            loadResultTypeData(resultIdArr: resultData.groupsIdArr, resultNameArr: resultData.groupsNameArr, resultThumbImgURLArr: resultData.groupsThumbImgURLArr)
        default:
            print("loadResultData() - ResultAndFavorViewController")
        }
        
    }
    
    
    func loadResultTypeData( resultIdArr: [String] ,  resultNameArr: [String],  resultThumbImgURLArr: [String]){
        for i in 0..<10{
            if( i+dataBlock < IdArr.count ){
                
                IdArr[i] = resultIdArr[i+dataBlock]
                NameArr[i] = resultNameArr[i+dataBlock]
                ThumbImgURL[i] = resultThumbImgURLArr[i+dataBlock]
            }else{
                IdArr[i] = ""
                NameArr[i] = ""
                ThumbImgURL[i] = ""
            }
        }
    }
    
    
    // load favor data from Userdefault
    func loadFavorData(){
        
        var favorIdArr: [String] = [""]
        var favorNameArr: [String] = [""]
        var favorThumbImgURL: [String] = [""]
        
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            if let entry = value as? [String: String]{
                if let entryType = entry["type"]{
                    if entryType == type[typeIndex]{
                        favorIdArr.append(key)
                        favorNameArr.append( entry["name"]! )
                        favorThumbImgURL.append( entry["thumbImgURL"]! )
                    }
                }
            }
        }
        favorIdArr.removeFirst()
        favorNameArr.removeFirst()
        favorThumbImgURL.removeFirst()
        
        for i in 0..<10{
            if( i+dataBlock < favorIdArr.count ){
                print(i)
                print(dataBlock)
                print(i+dataBlock)
                IdArr[i] = favorIdArr[i+dataBlock]
                NameArr[i] = favorNameArr[i+dataBlock]
                ThumbImgURL[i] = favorThumbImgURL[i+dataBlock]
            }else{
                IdArr[i] = ""
                NameArr[i] = ""
                ThumbImgURL[i] = ""
            }
        }
        
    }
    
    
    


}
