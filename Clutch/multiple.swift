//
//  multiple.swift
//  Clutch
//
//  Created by Clinton Masterson on 6/2/15.
//  Copyright (c) 2015 clintApps. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class multiple: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var trabble: UITableView!
    
    class Models {
        
        var id: String!
        var man: String!
        var mod: String!
        var gen: String!
        var startYear: Int!
        var endYear: Int!
        var photo: PFFile?
        var prevFam = []
        var nextFam = []
        var genFam: String!
        var simModels = []
        
    }
    
    let genGuide = [
        
        1: "1st",
        2: "2nd",
        3: "3rd",
        4: "4th",
        5: "5th",
        6: "6th",
        7: "7th",
        8: "8th",
        9: "9th",
        10: "10th",
        11: "11th",
        12: "12th",
        13: "13th",
        14: "14th",
        15: "15th",
        16: "16th",
        17: "17th",
        18: "18th",
        19: "19th",
        20: "20th"
    
    ]
    
    var family = []
    var lastnext = String()
    var modelsToGo:[Models] = []
    
    var cellClicked = 100
    
    override func viewDidLoad() {
        
        println(lastnext)
        println("fam is \(family)")
        self.title = ""
        
        var yearQuery = PFQuery(className:"Models")
        yearQuery.whereKey("objectId", containedIn: family as [AnyObject])
        yearQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) models in that family")
                
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        //setting up the models as Objects
                        let newModel = Models()
                        newModel.id = object.objectId as String!
                        newModel.man = object["Manufacturer"] as! String
                        newModel.mod = object["Model"] as! String
                        newModel.gen = object["GenerationNumber"] as! String
                        newModel.startYear = object["startYear"] as! Int
                        newModel.endYear = object["endYear"] as! Int
                        
                        if object["Family"] != nil {
                            
                            newModel.genFam = object["Family"] as! String
                            
                        }
                        
                        if object["image"] != nil {
                            
                            newModel.photo = object["image"] as? PFFile
                            
                        }
                        
                        
                        self.modelsToGo.append(newModel)
        
                        self.trabble.reloadData()
    
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return modelsToGo.count
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //setting up the table cell to populate the Model Data
        let multCell : multipleCell = tableView.dequeueReusableCellWithIdentifier("multCell", forIndexPath: indexPath) as! multipleCell
        
        let modelThing = Models()
        
        if modelsToGo[indexPath.row].photo != nil {
        
            modelsToGo[indexPath.row].photo!.getDataInBackgroundWithBlock{
                (imageData: NSData?, error: NSError?) -> Void in
            
                if error == nil {
                    let modelImage = UIImage(data: imageData!)
                    multCell.multCellPic.image = modelImage
                }
            
            }
            
        }
        
        multCell.multCellLabel.text = "\(modelsToGo[indexPath.row].startYear) \(modelsToGo[indexPath.row].man) \(modelsToGo[indexPath.row].mod)"
        
        return multCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        cellClicked = indexPath.row
        
        println("Clicked cell \(cellClicked)")
        
        performSegueWithIdentifier("multipleChosen", sender: self)
        
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "multipleChosen" {
            if let destination = segue.destinationViewController as? modelDetail {
                
                destination.manufacturer = modelsToGo[cellClicked].man
                destination.modelName = modelsToGo[cellClicked].mod
                destination.gen = modelsToGo[cellClicked].gen
                destination.genStart = modelsToGo[cellClicked].startYear
                destination.genEnd = modelsToGo[cellClicked].endYear
                destination.objIdInput = modelsToGo[cellClicked].id
                
            }
            
        }
        
    }

}
