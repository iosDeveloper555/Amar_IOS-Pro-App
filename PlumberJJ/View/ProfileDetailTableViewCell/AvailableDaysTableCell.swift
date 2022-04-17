//
//  AvailableDaysTableCell.swift
//  PlumberJJ
//
//  Created by Casperon on 05/10/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

import UIKit

class AvailableDaysTableCell: UITableViewCell {

    @IBOutlet var evebtn: UIButton!
    @IBOutlet var afternbtn: UIButton!
    @IBOutlet var mrnbtn: UIButton!
    @IBOutlet var dayslable: UILabel!
    @IBOutlet var Morning: UILabel!
    @IBOutlet var afternoon: UILabel!
    @IBOutlet var Evning: UILabel!
    
    @IBOutlet weak var AvailNewView: UIView!
    @IBOutlet weak var DayLbl: UILabel!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var InnerViewHeight: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        DayLbl.textColor = PlumberThemeColor
        // Initialization code
    }

//    func loadProfileTableCell(_ objOpenRec:AvailableRecord){
//
//        dayslable.text=objOpenRec.AvailDays as String
//        Morning.text = objOpenRec.AvailMornigtime as String
//        afternoon.text = objOpenRec.AvailAftertime as String
//        Evning.text = objOpenRec.Availeveningtime as String
//
//
//
//        if objOpenRec.AvailMornigtime as String == "0"
//        {
//            mrnbtn.setImage(UIImage(named:"Delete-48"), for:UIControlState())
//
//        }
//        else
//        {
//            mrnbtn.setImage(UIImage(named:"tick"), for:UIControlState())
//
//        }
//        if  objOpenRec.AvailAftertime == "0"
//
//        {
//            afternbtn.setImage(UIImage(named:"Delete-48"), for:UIControlState())
//        }
//        else
//        {
//             afternbtn.setImage(UIImage(named:"tick"), for:UIControlState())
//        }
//
//      if  objOpenRec.Availeveningtime == "0"
//      {
//        evebtn.setImage(UIImage(named:"Delete-48"), for:UIControlState())
//      }
//        else
//       {
//         evebtn.setImage(UIImage(named:"tick"), for:UIControlState())
//        }
//
//
//
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
