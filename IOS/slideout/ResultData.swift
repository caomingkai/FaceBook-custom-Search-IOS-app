//
//  DataRequest.swift
//  slideout
//
//  Created by Kevin on 22/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import Foundation
import Alamofire




class ResultData {

    static let sharedResultData = ResultData()
    
    private init(){}
    
    var favorFlag: Bool = false
    var requestURL: String = ""
    
    var type :String = ""
    var id: String = ""
    var name: String = ""
    var thumbImgURL: String = ""
    
    var detailURL: String = ""
    
    // for Users
    var usersIdArr: [String] = [""]
    var usersNameArr: [String] = [""]
    var usersThumbImgURLArr: [String] = [""]
    var usersPrevURL: String = ""
    var usersNextURL: String = ""
    
    // for Pages
    var pagesIdArr: [String] = [""]
    var pagesNameArr: [String] = [""]
    var pagesThumbImgURLArr: [String] = [""]
    var pagesPrevURL: String = ""
    var pagesNextURL: String = ""
    
    // for Events
    var eventsIdArr: [String] = [""]
    var eventsNameArr : [String] = [""]
    var eventsThumbImgURLArr : [String] = [""]
    var eventsPrevURL: String = ""
    var eventsNextURL: String = ""
    
    // for Places
    var placesIdArr: [String] = [""]
    var placesNameArr: [String] = [""]
    var placesThumbImgURLArr: [String] = [""]
    var placesPrevURL: String = ""
    var placesNextURL: String = ""
    
    //for Groups
    var groupsIdArr: [String] = [""]
    var groupsNameArr: [String] = [""]
    var groupsThumbImgURLArr: [String] = [""]
    var groupsPrevURL: String = ""
    var groupsNextURL: String = ""
    
    //for AlbumName
    var albumsNameArr: [String] = [""]
    var albumsURLArr: [[String]] = [[""]]
    
    //for PostIcon
    var postsIcon: String = ""
    var postsMsgArr: [String] = [""]
    var postTimeArr: [String] = [""]
    
    
    
