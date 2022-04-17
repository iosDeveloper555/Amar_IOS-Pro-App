//
//  BarChartCollectionViewCell.swift
//  DriverReadyToEat
//
//  Created by Casperon iOS on 14/08/19.
//  Copyright © 2019 CasperonTechnologies. All rights reserved.
//

import UIKit

class BarChartCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var monthLbl: UILabel!
    @IBOutlet weak var barView: UIView!
    @IBOutlet weak var barViewLeading: NSLayoutConstraint!
    @IBOutlet weak var barViewBottom: NSLayoutConstraint!
    @IBOutlet weak var barViewHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         DispatchQueue.main.async {
            
//            self.baseView.frame = self.bounds
        }
    }

    
}
