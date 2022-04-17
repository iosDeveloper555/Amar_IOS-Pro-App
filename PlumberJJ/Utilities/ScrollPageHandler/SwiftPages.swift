//
//  SwiftPages.swift
//  SwiftPages
//
//  Created by Gabriel Alvarado on 6/27/15.
//  Copyright (c) 2015 Gabriel Alvarado. All rights reserved.
//

import UIKit

open class SwiftPages: UIView, UIScrollViewDelegate {
    
    //Items variables
    fileprivate var containerView: UIView!
    fileprivate var scrollView: UIScrollView!
    fileprivate var topBar: UIView!
    fileprivate var animatedBar: UIView!
    fileprivate var viewControllerIDs: [String] = []
    fileprivate var buttonTitles: [String] = []
    fileprivate var buttonImages: [UIImage] = []
    fileprivate var pageViews: [UIViewController?] = []
    
    //Container view position variables
    fileprivate var xOrigin: CGFloat = 0
    fileprivate var yOrigin: CGFloat = 0
    fileprivate var distanceToBottom: CGFloat = 0
    
    //Color variables
    fileprivate var animatedBarColor = UIColor(red: 28/255, green: 95/255, blue: 185/255, alpha: 1)
    fileprivate var topBarBackground = UIColor.white
    fileprivate var buttonsTextColor = UIColor.gray
    fileprivate var containerViewBackground = UIColor.white
    
    //Item size variables
    fileprivate var topBarHeight: CGFloat = 52
    fileprivate var animatedBarHeight: CGFloat = 3
    
    //Bar item variables
    fileprivate var aeroEffectInTopBar: Bool = false //This gives the top bap a blurred effect, also overlayes the it over the VC's
    fileprivate var buttonsWithImages: Bool = false
    fileprivate var barShadow: Bool = true
    fileprivate var buttonsTextFontAndSize: UIFont = UIFont.boldSystemFont(ofSize: 14)
    
    // MARK: - Positions Of The Container View API -
    open func setOriginX (_ origin : CGFloat) { xOrigin = origin }
    open func setOriginY (_ origin : CGFloat) { yOrigin = origin }
    open func setDistanceToBottom (_ distance : CGFloat) { distanceToBottom = distance }
    
    // MARK: - API's -
    open func setAnimatedBarColor (_ color : UIColor) { animatedBarColor = color }
    open func setTopBarBackground (_ color : UIColor) { topBarBackground = color }
    open func setButtonsTextColor (_ color : UIColor) { buttonsTextColor = color }
    open func setContainerViewBackground (_ color : UIColor) { containerViewBackground = color }
    open func setTopBarHeight (_ pointSize : CGFloat) { topBarHeight = pointSize}
    open func setAnimatedBarHeight (_ pointSize : CGFloat) { animatedBarHeight = pointSize}
    open func setButtonsTextFontAndSize (_ fontAndSize : UIFont) { buttonsTextFontAndSize = fontAndSize}
    open func enableAeroEffectInTopBar (_ boolValue : Bool) { aeroEffectInTopBar = boolValue}
    open func enableButtonsWithImages (_ boolValue : Bool) { buttonsWithImages = boolValue}
    open func enableBarShadow (_ boolValue : Bool) { barShadow = boolValue}
    
