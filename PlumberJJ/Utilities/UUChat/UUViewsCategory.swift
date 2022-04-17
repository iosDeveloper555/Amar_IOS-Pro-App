//
//  UUViewsCategory.swift
//  UUChatTableViewSwift
//
//  Created by 杨志平 on 11/24/15.
//  Copyright © 2015 XcodeYang. All rights reserved.
//

import UIKit


// find VC
extension UIView {
    
    func responderViewController() -> UIViewController {
        var responder: UIResponder! = nil
//        for var next = self.superview; (next != nil); next = next!.superview {
//            responder = next?.next
//            if (responder!.isKind(of: UIViewController.self)){
//                return (responder as! UIViewController)
//            }
//        }
        return (responder as! UIViewController)
    }
}


extension UIScrollView {
    
    func scrollToBottom(animation:Bool) {
        let visibleBottomRect = CGRect(x: 0, y: contentSize.height-bounds.size.height, width: 1, height: bounds.size.height)
        UIView.animate(withDuration: animation ? 0.2 : 0.01, animations: { () -> Void in
            self.scrollRectToVisible(visibleBottomRect, animated: true)
        }) 
    }
}
