//
//  AlbumsViewController.swift
//  slideout
//
//  Created by Kevin on 24/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import UIKit

class AlbumsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var albumsNameArr: [String]!
    var albumsURLArr: [[String]]!
    var resultData = ResultData.sharedResultData
    var selectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        albumsNameArr = resultData.albumsNameArr
        albumsURLArr = resultData.albumsURLArr
        
    }


    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if( albumsNameArr.count != 0 ){
            return albumsNameArr.count
        }else{
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "albumTableCell", for: indexPath) as! AlbumsTableViewCell
        if(albumsNameArr == [""] || albumsNameArr.count == 0 ){
            cell.nameLabel.text = "No Data Obtained"
        }else{
            cell.nameLabel.text = albumsNameArr[indexPath.row]
            
            if( albumsURLArr[indexPath.row].count == 1 ){
                if let url = URL(string: albumsURLArr[indexPath.row][0] ){
                    let data = try? Data(contentsOf: url)
                    cell.firstImg.image = UIImage(data: data!)
                    cell.secondImg.image = UIImage()
                }else{
                    cell.firstImg.image = UIImage()
                    cell.secondImg.image = UIImage()
                }
            }else if( albumsURLArr[indexPath.row].count == 2 ){
                var url = URL(string: albumsURLArr[indexPath.row][0] )
                var data = try? Data(contentsOf: url!)
                cell.firstImg.image = UIImage(data: data!)

                url = URL(string: albumsURLArr[indexPath.row][1] )
                data = try? Data(contentsOf: url!)
                cell.secondImg.image = UIImage(data: data!)
            }
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedIndexPath
        if indexPath == selectedIndexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        var indexPaths : Array<IndexPath> = []
        if let previous = previousIndexPath {
            indexPaths += [previous]
        }
        if let current = selectedIndexPath {
            indexPaths += [current]
        }
        if indexPaths.count > 0 {
            tableView.reloadRows(at: indexPaths, with: UITableViewRowAnimation.automatic)
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumsTableViewCell).watchFrameChanges()
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        (cell as! AlbumsTableViewCell).ignoreFrameChanges()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        for cell in tableView.visibleCells as! [AlbumsTableViewCell] {
            cell.ignoreFrameChanges()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == selectedIndexPath {
            return AlbumsTableViewCell.expandedHeight
        } else {
            return AlbumsTableViewCell.defaultHeight
        }
    }


}
