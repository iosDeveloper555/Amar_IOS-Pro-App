//
//  EditAvailabilityTableViewCell.swift
//  PlumberJJ
//
//  Created by Casperon iOS on 22/2/2017.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class EditAvailabilityTableViewCell: UITableViewCell {

    @IBOutlet var lbl1:UILabel!
    @IBOutlet var lbl2:UILabel!
    @IBOutlet var lbl3:UILabel!
    @IBOutlet var lbl4:UILabel!
    @IBOutlet var btn1:UIButton!
    @IBOutlet var btn2:UIButton!
    @IBOutlet var btn3:UIButton!

    @IBOutlet weak var DaysLbl: UILabel!
    @IBOutlet weak var TimeLbl: UILabel!
    @IBOutlet weak var AddorEditBtn: UIButton!
    
    
    var selectedBtn = NSMutableArray()
    
    override func awakeFromNib() {
        super.awakeFromNib()

        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
  

}
