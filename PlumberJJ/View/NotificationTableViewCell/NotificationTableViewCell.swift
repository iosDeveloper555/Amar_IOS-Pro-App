//
//  NotificationTableViewCell.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/3/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {

    @IBOutlet weak var newImg: UIImageView!
    @IBOutlet weak var detailLbl: UILabel!
    @IBOutlet weak var timeLbl: SMIconLabel!
    @IBOutlet weak var userImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        // Initialization code
    }
    func loadNotificationTableCell(_ objOpenRec:NSString){
        userImgView.layer.cornerRadius=userImgView.frame.size.width/2
        userImgView.layer.masksToBounds=true
        timeLbl.icon = UIImage(named: "Timer")
        timeLbl.iconPadding = 5
        timeLbl.iconPosition = SMIconLabelPosition.left
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
