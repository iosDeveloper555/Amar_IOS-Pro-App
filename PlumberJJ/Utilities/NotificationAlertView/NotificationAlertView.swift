//
//  NotificationAlertView.swift
//  com.rian.swift1
//
//  Created by Andrey Pervushin on 16.10.15.
//  Copyright © 2015 Andrey Pervushin. All rights reserved.
//

import UIKit

enum NotificationAlertViewPosition: Int {
    
    case top, bottom, custom
    
}

class NotificationAlertView: UIView {
    
    
    static var popup:NotificationAlertView?
    
    //May be used in custom popup extensions if you should send some response
    //based on some actions
    var customCompletionHandler:((Int) -> Void)?
    
    //Show/hide animation duration in seconds
    var animationDuration: CFTimeInterval = 0.5
    
    //If this value not equal to "0" popup will hide after specified time in 
    //seconds
    var hideAfterDelay: CGFloat = 0
    
    //View that is showing in popup, you may use it to get any properties from
    //your view. (Change it it on your own risk)
    var contentView: UIView?
    
    //Chage this to show popup from top or bottom
    var position: NotificationAlertViewPosition!{
        didSet{
            
            switch position! {
            case .top:
                self.addTopConstraint()
                return
                
            case .bottom:
                self.addBottomConstraint()
                return
                
            default:
                return
            }
        }
    }
    
    
    //Set the value that will be best for your project
    var height : CGFloat = 80 {

        didSet{
            
            if (self.heightConstraint != nil){
                
                self.heightConstraint!.constant = height
                
            }
        }
    }
    
    fileprivate var blurView: UIVisualEffectView?
    
    fileprivate var backgroundImageView = UIImageView.init()
    
    fileprivate var frontImageView = UIImageView.init()
    
    fileprivate var heightConstraint:NSLayoutConstraint?
    
    fileprivate var positionConstraint:NSLayoutConstraint?
    
    fileprivate var isOpen = false
    
    fileprivate var isShowing = false
    
    fileprivate var isHiding = false
    
    fileprivate var transformLayer: CATransformLayer?
    
    
    //Construct popup with any specified view. View will fit popup size however
    //be carefull with constraints specified in it
    static func popupWithView(_ view:UIView?) -> NotificationAlertView{
        
        //-- Elements
        
        let tempPopup = NotificationAlertView()
        
        tempPopup.contentView = view
        
        for c in tempPopup.contentView!.constraints {
            
            if ( c.firstAttribute == .height || c.firstAttribute == .width){
                
                tempPopup.contentView!.removeConstraint(c)
                
            }
            
        }
        
        tempPopup.isHidden = true
        
        tempPopup.translatesAutoresizingMaskIntoConstraints = false
        
        tempPopup.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        tempPopup.frontImageView.translatesAutoresizingMaskIntoConstraints = false
        
        tempPopup.transformLayer = CATransformLayer();
        
        //-- Blur View
        
        tempPopup.backgroundColor = UIColor.clear
        
        let blur = UIBlurEffect(style: UIBlurEffect.Style.light)
        
        tempPopup.blurView = UIVisualEffectView(effect: blur)
        
        tempPopup.blurView!.translatesAutoresizingMaskIntoConstraints = false
        
        //-- UI relations
        
        let root = UIApplication.shared.keyWindow!
        
        root.addSubview(tempPopup)
        
        tempPopup.addConstraintsToPopup()
        
        tempPopup.layer.addSublayer(tempPopup.transformLayer!)
        
        tempPopup.transformLayer!.addSublayer(tempPopup.backgroundImageView.layer)
        
        tempPopup.transformLayer!.addSublayer(tempPopup.frontImageView.layer)
        
        //-- Blur View
        
        tempPopup.superview!.addSubview(tempPopup.blurView!)
        
        tempPopup.superview!.insertSubview(tempPopup.blurView!, belowSubview: tempPopup)
        
        tempPopup.addBlurConstraints()
        
        return tempPopup
        
    }
    
    
    
