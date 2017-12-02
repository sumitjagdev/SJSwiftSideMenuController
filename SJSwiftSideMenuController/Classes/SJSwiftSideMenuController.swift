//
//  SJSwiftSideMenuController.swift
//  SJSwiftNavigationController
//
//  Created by Sumit Jagdev on 1/6/17.
//  Copyright © 2017 Sumit Jagdev. All rights reserved.
//



import UIKit

public enum SJSideMenuPosition {
    case LEFT
    case RIGHT
    case NONE
}

public enum SJSideMenuType {
    case SlideOver
    case SlideView
}

public class SJSwiftSideMenuController: UIViewController, UINavigationControllerDelegate {
    
    private static var swipeMenuSide : SJSideMenuPosition = .NONE
    
    private static var isSetup : Bool = false
    
    public static var enableDimbackground : Bool = false
    
    public static var shouldLeaveSpaceForStatusBar : Bool = false
    private static var shouldShowLeftButton : Bool = false
    private static var shouldShowRightButton : Bool = false
    private static var menuIcon_Left : UIImage = UIImage()
    private static var menuIcon_Right : UIImage = UIImage()
    
    private static var navigator : UINavigationController! = nil
    public static var navigationContainer : UIViewController! = nil
    
    // left menu views
    private static var leftSideMenuController : UIViewController!
    private static var leftSideMenuType     : SJSideMenuType        = .SlideView
    public static var leftMenuWidth : CGFloat = 150
    private static var leftSideMenuView : UIView! = UIView()
    
    // Right menu views
    private static var rightSideMenuController : UIViewController!
    private static var rightSideMenuType     : SJSideMenuType        = .SlideView
    public static var rightMenuWidth : CGFloat = 250
    private static var rightSideMenuView : UIView! = UIView()
    
    private static var containerView : UIView! = UIView()
    private static var dimBGView : UIView! = UIView()
    
    // Left Menu constraint
    private static var leadingConstraintOfSideMenu_Left : NSLayoutConstraint!
    private static var topConstraintOfSideMenu_Left : NSLayoutConstraint!
    private static var bottomConstraintOfSideMenu_Left : NSLayoutConstraint!
    private static var widthConstraintOfSideMenu_Left : NSLayoutConstraint!
    
    // Right Menu constraint
    private static var leadingConstraintOfSideMenu_Right : NSLayoutConstraint!
    private static var topConstraintOfSideMenu_Right : NSLayoutConstraint!
    private static var bottomConstraintOfSideMenu_Right : NSLayoutConstraint!
    private static var widthConstraintOfSideMenu_Right : NSLayoutConstraint!
    
    private static var leadingConstraintOfContainer : NSLayoutConstraint!
    private static var topConstraintOfSideContainer : NSLayoutConstraint!
    private static var bottomConstraintOfContainer : NSLayoutConstraint!
    private static var trailingConstraintOfContainer : NSLayoutConstraint!
    
    //MARK: Methods
    
    public static func setUpNavigation(rootController:UIViewController, leftMenuController : UIViewController?, rightMenuController : UIViewController?, leftMenuType: SJSideMenuType, rightMenuType: SJSideMenuType){
        
        
        var isMenu : Bool = false
        if leftMenuController != nil {
            isMenu = true
        }
        if rightMenuController != nil {
            isMenu = true
        }
        assert(isMenu != false, "Please provide side menu controller")
        
        isSetup = true
        
        
        
        
        
        leftSideMenuController = leftMenuController
        leftSideMenuType = leftMenuType
        
        
        rightSideMenuController = rightMenuController
        rightSideMenuType = rightMenuType
        
        
        let appNav = UINavigationController()
        appNav.viewControllers = NSArray(object: rootController) as! [UIViewController]
        navigator = appNav
        assert(isMenu != false, "Please provide any one side menu controller")
        assert(appNav.viewControllers.count > 0, "Please provide root controller")
        
    }
    
