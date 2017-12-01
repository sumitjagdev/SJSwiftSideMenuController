# SJSwiftSideMenuController

[![Version](https://img.shields.io/cocoapods/v/SJSwiftSideMenuController.svg?style=flat)](http://cocoapods.org/pods/SJSwiftSideMenuController)
[![License](https://img.shields.io/cocoapods/l/SJSwiftSideMenuController.svg?style=flat)](http://cocoapods.org/pods/SJSwiftSideMenuController)
[![Platform](https://img.shields.io/cocoapods/p/SJSwiftSideMenuController.svg?style=flat)](http://cocoapods.org/pods/SJSwiftSideMenuController)

## Overview

SJSwiftSideMenuController is Side Menu Controller for both Side Left & Right Menu With Both type of Side menu That is SlideOver and SlideView.
By only this menu controller you can use both left and right side menu with both type of sliding menu that is SlideOver the main view and SlideView with the main view.
You have to just set property and the meny get reflect with you requirement.

![](sample1.gif?raw=true "SJSwiftSideMenuController screenshot")
![](sample2.gif?raw=true "SJSwiftSideMenuController screenshot")
![](sample3.gif?raw=true "SJSwiftSideMenuController screenshot")

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
* ARC
* iOS8


## Installation

SJSwiftSideMenuController is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SJSwiftSideMenuController"
```
## Usage

```Swift
//TODO: To import Side Menu for use
import SJSwiftSideMenuController

//TODO: To setup SJSideMenuController
Assign Class of any view controller in storyboard with SJSwiftSideMenuController
Ex.
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let months = DateFormatter().monthSymbols
        let days = DateFormatter().weekdaySymbols
        
        let sideVC_L : SideMenuController = (storyBoard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
        sideVC_L.menuItems = months as NSArray!
        
        let sideVC_R : SideMenuController = (storyBoard.instantiateViewController(withIdentifier: "SideMenuController") as? SideMenuController)!
        sideVC_R.menuItems = days as NSArray!
        
        let rootVC = storyBoard.instantiateViewController(withIdentifier: "ViewController") as UIViewController
        
        SJSwiftSideMenuController.setUpNavigation(rootController: rootVC, leftMenuController: sideVC_L, rightMenuController: sideVC_R, leftMenuType: .SlideView, rightMenuType: .SlideView)
        
        SJSwiftSideMenuController.enableSwipeGestureWithMenuSide(menuSide: .LEFT)
        
        return true
    }
    
    //TODO: To add default menu button in navigation bar
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        if let image : UIImage = UIImage(named: "menu") as UIImage! {
            SJSwiftSideMenuController .showLeftMenuNavigationBarButton(image: image)
            SJSwiftSideMenuController .showRightMenuNavigationBarButton(image: image)
        }
        
        //To enable Swipe gesture for toggle menu
        SJSwiftSideMenuController.enableDimBackground = true
        
    }
    
    //TODO: To toggle menu at IBAction
    // right menu toggle
    @IBAction func toggleRightSideMenutapped(_ sender: AnyObject) {
        SJSwiftSideMenuController.toggleRightSideMenu()
    }
    // left menu toggle
    @IBAction func toggleLeftSideMenutapped(_ sender: AnyObject) {
        SJSwiftSideMenuController.toggleLeftSideMenu()
    }

```

## Author

Sumit Jagdev, sumitjagdev3@gmail.com

## License

SJSwiftSideMenuController is available under the MIT license. See the LICENSE file for more info.