    //Use it to show popup once it was constructed and hide previous
    func show(){
        
        
        if (self.contentView != nil){
            
            self.contentView!.removeFromSuperview()
            
            self.contentView!.translatesAutoresizingMaskIntoConstraints = false
            
            self.addSubview(self.contentView!)
            
            NotificationAlertView.addMarginConstraints(self, childView: self.contentView!, margins: [0,0,0,0])
            
        }
        
        self.setupCube()
        
        self.isShowing = true
        
        self.blurView!.isHidden = true
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(CGFloat(NSEC_PER_SEC) * 0.01)) / Double(NSEC_PER_SEC)) { () -> Void in
            
            self.captureBackground()
            
            self.blurView!.isHidden = false
            
            self.isHidden = false
            
            self.contentView!.isHidden = false
            
            self.captureFront()
            
            self.contentView!.isHidden = true
            
            NotificationAlertView.hideAnimated(false)
            
            NotificationAlertView.updatePopup(self)
            
            CATransaction.begin();
            
            CATransaction.setCompletionBlock({
                
                self.contentView!.isHidden = false
                
                self.isOpen = true
                
                self.isShowing = false
                
                if (self.hideAfterDelay > 0){
                    
                    let t = Int64(CGFloat(NSEC_PER_SEC) * self.hideAfterDelay + CGFloat(self.animationDuration))
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(t) / Double(NSEC_PER_SEC), execute: {
                        
                        self.isHiding = true
                        self.hideWithCompletion(nil)
                        
                    })
                    
                }
            })
            
            CATransaction.setAnimationDuration(self.animationDuration);
            
            self.transformLayer!.transform = CATransform3DRotate(self.transformLayer!.transform, .pi/2, 1, 0, 0)
            
            CATransaction.commit();
            
        }
  
    }
    
    //Currently showed popup will be hiden
    static func hideAnimated(_ animated:Bool){
        
        if (animated){
            
            if (popup != nil){
                
                if (popup!.isHiding || popup!.isShowing){
                    return
                }
                
                popup!.isHiding = true
                
                popup!.hideWithCompletion(nil)
                
            }
            
        }else{
            
            if (popup != nil){
                popup!.removeFromSuperview()
            }
            
        }
        
    }
    
    func hideWithCompletion(_ completion: (() -> Void)?){
        
        self.captureFront()
        
        self.contentView!.removeFromSuperview()
        
        self.isHidden = true
        
        self.blurView!.isHidden = true
        
        self.captureBackground()
        
        self.blurView!.isHidden = false
        
        self.isHidden = false
        
        CATransaction.begin()
        
        CATransaction.setCompletionBlock({ () -> Void in
            
            self.isOpen = false
            
            self.isHiding = false
            
            self.removeFromSuperview()
            
            if (completion != nil){
                completion!()
            }
            
        })
        
        CATransaction.setAnimationDuration(self.animationDuration)
        
        self.transformLayer!.transform = CATransform3DRotate(self.transformLayer!.transform, -.pi/2, 1, 0, 0);
        
        CATransaction.commit()
        
    }
    
    static func addMarginConstraints(_ superView:UIView, childView:UIView, margins:[CGFloat]){
        
        superView.addConstraints([
            
            NSLayoutConstraint(
                item: childView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: superView,
                attribute: .leading,
                multiplier: 1,
                constant: margins[0]),
            
            NSLayoutConstraint(
                item: childView,
                attribute: .top,
                relatedBy: .equal,
                toItem: superView,
                attribute: .top,
                multiplier: 1,
                constant: margins[1]),
            
            NSLayoutConstraint(
                item: childView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: superView,
                attribute: .trailing,
                multiplier: 1,
                constant: margins[2]),
            
            NSLayoutConstraint(
                item: childView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: superView,
                attribute: .bottom,
                multiplier: 1,
                constant: margins[3])
            
            ])
        
    }
    
    
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        self.backgroundImageView.layer.frame = self.bounds
        
        self.frontImageView.layer.frame = self.bounds
    }
    
    fileprivate func setupCube(){
        
        var pt = CATransform3DIdentity;
        pt.m34 = -1.0 / 300.0;
        self.layer.sublayerTransform = pt;
        
        let front = self.frontImageView.layer
        
        let background = self.backgroundImageView.layer
        
        front.transform = CATransform3DTranslate(front.transform, 0, 0, 0);
        
        front.transform = CATransform3DRotate(front.transform, -.pi/2, 1, 0, 0);
        
        background.transform = CATransform3DTranslate(background.transform, 0, -self.height/2.0, self.height/2.0);
        
        self.transformLayer!.transform = CATransform3DTranslate(self.layer.transform, 0, self.height/2.0, -self.height/2.0);
        
    }
    
    fileprivate static func updatePopup(_ popupView:NotificationAlertView){
        
        popup = popupView;
        
    }
    
    fileprivate func captureBackground(){
        
        let layer = UIApplication.shared.keyWindow!.layer
        
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: layer.frame.size.width, height: self.height), false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.concatenate(CGAffineTransform(translationX: 0, y: -self.frame.origin.y))
        
        layer.render(in: context)
        
        self.backgroundImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext();
        
        
    }
    
    fileprivate func captureFront(){
        
        let layer = UIApplication.shared.keyWindow!.layer
        
        let scale = UIScreen.main.scale
        
        UIGraphicsBeginImageContextWithOptions(CGSize(width: layer.frame.size.width, height: self.height), false, scale)
        
        let context = UIGraphicsGetCurrentContext()!
        
        self.contentView!.layer.render(in: context);
        
        self.frontImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
    }
    
    
    fileprivate func addConstraintsToPopup(){
        
        self.heightConstraint = NSLayoutConstraint(
            item: self,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: self.height)
        
        self.addConstraint(self.heightConstraint!)
        
        self.superview!.addConstraints([
            
            NSLayoutConstraint(
                item: self,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self.superview,
                attribute: .leading,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item: self,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self.superview,
                attribute: .trailing,
                multiplier: 1,
                constant: 0),
            
            ])
        
        self.addTopConstraint()
        
    }
    
    fileprivate func addTopConstraint(){
        
        if (self.positionConstraint != nil){
            self.superview!.removeConstraint(self.positionConstraint!)
        }
        
        self.positionConstraint = NSLayoutConstraint(
            item: self,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.superview,
            attribute: .top,
            multiplier: 1,
            constant: 0)
        
        self.superview!.addConstraint(self.positionConstraint!)
        
    }
    
    fileprivate func addBottomConstraint(){
        
        if (self.positionConstraint != nil){
            self.superview!.removeConstraint(self.positionConstraint!)
        }
        
        self.positionConstraint = NSLayoutConstraint(
            item: self,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.superview,
            attribute: .bottom,
            multiplier: 1,
            constant: 0)
        
        self.superview!.addConstraint(self.positionConstraint!)
        
    }
    
    fileprivate func addBlurConstraints(){
        
        superview!.addConstraints([
            
            NSLayoutConstraint(
                item: self.blurView!,
                attribute: .leading,
                relatedBy: .equal,
                toItem: self,
                attribute: .leading,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item: self.blurView!,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: self,
                attribute: .trailing,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item: self.blurView!,
                attribute: .top,
                relatedBy: .equal,
                toItem: self,
                attribute: .top,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item: self.blurView!,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: self,
                attribute: .bottom,
                multiplier: 1,
                constant: 0)
            
            ])
    }
    
}
