//
//  AddMaterialViewCell.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 7/24/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class AddMaterialViewCell: UITableViewCell {

    @IBOutlet weak var nameTxtFld: UITextField!
    @IBOutlet weak var costTxtFld: UITextField!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var currencyLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
