//
//  invoicelistTableViewCell.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 7/16/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class invoicelistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statuslbl: UILabel!
    @IBOutlet weak var amountlbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
