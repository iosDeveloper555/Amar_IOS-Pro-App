//
//  SMIconLabel.swift
//  SMIconLabel
//
//  Created by Anatoliy Voropay on 5/19/15.
//  Copyright (c) 2015 Smartarium.com. All rights reserved.
//

import UIKit

public enum SMIconLabelPosition {
    case left, right
}

open class SMIconLabel: UILabel {
    
    /** Image that will be placed with a text*/
    open var icon: UIImage?
    
    /** Position of an image */
    open var iconPosition: SMIconLabelPosition = .left
    
    /** Additional spacing between text and image */
    open var iconPadding: CGFloat = 0
    
    // MARK: Privates
    
    fileprivate var iconView: UIImageView?
    
    // MARK: Custom text drawings
    
    open override func drawText(in rect: CGRect) {
        if numberOfLines != 1 || icon == nil {
            super.drawText(in: rect)
            return
        }
        
        if let icon = icon {
            iconView?.removeFromSuperview()
            iconView = UIImageView(image: icon)
            
            var newRect: CGRect = CGRect.zero
            var size: CGSize = frame.size
            
            if let text = self.text as NSString? {
                size = text.boundingRect(with: CGSize(width: frame.width, height: frame.height),
                    options: NSStringDrawingOptions.usesLineFragmentOrigin,
                    attributes: [ NSAttributedString.Key.font : font ],
                    context: nil).size
            }
            
            if let iconView = iconView {
                if iconPosition == .left {
                    if textAlignment == .left {
                        iconView.frame = iconView.frame.offsetBy(dx: 0, dy: (frame.height - iconView.frame.height) / 2)
                        newRect = CGRect(x: iconView.frame.width + iconPadding, y: 0, width: frame.width - (iconView.frame.width + iconPadding), height: frame.height)
                    } else if textAlignment == .right {
                        iconView.frame = iconView.frame.offsetBy(dx: frame.width - size.width - iconView.frame.width - iconPadding, dy: (frame.height - iconView.frame.height) / 2)
                        newRect = CGRect(x: frame.width - size.width - iconPadding, y: 0, width: size.width + iconPadding, height: frame.height)
                    } else if textAlignment == .center {
                        iconView.frame = iconView.frame.offsetBy(dx: (frame.width - size.width) / 2 - iconPadding - iconView.frame.width, dy: (frame.height - iconView.frame.height) / 2)
                        newRect = CGRect(x: (frame.width - size.width) / 2, y: 0, width: size.width + iconPadding, height: frame.height)
                    }
                } else if iconPosition == .right {
                    if textAlignment == .left {
                        iconView.frame = iconView.frame.offsetBy(dx: size.width + iconPadding, dy: (frame.height - iconView.frame.height) / 2)
                        newRect = CGRect(x: 0, y: 0, width: frame.width - frame.width, height: frame.height)
                    } else if textAlignment == .right {
                        iconView.frame = iconView.frame.offsetBy(dx: frame.width - iconView.frame.width, dy: (frame.height - iconView.frame.height) / 2)
                        newRect = CGRect(x: frame.width - size.width - iconView.frame.width - iconPadding, y: 0, width: size.width, height: frame.height)
                    } else if textAlignment == .center {
                        iconView.frame = iconView.frame.offsetBy(dx: frame.width / 2 + size.width / 2 + iconPadding, dy: (frame.height - iconView.frame.height) / 2)
                        newRect = CGRect(x: (frame.width - size.width) / 2, y: 0, width: size.width, height: frame.height)
                    }
                }
                
                addSubview(iconView)
                super.drawText(in: newRect)
            }
            
        }
    }
    
}
