//
//  model.swift
//  Clutch
//
//  Created by Clinton Masterson on 5/3/15.
//  Copyright (c) 2015 clintApps. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class models: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var yearScroll: UIScrollView!
    @IBOutlet var tribble: UITableView!
    
    class Models {
        
        var man: String!
        var mod: String!
        var gen: String!
        var newStartYear: Int!
        var newEndYear: Int!
        var photo:[String] = []
        var fam: String!
        
    }
    
    var modelTotal:[Models] = []
    var modelSubset:[Models] = []
    
    var modelTitle = String()
    var startYear = Int()
    var endYear = Int()
    var years = [Int]()
    var yearPicked = 2015
    
    var firstYear = Int()
    var lastYear = Int()
    
    var cellClicked = 0
    
    var scrollSize = CGFloat()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //setting the top of the View to show what manufacturer was pressed
        self.title = modelTitle
        
        println(self.lastYear)
        println(self.firstYear)
        
        for var i = self.lastYear; i >= self.firstYear; i-- {
            
            self.years.append(i)
            
        }
        
        yearPull(lastYear)

            //ScrollingView is a type of ColorButtonsView that's added to "yearScroll"
            let scrollingView = self.colorButtonsView(CGSizeMake(100.0,50.0), buttonCount: self.years.count)
            self.yearScroll.contentSize = CGSizeMake(scrollingView.frame.size.width, 70)
            self.yearScroll.contentOffset = CGPointMake(self.scrollSize, 64)
            self.yearScroll.addSubview(scrollingView)
            self.yearScroll.showsHorizontalScrollIndicator = true
            self.yearScroll.indicatorStyle = .Default
            
    }

