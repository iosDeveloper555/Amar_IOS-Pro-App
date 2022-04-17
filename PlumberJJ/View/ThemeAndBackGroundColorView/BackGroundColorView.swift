//
//  BackGroundColorView.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 10/28/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class BackGroundColorView: UIView {
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.backgroundColor = PlumberBackGroundColor
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
