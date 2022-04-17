//
//  ButtonColorView.swift
//  PlumberJJ
//
//  Created by Aravind Natarajan on 30/12/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class ButtonColorView: UIButton {
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.backgroundColor = PlumberThemeColor
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
