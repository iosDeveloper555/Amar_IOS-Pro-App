//
//  NotificationAlertViewBaseExtension.swift
//  NotificationPopupExample
//
//  Created by Andrey Pervushin on 27.10.15.
//  Copyright © 2015 Andrey Pervushin. All rights reserved.
//
import UIKit

extension NotificationAlertView {
    
    //Simple popup with text. Use hideAfterDelay property or outer action to hide
    
    static func popupWithText(_ text:String) -> NotificationAlertView{
        
        //-- Elements
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor.white
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = text
        label.textColor=PlumberThemeColor
        label.font=UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = NSTextAlignment.center
        label.numberOfLines = 0
        label.minimumScaleFactor = 0.3
        
        //-- UI relations
        
        view.addSubview(label)
        
        NotificationAlertView.addMarginConstraints(view, childView: label, margins: [0,0,0,0])
        
        return NotificationAlertView.popupWithView(view)
        
    }
    
    //Popup with text and Yes/No options. Use customCompletionHandler to get
    //presed option index (Yes:0 No:1)
    @available(iOS 9, *)
    static func popupWithQuestion(_ text:String) -> NotificationAlertView{
        
        //-- Elements
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 1)
        
        let icon = UILabel()
        
        icon.translatesAutoresizingMaskIntoConstraints = false
        
        icon.text = "?"
        
        icon.textColor = UIColor.lightGray
        
        icon.textAlignment = .center
        
        icon.numberOfLines = 0
        
        icon.layer.cornerRadius = 15
        
        icon.layer.borderWidth = 1
        
        icon.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = text
        
        icon.textColor = UIColor.gray
        
        label.textAlignment = .center
        
        label.numberOfLines = 0
        
        label.minimumScaleFactor = 0.3
        
        let panel = UIStackView()
        
        panel.translatesAutoresizingMaskIntoConstraints = false
        
        panel.axis = .vertical
        
        panel.distribution = .fillEqually
        
        panel.alignment = .fill
        
        var buttons = [UIButton]()
        
        var i = 0;
        for title in ["Yes", "No"] {
            
            let button = UIButton(type: .system)
            
            button.tag = i
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.setTitle(title, for: UIControl.State())
            
            panel.addArrangedSubview(button)
            
            buttons.append(button)
            
            i += 1
        }
        
        //-- UI relations
        
        view.addSubview(icon)
        
        view.addSubview(label)
        
        view.addSubview(panel)
        
        NotificationAlertView.addLeftIconConstraints(view, childView: icon, values: [5,30,30])
        
        NotificationAlertView.addMarginConstraints(view, childView: label, margins: [40,20,-80,0])
        
        NotificationAlertView.addHorizontalSnapConstraints(view, childView: panel, margins: [20,0], layoutAttribute: .right, width: 80)
        
        let tempPopup = NotificationAlertView.popupWithView(view)
        
        //-- Event Handlers
        
        for button in buttons{
            button.addTarget(tempPopup, action: "onDialogButtonAction:", for: .touchUpInside)
        }
        