    override open func draw(_ rect: CGRect)
    {
        // MARK: - Size Of The Container View -
        let pagesContainerHeight = self.frame.height - yOrigin - distanceToBottom
        let pagesContainerWidth = self.frame.width
        
        //Set the containerView, every item is constructed relative to this view
        containerView = UIView(frame: CGRect(x: xOrigin, y: yOrigin, width: pagesContainerWidth, height: pagesContainerHeight))
        containerView.backgroundColor = containerViewBackground
        self.addSubview(containerView)
        
        //Set the scrollview
        if (aeroEffectInTopBar) {
            scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: containerView.frame.size.height))
        } else {
            scrollView = UIScrollView(frame: CGRect(x: 0, y: topBarHeight, width: containerView.frame.size.width, height: containerView.frame.size.height - topBarHeight))
        }
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.clear
        containerView.addSubview(scrollView)
        trackingDetail.selectedPage = 0
        
        //Set the top bar
        topBar = UIView(frame: CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: topBarHeight))
        topBar.backgroundColor = topBarBackground
        if (aeroEffectInTopBar) {
            //Create the blurred visual effect
            //You can choose between ExtraLight, Light and Dark
            topBar.backgroundColor = UIColor.clear
            let blurEffect: UIBlurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
            let blurView = UIVisualEffectView(effect: blurEffect)
            blurView.frame = topBar.bounds
            blurView.translatesAutoresizingMaskIntoConstraints = false
            topBar.addSubview(blurView)
        }
        containerView.addSubview(topBar)
        
        //Set the top bar buttons
        var buttonsXPosition: CGFloat = 0
        var buttonNumber = 0
        //Check to see if the top bar will be created with images ot text
        if (!buttonsWithImages) {
            for item in buttonTitles
            {
                
                var barLabel: UILabel!
                barLabel = UILabel(frame: CGRect(x: 0, y: 0, width: containerView.frame.size.width/(CGFloat)(viewControllerIDs.count), height: topBarHeight))
                print(barLabel.frame)
                barLabel.backgroundColor = UIColor.clear
                barLabel.font = buttonsTextFontAndSize
                barLabel.text = (buttonTitles[buttonNumber])
                barLabel.textAlignment = .center
                barLabel.textColor = buttonsTextColor
                barLabel.numberOfLines = 2
                
                var barButton: UIButton!
                barButton = UIButton(frame: CGRect(x: buttonsXPosition, y: 0, width: containerView.frame.size.width/(CGFloat)(viewControllerIDs.count), height: topBarHeight))
                barButton.backgroundColor = UIColor.clear
                barButton.tag = buttonNumber
                barButton.addTarget(self, action: #selector(SwiftPages.barButtonAction(_:)), for: UIControl.Event.touchUpInside)
                topBar.addSubview(barButton)
                barButton.addSubview(barLabel)
                
                
                buttonsXPosition = containerView.frame.size.width/(CGFloat)(viewControllerIDs.count) + buttonsXPosition
                buttonNumber += 1
                
            }
        } else {
            for item in buttonImages
            {
                var barButton: UIButton!
                barButton = UIButton(frame: CGRect(x: buttonsXPosition, y: 0, width: containerView.frame.size.width/(CGFloat)(viewControllerIDs.count), height: topBarHeight))
                barButton.backgroundColor = UIColor.clear
                barButton.imageView?.contentMode = UIView.ContentMode.scaleAspectFit
                barButton.setImage(item, for: UIControl.State())
                barButton.tag = buttonNumber
                barButton.addTarget(self, action: #selector(SwiftPages.barButtonAction(_:)), for: UIControl.Event.touchUpInside)
                topBar.addSubview(barButton)
                buttonsXPosition = containerView.frame.size.width/(CGFloat)(viewControllerIDs.count) + buttonsXPosition
                buttonNumber += 1
            }
        }
        
        
        //Set up the animated UIView
        animatedBar = UIView(frame: CGRect(x: 0, y: topBarHeight - animatedBarHeight + 1, width: (containerView.frame.size.width/(CGFloat)(viewControllerIDs.count))*0.8, height: animatedBarHeight))
        animatedBar.center.x = containerView.frame.size.width/(CGFloat)(viewControllerIDs.count * 2)
        animatedBar.backgroundColor = animatedBarColor
        containerView.addSubview(animatedBar)
        
        //Add the bar shadow (set to true or false with the barShadow var)
        if (barShadow) {
            let shadowView = UIView(frame: CGRect(x: 0, y: topBarHeight, width: containerView.frame.size.width, height: 4))
            let gradient: CAGradientLayer = CAGradientLayer()
            gradient.frame = shadowView.bounds
            gradient.colors = [UIColor(red: 150/255, green: 150/255, blue: 150/255, alpha: 0.28).cgColor, UIColor.clear.cgColor]
            shadowView.layer.insertSublayer(gradient, at: 0)
            containerView.addSubview(shadowView)
        }
        
        let pageCount = viewControllerIDs.count
        
        //Fill the array containing the VC instances with nil objects as placeholders
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        //Defining the content size of the scrollview
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(pageCount),
                                        height: pagesScrollViewSize.height)
        
        //Load the pages to show initially
        loadVisiblePages()
    }
    
    // MARK: - Initialization Functions -
    open func initializeWithVCIDsArrayAndButtonTitlesArray (_ VCIDsArray: [String], buttonTitlesArray: [String])
    {
        //Important - Titles Array must Have The Same Number Of Items As The viewControllerIDs Array
        if VCIDsArray.count == buttonTitlesArray.count {
            viewControllerIDs = VCIDsArray
            buttonTitles = buttonTitlesArray
            buttonsWithImages = false
        } else {
            print("Initilization failed, the VC ID array count does not match the button titles array count.")
        }
    }
    
    open func initializeWithVCIDsArrayAndButtonImagesArray (_ VCIDsArray: [String], buttonImagesArray: [UIImage])
    {
        //Important - Images Array must Have The Same Number Of Items As The viewControllerIDs Array
        if VCIDsArray.count == buttonImagesArray.count {
            viewControllerIDs = VCIDsArray
            buttonImages = buttonImagesArray
            buttonsWithImages = true
        } else {
            print("Initilization failed, the VC ID array count does not match the button images array count.")
        }
    }
    
    open func loadPage(_ page: Int)
    {
        if page < 0 || page >= viewControllerIDs.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        //Use optional binding to check if the view has already been loaded
        if pageViews[page] != nil
        {
            if page  == trackingDetail.selectedPage
            {
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            //Create the variable that will hold the VC being load
            var newPageView: UIViewController
            
            //Look for the VC by its identifier in the storyboard and add it to the scrollview
            newPageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewControllerIDs[page])
            newPageView.view.frame = frame
            scrollView.addSubview(newPageView.view)
            
            //Replace the nil in the pageViews array with the VC just created
            pageViews[page] = newPageView
            }
            // Do nothing. The view is already loaded.
        } else
        {
            print("Loading Page \(page)")
            //The pageView instance is nil, create the page
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            //Create the variable that will hold the VC being load
            var newPageView: UIViewController
            
            //Look for the VC by its identifier in the storyboard and add it to the scrollview
            newPageView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: viewControllerIDs[page])
            newPageView.view.frame = frame
            scrollView.addSubview(newPageView.view)
            
            //Replace the nil in the pageViews array with the VC just created
            pageViews[page] = newPageView
        }
    }
    
    open func loadVisiblePages()
    {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
    }
    
    @objc open func barButtonAction(_ sender: UIButton?)
    {
        let index: Int = sender!.tag
        trackingDetail.selectedPage = index
        
        let pagesScrollViewSize = scrollView.frame.size
        [scrollView .setContentOffset(CGPoint(x: pagesScrollViewSize.width * (CGFloat)(index), y: 0), animated: true)]
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
        // Load the pages that are now on screen
        loadVisiblePages()
        
        //The calculations for the animated bar's movements
        //The offset addition is based on the width of the animated bar (button width times 0.8)
        let offsetAddition = (containerView.frame.size.width/(CGFloat)(viewControllerIDs.count))*0.1
        animatedBar.frame = CGRect(x: (offsetAddition + (scrollView.contentOffset.x/(CGFloat)(viewControllerIDs.count))), y: animatedBar.frame.origin.y, width: animatedBar.frame.size.width, height: animatedBar.frame.size.height);
    }
    
}

