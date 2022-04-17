//
//  NoDataView.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/23/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class NoDataView: UIView {

    @IBOutlet weak var tipsLbl: UILabel!
    @IBOutlet weak var msgLbl: UILabel!
      @IBOutlet weak var refreshLbl: UILabel!
    
    override func awakeFromNib() {
        tipsLbl.text="\(Language_handler.VJLocalizedString("tips", comment: nil))\n \(Language_handler.VJLocalizedString("tips_1", comment: nil)) \(Language_handler.VJLocalizedString("app_name", comment: nil))"
        tipsLbl.isHidden = true
        msgLbl.text = Language_handler.VJLocalizedString("no_data_leads", comment: nil)
        refreshLbl.text = Language_handler.VJLocalizedString("pull_to_refresh", comment: nil)
    }

}