    public static func enableSwipeGestureWithMenuSide(menuSide : SJSideMenuPosition){
        SJSwiftSideMenuController.swipeMenuSide = menuSide
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        
        SJSwiftSideMenuController.navigator.delegate = self
        
        self.view.backgroundColor = UIColor.white
        SJSwiftSideMenuController.navigationContainer = self;
        SJSwiftSideMenuController.navigator.delegate = self
        setUpContainers()
        // Do any additional setup after loading the view.
        
        // menu gesture recognisers
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SJSwiftSideMenuController.toggleMenuWithGesture(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action:#selector(SJSwiftSideMenuController.toggleMenuWithGesture(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private static func addDefaultLeftMenuButton(){
        //        let menuIcon : UIImage = UIImage(named: "menu")!
        let menuIcon = menuIcon_Left
        let button : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button .setImage(menuIcon, for: .normal)
        button .addTarget(SJSwiftSideMenuController.navigationContainer, action: #selector(SJSwiftSideMenuController.leftMenuButtonTapped(_:)), for: .touchUpInside)
        button .imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let leftButton = UIBarButtonItem(customView: button)
        self.navigator.topViewController?.navigationItem.leftBarButtonItem = leftButton
        
    }
    private static func addDefaultRightMenuButton(){
        //        let menuIcon : UIImage = UIImage(named: "menu")!
        let menuIcon = menuIcon_Right
        let button : UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        button .setImage(menuIcon, for: .normal)
        button .addTarget(SJSwiftSideMenuController.navigationContainer, action: #selector(SJSwiftSideMenuController.rightMenuButtonTapped(_:)), for: .touchUpInside)
        button .imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        let rightButton = UIBarButtonItem(customView: button)
        self.navigator.topViewController?.navigationItem.rightBarButtonItem = rightButton
        
    }
    
    public static func showLeftMenuNavigationBarButton(image : UIImage){
        shouldShowLeftButton = true
        menuIcon_Left = image
    }
    
    public static func showRightMenuNavigationBarButton(image : UIImage){
        shouldShowRightButton = true
        menuIcon_Right = image
    }
    
    static func setUpLeftMenuWidth(width : CGFloat){
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        leftMenuWidth = width
        if SJSwiftSideMenuController.navigator != nil {
            SJSwiftSideMenuController.navigator .viewWillAppear(true)
        }
    }
    static func setUpRightMenuWidth(width : CGFloat){
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        rightMenuWidth = width
        if SJSwiftSideMenuController.navigator != nil {
            SJSwiftSideMenuController.navigator .viewWillAppear(true)
        }
    }
    
    func setUpContainers() {
        //======================= Container View ===============================
        SJSwiftSideMenuController.containerView = UIView()
        SJSwiftSideMenuController.containerView.backgroundColor = UIColor.white
        let frame = self.view.bounds
        
        SJSwiftSideMenuController.containerView.frame = frame
        SJSwiftSideMenuController.containerView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        self.view.addSubview(SJSwiftSideMenuController.containerView)
        
        SJSwiftSideMenuController.topConstraintOfSideContainer = SJSwiftSideMenuController.containerView.addTopConstraint(toView: view, constant: 0.0)
        SJSwiftSideMenuController.leadingConstraintOfContainer = SJSwiftSideMenuController.containerView.addLeadingConstraint(toView: view, constant: 0.0)
        SJSwiftSideMenuController.trailingConstraintOfContainer = SJSwiftSideMenuController.containerView.addTrailingConstraint(toView: view, constant: 0.0)
        SJSwiftSideMenuController.bottomConstraintOfContainer = SJSwiftSideMenuController.containerView.addBottomConstraint(toView: view, constant: 0.0)
        
        addViewControllerAsChildViewController(SJSwiftSideMenuController.navigator, inContainer: SJSwiftSideMenuController.containerView)
        
        
        //===================== Dim BG View ================================
        
        addDimBG()
        //=================== Left menu setup=========================
        if SJSwiftSideMenuController.leftSideMenuController != nil {
            SJSwiftSideMenuController.leftSideMenuView = UIView()
            SJSwiftSideMenuController.leftSideMenuView.backgroundColor = UIColor.white
            var frame = CGRect(x: 0, y: 0, width: SJSwiftSideMenuController.leftMenuWidth, height: self.view.frame.size.height)
            if SJSwiftSideMenuController.leftSideMenuType == .SlideView {
                frame.origin.x = -(SJSwiftSideMenuController.leftMenuWidth)
            }
            SJSwiftSideMenuController.leftSideMenuView.frame = frame
            SJSwiftSideMenuController.leftSideMenuView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
            self.view.addSubview(SJSwiftSideMenuController.leftSideMenuView)
            
            SJSwiftSideMenuController.topConstraintOfSideMenu_Left = SJSwiftSideMenuController.leftSideMenuView.addTopConstraint(toView: view, constant: 0.0)
            if SJSwiftSideMenuController.leftSideMenuType == .SlideOver {
                SJSwiftSideMenuController.leadingConstraintOfSideMenu_Left = SJSwiftSideMenuController.leftSideMenuView.addLeadingConstraint(toView: view, constant: 0.0)
            }else{
                SJSwiftSideMenuController.leadingConstraintOfSideMenu_Left = SJSwiftSideMenuController.leftSideMenuView.addLeadingConstraint(toView: view, constant: -(SJSwiftSideMenuController.leftMenuWidth))
            }
            SJSwiftSideMenuController.bottomConstraintOfSideMenu_Left = SJSwiftSideMenuController.leftSideMenuView.addWidthConstraint(widthConstant: SJSwiftSideMenuController.leftMenuWidth)
            SJSwiftSideMenuController.bottomConstraintOfSideMenu_Left = SJSwiftSideMenuController.leftSideMenuView.addBottomConstraint(toView: view, constant: 0.0)
            
            addViewControllerAsChildViewController(SJSwiftSideMenuController.leftSideMenuController, inContainer: SJSwiftSideMenuController.leftSideMenuView)
            
            SJSwiftSideMenuController.leftSideMenuView.isHidden = true
        }
        
        
        //==================================================================
        //=================== Right menu setup=========================
        if SJSwiftSideMenuController.rightSideMenuController != nil {
            SJSwiftSideMenuController.rightSideMenuView = UIView()
            SJSwiftSideMenuController.rightSideMenuView.backgroundColor = UIColor.white
            var frameRight = CGRect(x: self.view.frame.size.width, y: 0, width: SJSwiftSideMenuController.rightMenuWidth, height: self.view.frame.size.height)
            
            if SJSwiftSideMenuController.rightSideMenuType == .SlideView {
                //                frameRight.origin.x = -(SJNavigationController.rightMenuWidth)
                frameRight.origin.x = 0
            }
            SJSwiftSideMenuController.rightSideMenuView.frame = frameRight
            SJSwiftSideMenuController.rightSideMenuView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
            self.view.addSubview(SJSwiftSideMenuController.rightSideMenuView)
            self.view.bringSubview(toFront: SJSwiftSideMenuController.rightSideMenuView)
            
            SJSwiftSideMenuController.topConstraintOfSideMenu_Right = SJSwiftSideMenuController.rightSideMenuView.addTopConstraint(toView: view, constant: 0.0)
            if SJSwiftSideMenuController.rightSideMenuType == .SlideOver {
                SJSwiftSideMenuController.leadingConstraintOfSideMenu_Right = SJSwiftSideMenuController.rightSideMenuView.addLeadingConstraint(toView: view, constant: view.frame.size.width - SJSwiftSideMenuController.rightMenuWidth)
            }else{
                SJSwiftSideMenuController.leadingConstraintOfSideMenu_Right = SJSwiftSideMenuController.rightSideMenuView.addLeadingConstraint(toView: view, constant: view.frame.size.width - SJSwiftSideMenuController.rightMenuWidth)
            }
            SJSwiftSideMenuController.widthConstraintOfSideMenu_Right = SJSwiftSideMenuController.rightSideMenuView.addWidthConstraint(widthConstant: SJSwiftSideMenuController.rightMenuWidth)
            SJSwiftSideMenuController.bottomConstraintOfSideMenu_Right = SJSwiftSideMenuController.rightSideMenuView.addBottomConstraint(toView: view, constant: 0.0)
            
            //            SJSwiftSideMenuController.rightSideMenuView.backgroundColor = UIColor.red
            addViewControllerAsChildViewController(SJSwiftSideMenuController.rightSideMenuController, inContainer: SJSwiftSideMenuController.rightSideMenuView)
            
            SJSwiftSideMenuController.rightSideMenuView.isHidden = true
        }
        
        
        
        
        
    }
    private func addDimBG() {
        if SJSwiftSideMenuController.dimBGView != nil {
            SJSwiftSideMenuController.dimBGView.removeFromSuperview()
        }
        
        SJSwiftSideMenuController.dimBGView = UIView()
        SJSwiftSideMenuController.dimBGView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        let frame = self.view.bounds
        
        SJSwiftSideMenuController.dimBGView.frame = frame
        SJSwiftSideMenuController.dimBGView.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin]
        self.view.addSubview(SJSwiftSideMenuController.dimBGView)
        
        SJSwiftSideMenuController.dimBGView.addTopConstraint(toView: view, constant: 0.0)
        SJSwiftSideMenuController.dimBGView.addLeadingConstraint(toView: view, constant: 0.0)
        SJSwiftSideMenuController.dimBGView.addTrailingConstraint(toView: view, constant: 0.0)
        SJSwiftSideMenuController.dimBGView.addBottomConstraint(toView: view, constant: 0.0)
        SJSwiftSideMenuController.dimBGView.isHidden = true
        let tapG = UITapGestureRecognizer(target: self, action: #selector(SJSwiftSideMenuController.dimBgTappedGesture(gesture:)))
        tapG.numberOfTapsRequired = 1
        SJSwiftSideMenuController.dimBGView.addGestureRecognizer(tapG)
        SJSwiftSideMenuController.dimBGView.isHidden = true
    }
    
    private static func showDimBackground(show: Bool) {
        if SJSwiftSideMenuController.dimBGView == nil {
            return
        }
        if enableDimbackground == false {
            return;
        }
        UIView.transition(with: SJSwiftSideMenuController.dimBGView, duration: 0.25, options: .curveEaseInOut, animations: {() -> Void in
            
            SJSwiftSideMenuController.dimBGView.isHidden = !show
            
        }, completion: { _ in
            
        })
    }
    fileprivate func addViewControllerAsChildViewController(_ viewController: UIViewController, inContainer: UIView) {
        
        
        
        //                 Add Child View Controller
        addChildViewController(viewController)
        //
        //        // Add Child View as Subview
        inContainer.addSubview(viewController.view!)
        //
        //        // Configure Child View
        
        var childFrame = inContainer.frame
        childFrame.origin = CGPoint.zero
        viewController.view?.frame = childFrame
        viewController.view.autoresizingMask = [UIViewAutoresizing.flexibleLeftMargin, UIViewAutoresizing.flexibleRightMargin, UIViewAutoresizing.flexibleTopMargin, UIViewAutoresizing.flexibleBottomMargin
            , UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        //
        //        // Notify Child View Controller
        viewController.didMove(toParentViewController: self)
    }
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if SJSwiftSideMenuController.shouldLeaveSpaceForStatusBar == true {
            if UIApplication.shared.isStatusBarHidden {
                SJSwiftSideMenuController.topConstraintOfSideContainer.constant = 0
                SJSwiftSideMenuController.topConstraintOfSideMenu_Left.constant = 0
                SJSwiftSideMenuController.topConstraintOfSideMenu_Right.constant = 0
            }else{
                SJSwiftSideMenuController.topConstraintOfSideContainer.constant = 20
                SJSwiftSideMenuController.topConstraintOfSideMenu_Left.constant = 20
                SJSwiftSideMenuController.topConstraintOfSideMenu_Right.constant = 20
            }
        }
        
    }
    @objc private func toggleMenuWithGesture(gesture: UISwipeGestureRecognizer) {
        if SJSwiftSideMenuController.swipeMenuSide == .RIGHT {
            toggleRightMenuWithGesture(gesture: gesture)
        }else if SJSwiftSideMenuController.swipeMenuSide == .LEFT {
            toggleLeftMenuWithGesture(gesture: gesture)
        }
    }
    
    @objc private func dimBgTappedGesture(gesture: UITapGestureRecognizer) {
        if SJSwiftSideMenuController.leftSideMenuController != nil {
            SJSwiftSideMenuController.hideLeftMenu()
        }
        if SJSwiftSideMenuController.rightSideMenuController != nil {
            SJSwiftSideMenuController.hideRightMenu()
        }
    }
    
    @IBAction func leftMenuButtonTapped(_ sender: AnyObject){
        SJSwiftSideMenuController.toggleLeftSideMenu()
    }
    @IBAction func rightMenuButtonTapped(_ sender: AnyObject){
        SJSwiftSideMenuController.toggleRightSideMenu()
    }
    //MARK : Left menu
    // left side menu methods
    public static func toggleLeftSideMenu() {
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.validateForLeftMenuSetup()
        if SJSwiftSideMenuController.leftSideMenuType == .SlideOver {
            toggleLeftSlideOverMenu()
        }else if SJSwiftSideMenuController.leftSideMenuType == .SlideView {
            toggleLeftSlideViewMenu()
        }
    }
    
    public static func showLeftMenu(){
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.validateForLeftMenuSetup()
        if SJSwiftSideMenuController.leftSideMenuType == .SlideOver {
            showLeftMenuOver()
        }else if SJSwiftSideMenuController.leftSideMenuType == .SlideView {
            showLeftMenuBySide()
        }
    }
    public static func hideLeftMenu(){
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.validateForLeftMenuSetup()
        if SJSwiftSideMenuController.leftSideMenuType == .SlideOver {
            hideLeftMenuOver()
        }else if SJSwiftSideMenuController.leftSideMenuType == .SlideView {
            hideLeftMenuBySide()
        }
    }
    private static func toggleLeftSlideOverMenu() {
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        if SJSwiftSideMenuController.leftSideMenuView.isHidden == true {
            SJSwiftSideMenuController.showLeftMenuOver()
        }else{
            SJSwiftSideMenuController.hideLeftMenuOver()
        }
        
        if leftSideMenuController != nil {
            leftSideMenuController .viewWillAppear(true)
        }
    }
    
    private static func toggleLeftSlideViewMenu() {
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        if SJSwiftSideMenuController.containerView.frame.origin.x == 0 {
            showLeftMenuBySide()
        }else{
            hideLeftMenuBySide()
        }
    }
    
    private func toggleLeftMenuWithGesture(gesture: UISwipeGestureRecognizer)
    {
        SJSwiftSideMenuController.validateForLeftMenuSetup()
        
        if let swipeGesture = gesture as UISwipeGestureRecognizer! {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                SJSwiftSideMenuController.showLeftMenu()
            case UISwipeGestureRecognizerDirection.left:
                SJSwiftSideMenuController.hideLeftMenu()
            default:
                SJSwiftSideMenuController.hideLeftMenu()
            }
        }
        if SJSwiftSideMenuController.leftSideMenuController != nil {
            SJSwiftSideMenuController.leftSideMenuController .viewWillAppear(true)
        }
    }
    private static func showLeftMenuOver() {
        
        if SJSwiftSideMenuController.rightSideMenuController != nil {
            SJSwiftSideMenuController.hideRightMenu()
        }
        
        showDimBackground(show: true)
        
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.navigationContainer.view.bringSubview(toFront: SJSwiftSideMenuController.leftSideMenuView)
        SJSwiftSideMenuController.leftSideMenuView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            //            var frame = leftSideMenuView.frame
            //            frame.origin.x = 0
            //            leftSideMenuView.frame = frame
            //            SJSwiftSideMenuController.navigationContainer.view.layoutSubviews()
            //            SJSwiftSideMenuController.leftSideMenuView.layoutSubviews()
            //            SJSwiftSideMenuController.navigator.view.layoutSubviews()
            leadingConstraintOfSideMenu_Left.constant = 0
            SJSwiftSideMenuController.navigationContainer.view.layoutIfNeeded()
            
        }) { (isComplete) in
            
        }
        
    }
    private static func hideLeftMenuOver() {
        
        showDimBackground(show: false)
        
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        if SJSwiftSideMenuController.navigationContainer == nil {
            return
        }
        SJSwiftSideMenuController.navigationContainer.view.bringSubview(toFront: SJSwiftSideMenuController.leftSideMenuView)
        UIView.animate(withDuration: 0.25, animations: {
            
            leadingConstraintOfSideMenu_Left.constant = -(leftMenuWidth)
            SJSwiftSideMenuController.navigationContainer.view.layoutIfNeeded()
        }) { (isComplete) in
            SJSwiftSideMenuController.leftSideMenuView.isHidden = true
        }
        
    }
    