    // [1] Alamofire downloading Result Data
    func downloadSearchData(completed: @escaping () -> () ){
        
        Alamofire.request( requestURL ).responseJSON{

            response in
            
            let result = response.result
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                // get data
                self.typeHandler( dict: dict , type: "user" )
                self.typeHandler( dict: dict , type: "place" )
                self.typeHandler( dict: dict , type: "event" )
                self.typeHandler( dict: dict , type: "page" )
                self.typeHandler( dict: dict , type: "group" )
                
//                self.typePageHandler( dict: dict , type: "user" )
//                self.typePageHandler( dict: dict , type: "place" )
//                self.typePageHandler( dict: dict , type: "event" )
//                self.typePageHandler( dict: dict , type: "page" )
//                self.typePageHandler( dict: dict , type: "group" )
                
            }
            else{
                print("From 'downloadSearchData()' : no data in result")
            }
            completed()
        }
    }
    
    
    // [2] Alamofire downloading Detail Data
    func downloadDetailData(completed: @escaping () -> () ){
        
        Alamofire.request( detailURL ).responseJSON{
            response in
            
            let result = response.result
            
            if let dict = result.value as? Dictionary<String, AnyObject> {
                
                self.albumsHandler( dict: dict )
                self.postsHandler( dict: dict )
            }
            else{
                self.postsIcon = ""
                self.albumsNameArr = [""]
                self.albumsURLArr = [[""]]
                self.postsMsgArr = [""]
                self.postTimeArr = [""]
                
                print("From 'downloadDetailData()': no data in result")
            }
            completed()
        }
    }
    
    
    // MARK: typeHandler / get data for each type
    func typeHandler( dict: Dictionary<String, AnyObject> , type: String ){
        
        var idArr : [String] = [""]
        var nameArr : [String] = [""]
        var thumbImgURLArr : [String] = [""]
        
        // get data of users/ places/ groups ...
        let typeDict = dict[type] as? Dictionary<String, AnyObject>
        if let itemArr = typeDict?["data"] as?  [ Dictionary<String, AnyObject> ] {
            
            for item in itemArr{
                
                // get id
                let id = item["id"] as? String
                idArr.append( id! )
                
                // get name
                let name = item["name"] as? String
                nameArr.append(name!)
                
                // get thumbURL
                if let picObj = item["picture"] as? Dictionary<String, AnyObject>{
                    let thumbURL = picObj["data"]?["url"] as? String
                    thumbImgURLArr.append( thumbURL! )
                }
            }
            idArr.removeFirst()
            nameArr.removeFirst()
            thumbImgURLArr.removeFirst()
        }
        
        switch type{
            
            case "user":
                self.usersIdArr = idArr
                self.usersNameArr = nameArr
                self.usersThumbImgURLArr = thumbImgURLArr
            case "page":
                self.pagesIdArr = idArr
                self.pagesNameArr = nameArr
                self.pagesThumbImgURLArr = thumbImgURLArr
            case "event":
                self.eventsIdArr = idArr
                self.eventsNameArr = nameArr
                self.eventsThumbImgURLArr = thumbImgURLArr
            case "place":
                self.placesIdArr = idArr
                self.placesNameArr = nameArr
                self.placesThumbImgURLArr = thumbImgURLArr
            case "group":
                self.groupsIdArr = idArr
                self.groupsNameArr = nameArr
                self.groupsThumbImgURLArr = thumbImgURLArr
            
            default: print("-----Error from [ResultData]-[typeHandler]-[switch]---------")
            
        }
        
    }
    
    
    // MARK: typePageHandler / get paging for each type
    func typePageHandler( dict: Dictionary<String, AnyObject> ,  type: String) {
        var prevURL: String?
        var nextURL: String?
        
        let typeDict = dict[type] as? Dictionary<String, AnyObject>
        if let paging = typeDict?["paging"] as? Dictionary<String, AnyObject>{
            
            // get prevURL
            if let prevoious = paging["prevoious"] as? String {
                prevURL = prevoious
            }else{
                prevURL =  ""
            }
            //get nextURL
            if let next = paging["next"] as? String {
                nextURL = next
            }else{
                 nextURL = ""
            }
        }
        
        switch type{
        
        case "user":
            self.usersPrevURL = prevURL!
            self.usersNextURL = nextURL!
        case "page":
            self.pagesPrevURL = prevURL!
            self.pagesNextURL = nextURL!
        case "event":
            self.eventsPrevURL = prevURL!
            self.eventsNextURL = nextURL!
        case "place":
            self.placesPrevURL = prevURL!
            self.placesNextURL = nextURL!
        case "group":
            self.groupsPrevURL = prevURL!
            self.groupsNextURL = nextURL!
        default: print("-----Error from [ResultData]-[typePageHandler]-[switch]---------")
        }

    }
    
    
    
    // MARK: albumsHandler / obtain album name and pic URL
    func albumsHandler(dict: Dictionary<String, AnyObject>) {
        
        var albumsNameArr : [String] = [""]
        var albumsURLArr : [[String]] = [[""]]
        
        let frontHalf: String = "https://graph.facebook.com/v2.8/"
        let rearHalf: String = "/picture?access_token=EAAYfcoP7WDUBAO0r4tnhZBSzZAw6VzlCNyVPyR82bSssXQZBA6KWk91d5IURb3DmJKuHDAMtZAHcZAh3fR3yJGWZC1ecZCyep1rmeCGYrt5ij7gkOWnRSZAl8qsIAzt99ZBqBWlGlrlyQdOdRklxTuAAAOdxwjeJh9lcZD"
        
        if let albumsArr = dict["albums"] as? Dictionary<String, AnyObject> {
            if let albumsArrData = albumsArr["data"] as?  [Dictionary<String, AnyObject>] {
                
                for item in albumsArrData {
                    
                    // name
                    if let name = item["name"] as? String{
                        albumsNameArr.append(name)
                    }else{
                        albumsNameArr.append("")
                    }
                    
                    //pic
                    if let photos = item["photos"] as? Dictionary<String, AnyObject> {
                        var curURLArr: [String] = [""]
                        
                        if let dataArr = photos["data"] as? [Dictionary<String, AnyObject>] {
                            for item in dataArr {
                                if let middle = item["id"] as? String{
                                    curURLArr.append( frontHalf + middle + rearHalf )
                                }else{
                                    curURLArr.append("")
                                }
                            }
                        }
                        curURLArr.removeFirst()
                        albumsURLArr.append(curURLArr)
                    }else{
                        albumsURLArr.append([""])
                    }
                }
            }
        }
        albumsNameArr.removeFirst()
        albumsURLArr.removeFirst()
        self.albumsNameArr = albumsNameArr
        self.albumsURLArr = albumsURLArr
    }
    
    
    // MARK: postsHandler / obtain post Icon, message and timeL
    func postsHandler(dict: Dictionary<String, AnyObject>) {
        
        var postsMsgArr : [String] = [""]
        var postTimeArr : [String] = [""]
        
        let pic = dict["picture"] as? Dictionary<String, AnyObject>
        let picData = pic?["data"] as? Dictionary<String, AnyObject>

        self.postsIcon = (picData?["url"])! as! String
        
        if let postsArr = dict["posts"] as? Dictionary<String, AnyObject> {
            if let postsArrData = postsArr["data"] as?  [Dictionary<String, AnyObject>] {
                
                for item in postsArrData {
                    if let msg = item["message"] as? String{
                        postsMsgArr.append(msg)
                        let time = item["created_time"] as? String
                        postTimeArr.append(time!)
                    }
                }
            }
        }
        postsMsgArr.removeFirst()
        postTimeArr.removeFirst()
        self.postsMsgArr = postsMsgArr
        self.postTimeArr = postTimeArr
    }
    
        
        
}

