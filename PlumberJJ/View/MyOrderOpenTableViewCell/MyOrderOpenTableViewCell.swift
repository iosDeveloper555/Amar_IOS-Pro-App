//
//  MyOrderOpenTableViewCell.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 10/29/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class MyOrderOpenTableViewCell: UITableViewCell, SMSegmentViewDelegate{
 var segmentView: SMSegmentView!
    @IBOutlet weak var SegmentContactView: UIView!
    @IBOutlet weak var totalView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var segButton: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func loadMyOrderOpenTableCell(_ objOpenRec:NSString){
        if segmentView == nil{
            self.segmentView = SMSegmentView(frame: CGRect(x: 0, y: 0, width: SegmentContactView.frame.size.width, height: SegmentContactView.frame.size.height), separatorColour: PlumberLightGrayColor, separatorWidth: 1, segmentProperties: [keySegmentTitleFont: UIFont.boldSystemFont(ofSize: 12.0), keySegmentOnSelectionColour: UIColor.white, keySegmentOffSelectionColour: UIColor.white,keySegmentOffSelectionTextColour:PlumberThemeColor,keySegmentOnSelectionTextColour:PlumberThemeColor, keyContentVerticalMargin: Float(10.0) as AnyObject])
            
            self.segmentView.delegate = self
            
            self.segmentView.layer.cornerRadius = 5.0
            self.segmentView.layer.borderColor = PlumberLightGrayColor.cgColor
            self.segmentView.layer.borderWidth = 1.0
            
            // Add segments
            self.segmentView.addSegmentWithTitle(title: "Call", onSelectionImage: UIImage(named: ""), offSelectionImage: UIImage(named: ""))
            self.segmentView.addSegmentWithTitle(title: "Message", onSelectionImage: UIImage(named: ""), offSelectionImage: UIImage(named: ""))
            self.segmentView.addSegmentWithTitle(title: "Cancel", onSelectionImage: UIImage(named: ""), offSelectionImage: UIImage(named: ""))
            segButton.addSubview(self.segmentView)
        }
        userImageView.layer.cornerRadius=userImageView.frame.size.width/2;
        userImageView.layer.masksToBounds=true
        totalView.layer.shadowOffset = CGSize(width: 3, height: 3)
        SegmentContactView.layer.cornerRadius=5;
         totalView.layer.cornerRadius=5;
        totalView.layer.shadowOpacity = 0.4
        totalView.layer.shadowRadius = 2
       
    }
    // SMSegment Delegate
    func segmentView(segmentView: SMSegmentView, didSelectSegmentAtIndex index: Int) {
        switch (index){
        case 0:
            break
        case 1:
            break
        case 2:
            break
        default:
            break
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