    private static func showLeftMenuBySide(){
        
        if SJSwiftSideMenuController.rightSideMenuController != nil {
            SJSwiftSideMenuController.hideRightMenu()
        }
        
        
        showDimBackground(show: true)
        
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.leftSideMenuView.isHidden = false
        UIView.animate(withDuration: 0.25, animations: {
            var frame = SJSwiftSideMenuController.containerView.frame
            frame.origin.x = +(leftMenuWidth)
            SJSwiftSideMenuController.containerView.frame = frame
            
            //Side Menu
            frame = leftSideMenuView.frame
            frame.origin.x = 0
            leftSideMenuView.frame = frame
            SJSwiftSideMenuController.containerView.layoutIfNeeded()
        }) { (isComplete) in
            
        }
    }
    
    private static func hideLeftMenuBySide(){
        
        showDimBackground(show: false)
        
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        UIView.animate(withDuration: 0.25, animations: {
            var frame = SJSwiftSideMenuController.containerView.frame
            frame.origin.x = 0
            SJSwiftSideMenuController.containerView.frame = frame
            
            //Side Menu
            frame = leftSideMenuView.frame
            frame.origin.x = -(leftMenuWidth)
            leftSideMenuView.frame = frame
            SJSwiftSideMenuController.containerView.layoutIfNeeded()
        }) { (isComplete) in
            SJSwiftSideMenuController.leftSideMenuView.isHidden = true
        }
    }
    
