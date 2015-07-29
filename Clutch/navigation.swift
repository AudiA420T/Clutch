//
//  navigation.swift
//  Clutch
//
//  Created by Clinton Masterson on 5/5/15.
//  Copyright (c) 2015 clintApps. All rights reserved.
//

import UIKit

class navigation: UINavigationController, UIViewControllerTransitioningDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.topItem?.title = ""
        self.navigationBar.barStyle = UIBarStyle.Black
        self.navigationBar.tintColor = UIColor.blackColor()
        //self.navigationBar.translucent = false
        //self.navigationBar.titleTextAttributes =
        self.navigationBar.backItem?.title = "fihdijd"
        self.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "Arial", size: 24)!]

    }
}

/*

UINavigationBar : UIView, NSCoding, UIBarPositioning, NSObjectProtocol

init(title: String?) // Designated initializer

var title: String? // Title when topmost on the stack. default is nil
var backBarButtonItem: UIBarButtonItem? // Bar button item to use for the back button in the child navigation item.
var titleView: UIView? // Custom view to use in lieu of a title. May be sized horizontally. Only used when item is topmost on the stack.

var prompt: String? // Explanatory text to display above the navigation bar buttons.

var hidesBackButton: Bool // If YES, this navigation item will hide the back button when it's on top of the stack.
func setHidesBackButton(hidesBackButton: Bool, animated: Bool)

/* Use these properties to set multiple items in a navigation bar.
The older single properties (leftBarButtonItem and rightBarButtonItem) now refer to
the first item in the respective array of items.

NOTE: You'll achieve the best results if you use either the singular properties or
the plural properties consistently and don't try to mix them.

leftBarButtonItems are placed in the navigation bar left to right with the first
item in the list at the left outside edge and left aligned.
rightBarButtonItems are placed right to left with the first item in the list at
the right outside edge and right aligned.
*/
@availability(iOS, introduced=5.0)
var leftBarButtonItems: [AnyObject]?
@availability(iOS, introduced=5.0)
var rightBarButtonItems: [AnyObject]?
@availability(iOS, introduced=5.0)
func setLeftBarButtonItems(items: [AnyObject]?, animated: Bool)
@availability(iOS, introduced=5.0)
func setRightBarButtonItems(items: [AnyObject]?, animated: Bool)

/* By default, the leftItemsSupplementBackButton property is NO. In this case,
the back button is not drawn and the left item or items replace it. If you
would like the left items to appear in addition to the back button (as opposed to instead of it)
set leftItemsSupplementBackButton to YES.
*/
@availability(iOS, introduced=5.0)
var leftItemsSupplementBackButton: Bool

// Some navigation items want to display a custom left or right item when they're on top of the stack.
// A custom left item replaces the regular back button unless you set leftItemsSupplementBackButton to YES
var leftBarButtonItem: UIBarButtonItem?
var rightBarButtonItem: UIBarButtonItem?
func setLeftBarButtonItem(item: UIBarButtonItem?, animated: Bool)
func setRightBarButtonItem(item: UIBarButtonItem?, animated: Bool)*/