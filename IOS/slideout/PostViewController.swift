//
//  PostViewController.swift
//  slideout
//
//  Created by Kevin on 23/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import UIKit

class PostViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {
    
    @IBOutlet weak var tableView: UITableView!
    var postsIcon: String!
    var postsMsgArr: [String]!
    var postsTimeArr: [String]!
    var resultData = ResultData.sharedResultData
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension;
        tableView.estimatedRowHeight = 60.0


        postsIcon = resultData.postsIcon
        postsMsgArr = resultData.postsMsgArr
        postsTimeArr = resultData.postTimeArr
        
//        print("----------From Post Screen---------" )
//        print(postsIcon)
//        print(postsMsgArr)
//        print(postsTimeArr)
    }

    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat{
        return UITableViewAutomaticDimension;
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if( postsMsgArr.count != 0  ){
            return postsMsgArr.count
        }else{
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "postTableCell", for: indexPath) as? PostTableViewCell{
            
            if ( postsMsgArr != [""] && postsMsgArr.count != 0 ){
                let url = URL(string: postsIcon)
                let data = try? Data(contentsOf: url!)
                cell.thumbImg.image = UIImage(data: data!)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss+zzzz"
                let date = dateFormatter.date(from: postsTimeArr[indexPath.row])
                
                dateFormatter.dateFormat = "dd MMM yyyy HH:mm:ss"
                cell.timeLabel.text = "\(dateFormatter.string(from: date!))"
                cell.msgLabel.text = postsMsgArr[indexPath.row]
            }else{
                cell.timeLabel.text = "        No Data Obtained"
            }
            
        return cell
            
        }else{
            return PostTableViewCell()
        }
    }
    
    
    
    
    
}