    //MARK : Right menu
    // Right side menu methods
    
    public static func toggleRightSideMenu() {
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.validateForRightMenuSetup()
        if SJSwiftSideMenuController.rightSideMenuType == .SlideOver {
            SJSwiftSideMenuController.toggleRightSlideOverMenu()
        }else if SJSwiftSideMenuController.rightSideMenuType == .SlideView {
            SJSwiftSideMenuController.toggleRightSlideViewMenu()
        }
    }
    
    
    public static func showRightMenu(){
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.validateForRightMenuSetup()
        if SJSwiftSideMenuController.rightSideMenuType == .SlideOver {
            SJSwiftSideMenuController.showRightMenuOver()
        }else if SJSwiftSideMenuController.rightSideMenuType == .SlideView {
            SJSwiftSideMenuController.showRightMenuBySide()
        }
    }
    public static func hideRightMenu(){
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.validateForRightMenuSetup()
        if SJSwiftSideMenuController.rightSideMenuType == .SlideOver {
            SJSwiftSideMenuController.hideRightMenuOver()
        }else if SJSwiftSideMenuController.rightSideMenuType == .SlideView {
            SJSwiftSideMenuController.hideRightMenuBySide()
        }
    }
    private static func toggleRightSlideOverMenu() {
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        if SJSwiftSideMenuController.rightSideMenuView.isHidden == true {
            SJSwiftSideMenuController.showRightMenuOver()
        }else{
            SJSwiftSideMenuController.hideRightMenuOver()
        }
    }
    
