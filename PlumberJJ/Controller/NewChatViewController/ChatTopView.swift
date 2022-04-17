//
//  ChatTopView.swift
//  GetDoctor partner
//
//  Created by Casperon iOS on 9/2/2017.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class ChatTopView: UIView {

    @IBOutlet weak var typingLabel: RSDotsView!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var backAction: UIButton!
    @IBOutlet weak var name: UILabel!
    @IBOutlet var onllineBtn: UIButton!
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

    

}
