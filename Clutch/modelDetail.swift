//
//  modelDetail.swift
//  Clutch
//
//  Created by Clinton Masterson on 5/6/15.
//  Copyright (c) 2015 clintApps. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class modelDetail: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var similarScroll: UIScrollView!
    
    @IBOutlet var genPic: UIImageView!
    
    @IBOutlet var genTop: UILabel!

    @IBOutlet var genBottom: UILabel!
    
    @IBAction func wikiLink(sender: AnyObject) {
        
        let webV:UIWebView = UIWebView(frame: CGRectMake(0, 70, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
        webV.loadRequest(NSURLRequest(URL: NSURL(string: "https://en.wikipedia.org/wiki/Audi_A4")!))
        webV.delegate = self
        webV.tag = 2
        self.view.addSubview(webV)
        
        let button = UIButton()
        button.frame = CGRectMake(self.view.frame.width - 40, 80, 30, 30)
        //button.backgroundColor = UIColor.greenColor()
        //button.setTitle("Test Button", forState: UIControlState.Normal)
        button.tag = 3
        button.setImage(UIImage(named: "x.gif"), forState: UIControlState())
        button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.view.addSubview(button)
        
    }
    
    //for when the user clicks the x to remove the view
    func buttonAction(sender: UIButton) {
        
        for subview in view.subviews {
            if (subview.tag == 2 || subview.tag == 3) {
                subview.removeFromSuperview()
            }
        }
        
    }

    
    @IBAction func feedback(sender: AnyObject) {
        
        let email = "feedback@clutch.io"
        let url = NSURL(string: "mailto:\(email)")
        UIApplication.sharedApplication().openURL(url!)
        
    }
    
    class Models {
        
        var id: String!
        var man: String!
        var mod: String!
        var gen: String!
        var startYear: Int!
        var endYear: Int!
        var photo = []
        var prevFam = []
        var nextFam = []
        var genFam: String!
        var simModels = []
        var wikiurl: String!
        
    }
    
    class subModels {
        
        var objectID: String!
        var parentID: String!
        var subType: String!
        var man: String!
        var model: String!
        var trim: String!
        var gen: String!
        var startYear: Int!
        var endYear: Int!
        var family: String!
        
    }
    
    let genGuide = ["1st", "2nd", "3rd", "4th", "5th", "6th", "7th", "8th", "9th", "10th", "11th", "12th", "13th", "14th", "15th", "16th", "17th", "18th", "19th", "20th"]
    
    var specificModels:[Models] = []
    var chosenModel:[Models] = []
    var similarModel:[Models] = []
    
    var manufacturer = String()
    var modelName = String()
    var gen = String()
    var genStart = Int()
    var genEnd = Int()
    var family = String()
    
    var similarMod = []
    var similarModPic = []
    
    var swipedirection = String()
    
    var scrollSize = CGFloat()
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println(family)
        
        //setting up the swipe block
        var leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        var rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        
        leftSwipe.direction = .Left
        rightSwipe.direction = .Right
        
        view.addGestureRecognizer(leftSwipe)
        view.addGestureRecognizer(rightSwipe)
        
        self.title = "\(manufacturer) \(modelName)"
        genTop.text = "\(gen) Generation"
        genBottom.text = "Produced from \(genStart) to \(genEnd)"
        
        println("Chose \(gen) Gen \(manufacturer) \(modelName)")
        
        var yearQuery = PFQuery(className:"Models")
        
        if family != "" {
        
        yearQuery.whereKey("Family", equalTo: "\(family)")
            
        } else {
            
        yearQuery.whereKey("Manufacturer", equalTo: "\(manufacturer)")
        yearQuery.whereKey("Model", equalTo: "\(modelName)")
            
        }
    
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
                        newModel.man = object["Manufacturer"] as! String
                        newModel.mod = object["Model"] as! String
                        newModel.gen = object["GenerationNumber"] as! String
                        newModel.startYear = object["startYear"] as! Int
                        newModel.endYear = object["endYear"] as! Int
                        
                        if object["previousFamily"] != nil {
                            
                            newModel.prevFam = object["previousFamily"] as! NSArray
                            
                        }
                        
                        if object["nextFamily"] != nil {
                            
                            newModel.nextFam = object["nextFamily"] as! NSArray
                            
                        }
                        
                        if object["Family"] != nil {
                            
                            newModel.genFam = object["Family"] as! String
                            
                        }
                        
                        if object["similarModels"] != nil {
                            
                            newModel.simModels = object["similarModels"] as! NSArray
                            
                        }
                        
                        if object["image"] != nil {
                            
                            newModel.photo = object["image"] as! NSArray
                            
                        }
                        
                        
                        self.specificModels.append(newModel)
                        
                    }
                    
                }
            
                self.updateGenInfo(self.gen)
                
            }
        
        }
    
        //Trying to do the "similar models" piece here... trims be damned.
        
        var similarQuery = PFQuery(className:"Models")
        similarQuery.whereKey("objectId", containedIn: similarMod as [AnyObject])
        similarQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            if error == nil {
                
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) similar models")
                
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        
                        if object["image"] != nil {
                            
                            //self.similarModPic.append(object["image"] as! [String])
    
                        }

                        self.reloadInputViews()
                    
                    }
                        
                }
                
            }
            
        }
        
    }

    //This whole thing links up to the scroller
    /*func similarModView(buttonSize:CGSize, buttonCount:Int) -> UIView {
        //creates color buttons in a UIView
        let buttonView = UIView()
        
        //add padding?
        let padding = CGSizeMake(0, 10)
        buttonView.frame.size.width = ((buttonSize.width + padding.width) * (CGFloat(buttonCount)))
        buttonView.frame.size.height = similarScroll.frame.size.height
        
        //adding the color to the background
        buttonView.backgroundColor = UIColor.blackColor()
        buttonView.frame.origin = CGPointMake(0, -64)
        
        //add buttons to the view
        var imageViewer = UIImageView()
        let imageIncrement = buttonSize.width + padding.width
        var buttonPosition = CGPointMake(0, 0)
        
        //add a loop
        for car in self.years {
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

    
    let scrollingView = similarModView(CGSizeMake(100.0,50.0), self.years.count)
    self.similarModView.contentSize = CGSizeMake(scrollingView.frame.size.width, 0)
    self.similarModView.contentOffset = CGPointMake(self.scrollSize, -64)
    self.similarModView.addSubview(scrollingView)
    self.similarModView.showsHorizontalScrollIndicator = true
    self.similarModView.indicatorStyle = .Default*/
    