    private static func toggleRightSlideViewMenu() {
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        if SJSwiftSideMenuController.containerView.frame.origin.x == 0 {
            SJSwiftSideMenuController.showRightMenuBySide()
        }else{
            SJSwiftSideMenuController.hideRightMenuBySide()
        }
    }
    
    private func toggleRightMenuWithGesture(gesture: UISwipeGestureRecognizer)
    {
        SJSwiftSideMenuController.validateForRightMenuSetup()
        
        if let swipeGesture = gesture as UISwipeGestureRecognizer! {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                SJSwiftSideMenuController.hideRightMenu()
            case UISwipeGestureRecognizerDirection.left:
                SJSwiftSideMenuController.showRightMenu()
            default:
                SJSwiftSideMenuController.hideRightMenu()
            }
        }
    }
    private static func showRightMenuOver() {
        
        if SJSwiftSideMenuController.leftSideMenuController != nil {
            SJSwiftSideMenuController.hideLeftMenu()
        }
        
        showDimBackground(show: true)
        
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.navigationContainer.view.bringSubview(toFront: SJSwiftSideMenuController.rightSideMenuView)
        SJSwiftSideMenuController.rightSideMenuView.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.leadingConstraintOfSideMenu_Right.constant = SJSwiftSideMenuController.containerView.frame.size.width - rightMenuWidth
            SJSwiftSideMenuController.navigationContainer.view.layoutIfNeeded()
        }, completion: nil)
        
    }
    private static func hideRightMenuOver() {
        showDimBackground(show: false)
        
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.navigationContainer.view.bringSubview(toFront: SJSwiftSideMenuController.rightSideMenuView)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.leadingConstraintOfSideMenu_Right.constant = SJSwiftSideMenuController.containerView.frame.size.width
            SJSwiftSideMenuController.navigationContainer.view.layoutIfNeeded()
        }, completion: { _ in
            SJSwiftSideMenuController.rightSideMenuView.isHidden = true
        })
    }
    
    private static func showRightMenuBySide(){
        
        if SJSwiftSideMenuController.leftSideMenuController != nil {
            SJSwiftSideMenuController.hideLeftMenu()
        }
        showDimBackground(show: true)
        
        
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.rightSideMenuView.isHidden = false
        
        UIView.transition(with: rightSideMenuView, duration: 0.5, options: .curveEaseOut, animations: {() -> Void in
            var frame = SJSwiftSideMenuController.containerView.frame
            frame.origin.x = -(rightMenuWidth)
            SJSwiftSideMenuController.containerView.frame = frame
            
            //Side Menu
            frame = rightSideMenuView.frame
            frame.origin.x = containerView.frame.size.width - rightMenuWidth
            rightSideMenuView.frame = frame
            SJSwiftSideMenuController.containerView.layoutIfNeeded()
            
        }, completion: { _ in
            
        })
    }
    
    private static func hideRightMenuBySide(){
        showDimBackground(show: false)
        
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        
        UIView.transition(with: rightSideMenuView, duration: 0.5, options: .curveEaseOut, animations: {() -> Void in
            var frame = SJSwiftSideMenuController.containerView.frame
            frame.origin.x = 0
            SJSwiftSideMenuController.containerView.frame = frame
            
            //Side Menu
            frame = rightSideMenuView.frame
            frame.origin.x = containerView.frame.size.width
            rightSideMenuView.frame = frame
            SJSwiftSideMenuController.containerView.layoutIfNeeded()
            
        }, completion: { _ in
            SJSwiftSideMenuController.rightSideMenuView.isHidden = true
        })
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //        SJNavigationController.toggleRightSideMenu()
    }
    
    //MARK: Navigation
    // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
    public static func setRootController(_ viewController: UIViewController, animated: Bool) {
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        SJSwiftSideMenuController.navigator.pushViewController(viewController, animated: animated)
        SJSwiftSideMenuController.navigator.viewControllers = [viewController]
        //        SJSwiftSideMenuController.navigator.pushViewController(viewController, animated: animated)
    }
    
    // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.
    public static func pushViewController(_ viewController: UIViewController, animated: Bool) {
        DispatchQueue.main.async {
            SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
            var vcList = SJSwiftSideMenuController.viewControllers
            if vcList.contains(viewController) == true {
                let index = vcList.index(of: viewController)
                vcList.remove(at: index!)
                SJSwiftSideMenuController.navigator.viewControllers = vcList
            }
            SJSwiftSideMenuController.navigator.pushViewController(viewController, animated: animated)
        }
    }
    
    // Returns the popped controller.
    public static func popViewController(animated: Bool){
        DispatchQueue.main.async {
            SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
            SJSwiftSideMenuController.navigator.popViewController(animated: animated)
        }
    }
    
    // Returns the popped controller.
    public static func popAndGetViewController(animated: Bool) -> UIViewController?{
        
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        return SJSwiftSideMenuController.navigator.popViewController(animated: animated)
    }
    
    // Pops view controllers until the one specified is on top. Returns the popped controllers.
    public static func popToViewController(_ viewController: UIViewController, animated: Bool) -> [UIViewController]?{
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        return SJSwiftSideMenuController.navigator.popToViewController(viewController, animated: animated)
    }
    
    // Pops until there's only a single view controller left on the stack. Returns the popped controllers.
    public static func popToRootViewController(animated: Bool) -> [UIViewController]?{
        SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
        return SJSwiftSideMenuController.navigator.popToRootViewController(animated: animated)
    }
    
    // The top view controller on the stack.
    public static var topViewController: UIViewController?{
        
        get {
            SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
            return SJSwiftSideMenuController.navigator.topViewController
        }
    }
    
    // Return modal view controller if it exists. Otherwise the top view controller.
    public static var visibleViewController: UIViewController?{
        get {
            SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
            return SJSwiftSideMenuController.navigator.visibleViewController
        }
    }
    
    // The current view controller stack.
    public static var viewControllers: [UIViewController]{
        get {
            SJSwiftSideMenuController.validateForNavigationSetup() //Check for setup
            return SJSwiftSideMenuController.navigator.viewControllers
        }
    }
    //MARK: Navigation delegate
    public func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if SJSwiftSideMenuController.shouldShowLeftButton == true {
            SJSwiftSideMenuController.addDefaultLeftMenuButton()
        }
        
        if SJSwiftSideMenuController.shouldShowRightButton == true {
            SJSwiftSideMenuController.addDefaultRightMenuButton()
        }
        
        
    }
    private static func validateForNavigationSetup(){
        
        assert((SJSwiftSideMenuController.isSetup == true) == true, "Please call setupNavigationMethod in AppDelegate class") // here
    }
    
    private static func validateForLeftMenuSetup(){
        
        assert(SJSwiftSideMenuController.leftSideMenuController != nil, "Please set LeftSideMenuController before using left menu methods.") // here
    }
    
    private static func validateForRightMenuSetup(){
        
        assert(SJSwiftSideMenuController.rightSideMenuController != nil, "Please set RightSideMenuController before using left menu methods.") // here
    }
    
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if SJSwiftSideMenuController.leftSideMenuController != nil {
            SJSwiftSideMenuController.hideLeftMenu()
        }
        if SJSwiftSideMenuController.rightSideMenuController != nil {
            SJSwiftSideMenuController.hideRightMenu()
        }
    }
    
    public static func replaceViewController(atIndex : Int, newVC : UIViewController) {
        SJSwiftSideMenuController.navigator.viewControllers[atIndex] = newVC
    }
}