        return tempPopup
    }
    
    
    //Popup with text and warious number of options. Use customCompletionHandler 
    //to get presed option index
    @available(iOS 9, *)
    static func popupDialogWithText(_ text:String, options:[String]) -> NotificationAlertView{
        
        //-- Elements
        
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.95, alpha: 1)
        
        let label = UILabel()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.text = text
        
        label.textAlignment = .center
        
        label.numberOfLines = 0
        
        label.minimumScaleFactor = 0.3
        
        let panel = UIStackView()
        
        panel.translatesAutoresizingMaskIntoConstraints = false
        
        panel.axis = .horizontal
        
        panel.distribution = .fillEqually
        
        panel.alignment = .fill
        
        var buttons = [UIButton]()
        
        var i = 0;
        for title in options {
            
            let button = UIButton(type: .system)
            
            button.tag = i
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            button.setTitle(title, for: UIControl.State())
            
            panel.addArrangedSubview(button)
            
            buttons.append(button)
            
            i += 1
        }
        
        //-- UI relations
        
        view.addSubview(panel)
        
        view.addSubview(label)
        
        NotificationAlertView.addVerticalSnapConstraints(view, childView: panel, layoutAttribute: .bottom, height: 35)
        
        NotificationAlertView.addMarginConstraints(view, childView: label, margins: [50,20,0,-35])
        
        
        let tempPopup = NotificationAlertView.popupWithView(view)
        
        //-- Event Handlers
        
        for button in buttons{
            button.addTarget(tempPopup, action: "onDialogButtonAction:", for: .touchUpInside)
        }
        
        return tempPopup
        
    }
    
    func onDialogButtonAction(_ button: UIButton){
        
        if let completion = self.customCompletionHandler{
            completion(button.tag)
        }
        
    }
    
    
    
    static func addLeftIconConstraints(_ superView:UIView, childView:UIView, values:[CGFloat]){
        
        childView.addConstraint(NSLayoutConstraint(item: childView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: values[1]))
        
        childView.addConstraint(NSLayoutConstraint(item: childView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: values[2]))
        
        superView.addConstraints([NSLayoutConstraint(item: childView, attribute: .leading, relatedBy: .equal, toItem: superView, attribute: .leading, multiplier: 1, constant: values[0]), NSLayoutConstraint(item: childView, attribute: .centerY, relatedBy: .equal, toItem: superView, attribute: .centerY, multiplier: 1, constant: 0)])
        
    }
    
    
    static func addVerticalSnapConstraints(_ superView:UIView, childView:UIView, layoutAttribute: NSLayoutConstraint.Attribute, height:CGFloat){
        
        childView.addConstraint(NSLayoutConstraint(item: childView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1,constant: height))
        
        superView.addConstraints([
            NSLayoutConstraint(
                item: childView,
                attribute: .leading,
                relatedBy: .equal,
                toItem: superView,
                attribute: .leading,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item: childView,
                attribute: .trailing,
                relatedBy: .equal,
                toItem: superView,
                attribute: .trailing,
                multiplier: 1,
                constant: 0),
            
            NSLayoutConstraint(
                item: childView,
                attribute: layoutAttribute,
                relatedBy: .equal,
                toItem: superView,
                attribute: layoutAttribute,
                multiplier: 1,
                constant: 0),
            
        ])
        
    }
    
    static func addMarginSizeConstraints(_ superView:UIView, childView:UIView, values:[CGFloat]){
        
        childView.addConstraint(NSLayoutConstraint(
                                    item: childView,
                                    attribute: NSLayoutConstraint.Attribute.width,
                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                    toItem: nil,
                                    attribute: .notAnAttribute,
                                    multiplier: 1,
                                    constant: values[2]))
        
        childView.addConstraint(NSLayoutConstraint(
                                    item: childView,
                                    attribute: NSLayoutConstraint.Attribute.height,
                                    relatedBy: NSLayoutConstraint.Relation.equal,
                                    toItem: nil,
                                    attribute: .notAnAttribute,
                                    multiplier: 1,
                                    constant: values[3]))
        
        superView.addConstraints([
            
            NSLayoutConstraint(
                item: childView,
                attribute: .left,
                relatedBy: .equal,
                toItem: superView,
                attribute: .left,
                multiplier: 1,
                constant: values[0]),
            NSLayoutConstraint(
                item: childView,
                attribute: .top,
                relatedBy: .equal,
                toItem: superView,
                attribute: .top,
                multiplier: 1,
                constant: values[1]),
            
        ])
        
    }
    
    static func addHorizontalSnapConstraints(_ superView:UIView, childView:UIView, margins:[CGFloat], layoutAttribute: NSLayoutConstraint.Attribute, width:CGFloat){
        
        childView.addConstraint(NSLayoutConstraint( item: childView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: width))
        
        superView.addConstraints([
            
            NSLayoutConstraint(
                item: childView,
                attribute: .top,
                relatedBy: .equal,
                toItem: superView,
                attribute: .top,
                multiplier: 1,
                constant: margins[0]),
            
            NSLayoutConstraint(
                item: childView,
                attribute: .bottom,
                relatedBy: .equal,
                toItem: superView,
                attribute: .bottom,
                multiplier: 1,
                constant: margins[1]),
            
            NSLayoutConstraint(
                item: childView,
                attribute: layoutAttribute,
                relatedBy: .equal,
                toItem: superView,
                attribute: layoutAttribute,
                multiplier: 1,
                constant: 0),
            
        ])
        
    }
    
    
    
}
