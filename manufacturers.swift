//
//  manufacturers.swift
//  Clutch
//
//  Created by Clinton Masterson on 4/10/15.
//  Copyright (c) 2015 clintApps. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class manufacturers: UITableViewController {
    
    var manuList = [String]()
    var logoList = [PFFile]()
    var manuFirstYear = [Int]()
    var manuLastYear = [Int]()
    
    var firstToPass = Int()
    var lastToPass = Int()
    
    //Is this old code?
    //var manuCell = manufacturerCell()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "Clutch" 
        
        //Pulling down Manufacturer names & images from Parse
        var manuQuery = PFQuery(className:"Manufacturers")
        manuQuery.orderByAscending("name")
        manuQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) Manufacturers.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for thing in objects {
                        
                        self.manuList.append(thing["name"] as! String)
                        self.logoList.append(thing["logo"] as! PFFile)
                        self.manuFirstYear.append(thing["startYear"] as! Int)
                        self.manuLastYear.append(thing["endYear"] as! Int)
                        
                        self.tableView.reloadData()

                    }
                }
            
            } else {
            
                    // Log details of the failure
                    println("Error: \(error) \(error!.userInfo!)")
            
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return manuList.count
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 110
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "models" {
            if let destination = segue.destinationViewController as? models {
                
                if let manuSelected = tableView.indexPathForSelectedRow()?.row {
                    destination.modelTitle = manuList[manuSelected]
                    destination.firstYear = firstToPass
                    destination.lastYear = lastToPass
                    
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Create a variable that you want to send based on the destination view controller
        // You can get a reference to the data by using indexPath shown below
        
        let manuName:String = manuList[indexPath.row]
            
        println(manuList[indexPath.row])
        
        firstToPass = manuFirstYear[indexPath.row]
        lastToPass = manuLastYear[indexPath.row]
        
        performSegueWithIdentifier("models", sender: self)
        
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //setting up the table cell to populate for Manufacturers
        var manuCell:manufacturerCell = self.tableView.dequeueReusableCellWithIdentifier("manuCell") as! manufacturerCell
        
        manuCell.manufacturer.text = manuList[indexPath.row]
        
        logoList[indexPath.row].getDataInBackgroundWithBlock{
            (imageData: NSData?, error: NSError?) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                
                manuCell.logo.image = image
                
            }

        }

        return manuCell
        
    }
}