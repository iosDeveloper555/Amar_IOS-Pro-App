//
//  MaterialCell.swift
//  PlumberJJ
//
//  Created by Casperon on 15/03/17.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class MaterialCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        setPadding()
    }
    @IBOutlet var toolrent: UITextField!
    @IBOutlet var addfieldbtn: UIButton!
    @IBOutlet var toolname: UITextField!
    @IBOutlet var cancelbtn: UIButton!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPadding(){
           }
    
}
