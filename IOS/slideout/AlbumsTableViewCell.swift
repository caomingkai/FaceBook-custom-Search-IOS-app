//
//  AlbumsTableViewCell.swift
//  slideout
//
//  Created by Kevin on 24/04/2017.
//  Copyright © 2017 Kevin Chaos. All rights reserved.
//

import UIKit

class AlbumsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var firstImg: UIImageView!
    @IBOutlet weak var secondImg: UIImageView!
    
    var isObserving = false;
    class var expandedHeight: CGFloat { get { return 425 } }
    class var defaultHeight: CGFloat  { get { return 60  } }
    
    func checkHeight() {
        firstImg.isHidden = (frame.size.height < AlbumsTableViewCell.expandedHeight)
        secondImg.isHidden = (frame.size.height < AlbumsTableViewCell.expandedHeight)
    }
    
    func watchFrameChanges() {
        if !isObserving {
            addObserver(self, forKeyPath: "frame", options: [NSKeyValueObservingOptions.new, NSKeyValueObservingOptions.initial], context: nil)
            isObserving = true;
        }
    }
    
    func ignoreFrameChanges() {
        if isObserving {
            removeObserver(self, forKeyPath: "frame")
            isObserving = false;
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "frame" {
            checkHeight()
        }
    }

}
