//
//  ViewController.swift
//  Hello
//
//  Created by Ten Mutunhire on 8/3/15.
//  Copyright (c) 2015 Lean Startup Space Launcher. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var appsTableView: UITableView!
    
    var tableData = []
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        searchItunesFor("Michael Jackson")
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
    

    
    
    
    func searchItunesFor(searchTerm: String) {
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        let itunesSearchTerm = searchTerm.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.CaseInsensitiveSearch, range: nil)
        
        // Now escape anything else that isn't URL-friendly
        if let escapedSearchTerm = itunesSearchTerm.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            let urlPath = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
            let url = NSURL(string: urlPath)
            let session = NSURLSession.sharedSession()
            let task = session.dataTaskWithURL(url!, completionHandler: {data, response, error -> Void in
                println("Task completed")
                if(error != nil) {
                    // If there is an error in the web request, print it to the console
                    println(error.localizedDescription)
                }
                var err: NSError?
                if let jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                    if(err != nil) {
                        // If there is an error parsing JSON, print it to the console
                        println("JSON Error \(err!.localizedDescription)")
                    }
                    if let results: NSArray = jsonResult["results"] as? NSArray {
                        dispatch_async(dispatch_get_main_queue(), {
                            self.tableData = results
                            self.appsTableView!.reloadData()
                        })
                    }
                }
            })
            
            // The task is just an object with all these properties set
            // In order to actually make the web request, we need to "resume"
            task.resume()
        }
    }


}

