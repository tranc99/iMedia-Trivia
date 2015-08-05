//
//  DetailsViewController.swift
//  Hello
//
//  Created by Ten Mutunhire on 8/4/15.
//  Copyright (c) 2015 Lean Startup Space Launcher. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, APIControllerProtocol, UITableViewDataSource, UITableViewDelegate {
    
    lazy var api :  APIController = {
        return APIController(delegate: self)
    }
    
    @IBOutlet weak var albumCover: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var tracksTableView: UITableView!
    
    var album: Album?
    
    var tracks = [Track]()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel.text = self.album?.title
        albumCover.image = UIImage(data: NSData(contentsOfURL: NSURL(string: self.album!.largeImageURL)!)!)
        if self.album != nil {
            api.lookupAlbum(self.album!.collectionId)
        }
    
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), { 
            self.tracks = Track.tracksWithJSON(results)
            self.tracksTableView.reloadData()
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        })
    }

}