//MARK : UIColor
//
//
//extension CGFloat {
//    public static func random() -> CGFloat {
//        return CGFloat(arc4random()) / CGFloat(UInt32.max)
//    }
//}
//
//extension UIColor {
//    public static func randomColor() -> UIColor {
//        // If you wanted a random alpha, just create another
//        // random number for that too.
//        return UIColor(red:   .random(),
//                       green: .random(),
//                       blue:  .random(),
//                       alpha: 1.0)
//    }
//}

extension UIButton {
    public func centerTextAndImage(spacing: CGFloat) {
        let insetAmount = spacing / 2
        imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
    }
}

//MARK : UIView
extension UIView {
    
    
    // MARK: - Fill
    
    /**
     Creates and adds an array of NSLayoutConstraint objects that relates this view's top, leading, bottom and trailing to its superview, given an optional set of insets for each side.
     
     Default parameter values relate this view's top, leading, bottom and trailing to its superview with no insets.
     
     @note The constraints are also added to this view's superview for you
     
     :param: edges An amount insets to apply to the top, leading, bottom and trailing constraint. Default value is UIEdgeInsetsZero
     
     :returns: An array of 4 x NSLayoutConstraint objects (top, leading, bottom, trailing) if the superview exists otherwise an empty array
     */
    @discardableResult
    public func fillSuperView(_ edges: UIEdgeInsets = UIEdgeInsets.zero) -> [NSLayoutConstraint] {
        
        var constraints: [NSLayoutConstraint] = []
        
        if let superview = superview {
            
            let topConstraint = addTopConstraint(toView: superview, constant: edges.top)
            let leadingConstraint = addLeadingConstraint(toView: superview, constant: edges.left)
            let bottomConstraint = addBottomConstraint(toView: superview, constant: -edges.bottom)
            let trailingConstraint = addTrailingConstraint(toView: superview, constant: -edges.right)
            
            constraints = [topConstraint, leadingConstraint, bottomConstraint, trailingConstraint]
        }
        
        return constraints
    }
    
    
    // MARK: - Leading / Trailing
    
