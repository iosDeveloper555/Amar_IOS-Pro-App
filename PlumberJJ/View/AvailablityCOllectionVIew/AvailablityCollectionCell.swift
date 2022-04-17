//
//  AvailablityCollectionCell.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 6/27/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit



class AvailablityCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var TimeIntervalView: UIView!
    @IBOutlet weak var TimeIntervalLabel: UILabel!
    @IBOutlet weak var timeIntervalBtn: UIButton!
    
    var cellSlotData = Slots(){
        didSet{
            setBackGround()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
      self.TimeIntervalLabel.adjustsFontSizeToFitWidth = true
        self.TimeIntervalLabel.minimumScaleFactor = 0.5
        self.TimeIntervalLabel.numberOfLines = 1
        self.TimeIntervalView.dropShadow(shadowRadius: 2)
        self.TimeIntervalView.layer.cornerRadius = 5
    }
    
    private func setBackGround(){
        TimeIntervalView.backgroundColor = cellSlotData.selected ? PlumberThemeColor : .white
        TimeIntervalLabel.textColor = cellSlotData.selected ? .white : .black
    }
    
    @IBAction func didClickTimeBtn(_ sender: UIButton) {
        cellSlotData.selected = !cellSlotData.selected
        setBackGround()
    }
}

