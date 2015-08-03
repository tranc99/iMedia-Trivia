//
//  ViewController.swift
//  Hello
//
//  Created by Ten Mutunhire on 8/3/15.
//  Copyright (c) 2015 Lean Startup Space Launcher. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, APIControllerProtocol {
    
    let api = APIController()
    
    @IBOutlet var appsTableView: UITableView!
    
    var tableData = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        api.delegate = self
        api.searchItunesFor("Michael Jackson")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // UITableViewDataSource methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        
        
        if let rowData: NSDictionary = self.tableData[indexPath.row] as? NSDictionary,
            urlString = rowData["artworkUrl60"] as? String,
            imgURL = NSURL(string: urlString),
            formattedPrice = rowData["formattedPrice"] as? String,
            imgData = NSData(contentsOfURL: imgURL),
            trackName = rowData["trackName"] as? String {
                cell.detailTextLabel?.text = formattedPrice
                cell.imageView?.image = UIImage(data: imgData)
                cell.textLabel?.text = trackName
        }
        
        return cell
        
    }
        //cell.textLabel?.text = "Row #\(indexPath.row)"
        //cell.detailTextLabel?.text = "Subtitle #\(indexPath.row)"
    

    func didReceiveAPIResults(results: NSArray) {
        dispatch_async(dispatch_get_main_queue(), {
            self.tableData = results
            self.appsTableView!.reloadData()
        })
    }

}