    /**
     Creates and adds an `NSLayoutConstraint` that relates this view's leading edge to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's leading edge to be equal to the leading edge of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's leading edge to e.g. the other view's trailing edge. Default value is `NSLayoutAttribute.Leading`
     
     :param: relation  The relation of the constraint. Default value is `NSLayoutRelation.Equal`
     
     :param: constant  An amount by which to offset this view's left from the other view's specified edge. Default value is 0
     
     :returns: The created `NSLayoutConstraint` for this leading attribute relation
     */
    @discardableResult
    public func addLeadingConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .leading, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .leading, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    @discardableResult
    public func addWidthConstraint(widthConstant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint =  NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: widthConstant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    /**
     Creates and adds an `NSLayoutConstraint` that relates this view's trailing edge to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's trailing edge to be equal to the trailing edge of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's leading edge to e.g. the other view's trailing edge. Default value is `NSLayoutAttribute.Trailing`
     
     :param: relation  The relation of the constraint. Default value is `NSLayoutRelation.Equal`
     
     :param: constant  An amount by which to offset this view's left from the other view's specified edge. Default value is 0
     
     :returns: The created `NSLayoutConstraint` for this trailing attribute relation
     */
    @discardableResult
    public func addTrailingConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .trailing, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .trailing, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Left
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's left to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's left to be equal to the left of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's left side to e.g. the other view's right. Default value is NSLayoutAttribute.Left
     
     :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant  An amount by which to offset this view's left from the other view's specified edge. Default value is 0
     
     :returns: The created NSLayoutConstraint for this left attribute relation
     */
    @discardableResult
    public func addLeftConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .left, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .left, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Right
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's right to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's right to be equal to the right of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's right to e.g. the other view's left. Default value is NSLayoutAttribute.Right
     
     :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant  An amount by which to offset this view's right from the other view's specified edge. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this right attribute relation
     */
    @discardableResult
    public func addRightConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .right, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .right, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Top
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's top to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's right to be equal to the right of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's top to e.g. the other view's bottom. Default value is NSLayoutAttribute.Bottom
     
     :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant  An amount by which to offset this view's top from the other view's specified edge. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this top edge layout relation
     */
    @discardableResult
    public func addTopConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .top, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .top, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Bottom
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's bottom to some specified edge of another view, given a relation and offset.
     Default parameter values relate this view's right to be equal to the right of the other view.
     
     @note The new constraint is added to this view's superview for you
     
     :param: view      The other view to relate this view's layout to
     
     :param: attribute The other view's layout attribute to relate this view's bottom to e.g. the other view's top. Default value is NSLayoutAttribute.Botom
     
     :param: relation  The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant  An amount by which to offset this view's bottom from the other view's specified edge. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this bottom edge layout relation
     */
    @discardableResult
    public func addBottomConstraint(toView view: UIView?, attribute: NSLayoutAttribute = .bottom, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .bottom, toView: view, attribute: attribute, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Center X
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's center X attribute to the center X attribute of another view, given a relation and offset.
     Default parameter values relate this view's center X to be equal to the center X of the other view.
     
     :param: view     The other view to relate this view's layout to
     
     :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant An amount by which to offset this view's center X attribute from the other view's center X attribute. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this center X layout relation
     */
    @discardableResult
    public func addCenterXConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .centerX, toView: view, attribute: .centerX, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Center Y
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's center Y attribute to the center Y attribute of another view, given a relation and offset.
     Default parameter values relate this view's center Y to be equal to the center Y of the other view.
     
     :param: view     The other view to relate this view's layout to
     
     :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant An amount by which to offset this view's center Y attribute from the other view's center Y attribute. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this center Y layout relation
     */
    @discardableResult
    public func addCenterYConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .centerY, toView: view, attribute: .centerY, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Width
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's width to the width of another view, given a relation and offset.
     Default parameter values relate this view's width to be equal to the width of the other view.
     
     :param: view     The other view to relate this view's layout to
     
     :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant An amount by which to offset this view's width from the other view's width amount. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this width layout relation
     */
    @discardableResult
    public func addWidthConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .width, toView: view, attribute: .width, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Height
    
    /**
     Creates and adds an NSLayoutConstraint that relates this view's height to the height of another view, given a relation and offset.
     Default parameter values relate this view's height to be equal to the height of the other view.
     
     :param: view     The other view to relate this view's layout to
     
     :param: relation The relation of the constraint. Default value is NSLayoutRelation.Equal
     
     :param: constant An amount by which to offset this view's height from the other view's height amount. Default value is 0.0
     
     :returns: The created NSLayoutConstraint for this height layout relation
     */
    @discardableResult
    public func addHeightConstraint(toView view: UIView?, relation: NSLayoutRelation = .equal, constant: CGFloat = 0.0) -> NSLayoutConstraint {
        
        let constraint = createConstraint(attribute: .height, toView: view, attribute: .height, relation: relation, constant: constant)
        addConstraintToSuperview(constraint)
        
        return constraint
    }
    
    
    // MARK: - Private
    
    /// Adds an NSLayoutConstraint to the superview
    fileprivate func addConstraintToSuperview(_ constraint: NSLayoutConstraint) {
        
        translatesAutoresizingMaskIntoConstraints = false
        superview?.addConstraint(constraint)
    }
    
    /// Creates an NSLayoutConstraint using its factory method given both views, attributes a relation and offset
    fileprivate func createConstraint(attribute attr1: NSLayoutAttribute, toView: UIView?, attribute attr2: NSLayoutAttribute, relation: NSLayoutRelation, constant: CGFloat) -> NSLayoutConstraint {
        
        let constraint = NSLayoutConstraint(
            item: self,
            attribute: attr1,
            relatedBy: relation,
            toItem: toView,
            attribute: attr2,
            multiplier: 1.0,
            constant: constant)
        
        return constraint
    }
}


extension NSObject {
    var theClassName: String {
        return NSStringFromClass(type(of: self))
    }
}