//Running the query to grab everything
    func yearPull(year: Int) {
        
        self.modelTotal = []
        self.modelSubset = []
        
        self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 200, 200))
        self.activityIndicator.backgroundColor = UIColor.whiteColor()
        self.activityIndicator.center = self.view.center
        self.activityIndicator.hidesWhenStopped = true
        self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        self.view.addSubview(self.activityIndicator)
        self.activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()

        var yearQuery = PFQuery(className:"Models")
        yearQuery.whereKey("Manufacturer", equalTo: "\(modelTitle)")
        yearQuery.whereKey("endYear", greaterThanOrEqualTo: year)
        yearQuery.whereKey("startYear", lessThanOrEqualTo: year)
        yearQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) models in that year range.")
        
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                
                        //setting up the models as Objects
                        let newModel = Models()
                        newModel.man = object["Manufacturer"] as? String
                        newModel.mod = object["Model"] as? String
                        newModel.gen = object["GenerationNumber"] as? String
                        newModel.newStartYear = object["startYear"] as? Int
                        newModel.newEndYear = object["endYear"] as? Int
                        newModel.fam = object["Family"] as? String
                
                        if object["image"] != nil {
                    
                            newModel.photo = object["image"] as! [String]
                    
                        }
                
                
                        self.modelTotal.append(newModel)
                        self.modelSubset.append(newModel)
                
                
                        self.tribble.reloadData()
                
                    }
            
                }
                
                self.activityIndicator.stopAnimating()
                UIApplication.sharedApplication().endIgnoringInteractionEvents()
        
            } else {
        
                // Log details of the failure
                println("Error: \(error) \(error!.userInfo!)")
        
            }
    
        }
    
    }

        //First there is a "colorButtonsView" that takes 2 parameters
        func colorButtonsView(buttonSize:CGSize, buttonCount:Int) -> UIView {
            //THEN "buttonView" is another view added INSIDE of colorButtonsView
            let buttonView = UIView()
            
            //add padding?
            let padding = CGSizeMake(10, 10)
            buttonView.frame.size.width = ((buttonSize.width + padding.width) * (CGFloat(buttonCount)) + (self.yearScroll.frame.size.width / 2) - (buttonSize.width / 2))
            buttonView.frame.size.height = (70)
            self.scrollSize = buttonView.frame.size.width - self.yearScroll.frame.size.width
            
            //adding the color to the background
            buttonView.backgroundColor = UIColor.orangeColor()
            buttonView.frame.origin = CGPointMake(0, 0)
            
            //add buttons to the view
            var button = UIButton()
            let buttonIncrement = buttonSize.width + padding.width
            var buttonPosition = CGPointMake(buttonView.frame.width - self.yearScroll.frame.size.width / 2 - buttonSize.width / 2, padding.height)
            
            
            //This is future button that I added myself
            var futureButton = UIButton()
            futureButton.frame.origin = CGPointMake((buttonView.frame.size.width - self.yearScroll.frame.width / 2 + buttonIncrement * 0.5), padding.height)
            futureButton.frame.size = buttonSize
            futureButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
            futureButton.setTitle("----", forState: .Normal)
            futureButton.titleLabel?.font = (UIFont(name: "Arial", size: 28))
            buttonView.addSubview(futureButton)
            
            
            //NOW You're adding in buttons ON TOP OF buttonView ON TOP OF scrollingView (which is a type of colorButtonsView)
            for year in self.years {
                button = UIButton()
                button.frame.size = buttonSize
                button.tag = year
                button.setTitle("\(year)", forState: .Normal)
                button.titleLabel?.font = (UIFont(name: "Arial", size: 28))
                button.setTitleColor(UIColor.blackColor(), forState: .Normal)
                button.frame.origin = buttonPosition
                buttonPosition.x = buttonPosition.x - buttonIncrement
                //button.backgroundColor = UIColor.blueColor()
                button.addTarget(self, action: "colorButtonPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                buttonView.addSubview(button)
                
            }
            
            return buttonView
            
        }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        println("something")
        
        var sizeUp = CATransform3DIdentity
        sizeUp = CATransform3DScale(sizeUp, 0, 0, 2)
            
    }

    //for when the user clicks a year
    func colorButtonPressed(sender: UIButton) {
        
        self.yearPicked = sender.tag
        println(yearPicked)
        
        yearPull(yearPicked)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return 1
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return modelSubset.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 200
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //setting up the table cell to populate the Model Data
        let moCell : modelCell = tableView.dequeueReusableCellWithIdentifier("someCell", forIndexPath: indexPath) as! modelCell
        
        let modelThing = Models()
        
        if modelSubset[indexPath.row].photo.count == 0 {
            
            println("got here no pic")
            
            moCell.topper.text = modelSubset[indexPath.row].mod
            moCell.topper.textColor = UIColor.whiteColor()
            moCell.middler.text = "\(modelSubset[indexPath.row].gen) Generation"
            moCell.middler.textColor = UIColor.whiteColor()
            
            if modelSubset[indexPath.row].newEndYear == 2015 {
                
                moCell.bottomer.text = "\(modelSubset[indexPath.row].newStartYear) - Current"
                
            } else {
                
                moCell.bottomer.text = "\(modelSubset[indexPath.row].newStartYear) - \(modelSubset[indexPath.row].newEndYear)"
                
            }
            
            moCell.bottomer.textColor = UIColor.whiteColor()
            
            moCell.viewer.image = nil
            
        } else {
            
            let url = NSURL(string: "\(modelSubset[indexPath.row].photo[0])")
            let data = NSData(contentsOfURL: url!)
            moCell.viewer.contentMode = UIViewContentMode.ScaleAspectFit
            moCell.viewer.image = UIImage(data: data!)
            
            moCell.topper.text = nil
            moCell.middler.text = nil
            moCell.bottomer.text = nil
         
            //self.activityIndicator.stopAnimating()
            //UIApplication.sharedApplication().endIgnoringInteractionEvents()
            
        }
        
        return moCell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
        cellClicked = indexPath.row
        
        println("Clicked cell \(cellClicked)")
        
        performSegueWithIdentifier("toDetail", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "toDetail" {
            if let destination = segue.destinationViewController as? modelDetail {
                
                destination.manufacturer = modelTitle
                destination.modelName = modelSubset[cellClicked].mod
                destination.gen = modelSubset[cellClicked].gen
                destination.genStart = modelSubset[cellClicked].newStartYear
                destination.genEnd = modelSubset[cellClicked].newEndYear
                
                if modelSubset[cellClicked].fam != nil {
                
                destination.family = modelSubset[cellClicked].fam
                
                }
                
            }
        }
    }
}