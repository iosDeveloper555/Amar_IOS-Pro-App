//
//  StepTableViewCell.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/28/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class StepTableViewCell: UITableViewCell {
  @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var firstLbl: UILabel!
    @IBOutlet weak var lastLbl: UILabel!
     @IBOutlet weak var dateLbl: UILabel!
     @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var statusImgView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
     func loadStepTableCell(_ objOpenRec:StepByStepInfoRecord){
        descLbl.text=objOpenRec.title as String
        dateLbl.text=objOpenRec.date as String
         timeLbl.text=objOpenRec.Time as String
        if(objOpenRec.status=="1"){
            statusImgView.image=UIImage(named: "Checkmark")
        }else{
            statusImgView.image=UIImage(named: "UnselectTree")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
