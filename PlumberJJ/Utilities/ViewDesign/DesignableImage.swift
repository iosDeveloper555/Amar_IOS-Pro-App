//
//  Designable.swift
//  Bleat
//
//  Created by Apple on 13/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

@IBDesignable class DesignableImage: UIImageView {
    
    @IBInspectable var borderWidth: CGFloat = 0.0{
        didSet{
            self.layer.borderWidth = borderWidth;
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear{
        didSet{
            self.layer.borderColor = borderColor.cgColor;
        }
    }
    @IBInspectable var cornerradious: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerradious;
        }
    }
    @IBInspectable var rounded: Bool = false {
        didSet {
            updateCornerRadius()
        }
    }
    
    func updateCornerRadius() {
        layer.cornerRadius = rounded ? frame.size.height / 2 : 0
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
