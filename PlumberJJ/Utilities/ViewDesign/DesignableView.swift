//
//  Designable.swift
//  Bleat
//
//  Created by Apple on 13/03/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

@IBDesignable class DesignableView: UIView {

    
    
    @IBInspectable var cornerradious: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerradious;
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