//This is how the app changes cars when a swipe is done.
        func updateGenInfo(newGent: String) {
    
        for model in specificModels {
        
            if newGent == model.gen {
                
                for subview in view.subviews {
                    if (subview.tag == 10 || subview.tag == 11) {
                        subview.removeFromSuperview()
                    }
                }
                
                self.chosenModel = []
                
                self.chosenModel.append(model)
                
                if self.chosenModel[0].prevFam.count >= 1 {
                    
                    println("got left")
                    let leftButton = UIButton()
                    leftButton.frame = CGRectMake(self.view.frame.width - (self.view.frame.width - 30), 300, 30, 30)
                    //leftButton.backgroundColor = UIColor.whiteColor()
                    leftButton.tag = 10
                    leftButton.setImage(UIImage(named: "leftarrowwhite.png"), forState: UIControlState())
                    leftButton.addTarget(self, action: "arrowPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                    self.view.addSubview(leftButton)
                    
                }
                
                if self.chosenModel[0].nextFam.count >= 1 {
                    
                    println("got right")
                    let rightButton = UIButton()
                    rightButton.frame = CGRectMake(self.view.frame.width - 60, 300, 30, 30)
                    //rightButton.backgroundColor = UIColor.whiteColor()
                    rightButton.tag = 11
                    rightButton.setImage(UIImage(named: "rightarrowwhite.png"), forState: UIControlState())
                    rightButton.addTarget(self, action: "arrowPressed:", forControlEvents: UIControlEvents.TouchUpInside)
                    self.view.addSubview(rightButton)
                    
                }
                
                self.genStart = chosenModel[0].startYear
                self.genEnd = chosenModel[0].endYear
            
                self.title = "\(chosenModel[0].man) \(chosenModel[0].mod)"
                self.genTop.text = "\(newGent) Generation"
                self.genBottom.text = "Produced from \(genStart) to \(genEnd)"
            
                if chosenModel[0].photo.count == 0 {
                    
                    println("There are \(chosenModel[0].photo.count) images in Chosen Model Array")
                    self.genPic.image = UIImage(named: "carholder.png")
                    
                } else {
                    
                    self.activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 200, 200))
                    self.activityIndicator.backgroundColor = UIColor.whiteColor()
                    self.activityIndicator.center = self.view.center
                    self.activityIndicator.hidesWhenStopped = true
                    self.activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
                    self.view.addSubview(self.activityIndicator)
                    self.activityIndicator.startAnimating()
                    UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                    
                    let url = NSURL(string: "\(chosenModel[0].photo[0])")
                    let data = NSData(contentsOfURL: url!)
                    self.genPic.contentMode = UIViewContentMode.ScaleAspectFit
                    self.genPic.image = UIImage(data: data!)
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                }
            
            view.reloadInputViews()
                
            }
        
        }
        
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
            if (sender.direction == .Left) {
                println("Swipe Left")
                
                let i = find(genGuide, "\(chosenModel[0].gen)")
                var newOne = i! + 1
                
                if newOne < specificModels.count {
                
                println(genGuide[newOne])
                    
                var newGen = genGuide[newOne]
                    
                updateGenInfo(newGen)
                
                } else {
                    
                    if chosenModel[0].nextFam.count > 1 {
                        
                        swipedirection = "Left"
                        
                        performSegueWithIdentifier("multiple", sender: self)
                        
                    } else {
                        
                        println("reached end")
                        
                        let anim = CAKeyframeAnimation( keyPath:"transform" )
                        anim.values = [
                            NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
                            NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
                        ]
                        anim.autoreverses = true
                        anim.repeatCount = 2
                        anim.duration = 7/100
                        
                        self.view.layer.addAnimation( anim, forKey:nil )
                        
                    }
                    
                }
                
            }
            
            if (sender.direction == .Right) {
                println("Swipe Right")
                
                let i = find(genGuide, "\(chosenModel[0].gen)")
                var newOne = i! - 1
                
                println("now \(chosenModel[0].gen) gen")
                
                if newOne >= 0 {
                
                println(genGuide[newOne])
                    
                var newGen = genGuide[newOne]
                    
                updateGenInfo(newGen)
                
                } else {
                    
                    if chosenModel[0].prevFam.count > 1 {
                        
                        swipedirection = "Right"
                        
                        performSegueWithIdentifier("multiple", sender: self)
                        
                    } else if chosenModel[0].prevFam.count == 1 {
                     
                        println(chosenModel[0].prevFam)
                        
                    } else {
                    
                        println("can't go lower than first!")
                        
                        let anim = CAKeyframeAnimation( keyPath:"transform" )
                        anim.values = [
                            NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
                            NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
                        ]
                        anim.autoreverses = true
                        anim.repeatCount = 2
                        anim.duration = 7/100
                        
                        self.view.layer.addAnimation( anim, forKey:nil )
                        
                    }
                    
                }
       
        }
    
    }
    
    func arrowPressed(sender: UIButton) {
        
        performSegueWithIdentifier("multiple", sender: self)
        
    }
    
    func colorButtonPressed(sender: UIButton) {
        
        let pressedText = sender.titleLabel!.text!
        
        println("\(pressedText) Gen")
        
        self.gen = pressedText
        
        //updateGenInfo(sender.titleLabel!.text!)
        
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "multiple" {
            if let destination = segue.destinationViewController as? multiple {
                
                destination.lastnext = swipedirection
                
                if swipedirection == "Left" {
                
                destination.family = chosenModel[0].nextFam
                
                } else if swipedirection == "Right" {
                
                destination.family = chosenModel[0].prevFam
                
                }
            
            }

        }

    }

}