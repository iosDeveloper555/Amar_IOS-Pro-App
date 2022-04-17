//
//  UploadDocCell.swift
//  PlumberJJ
//
//  Created by Gokul's Mac Mini on 28/11/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class UploadDocCell: UITableViewCell {
    
    @IBOutlet weak var DocumentTitle: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var UploadImgBtn: UIButton!
    @IBOutlet weak var uploadDocImg: UIImageView!
    @IBOutlet weak var uploadPictureLbl: UILabel!
    @IBOutlet weak var txtExpiryDate : UITextField!
    @IBOutlet weak var btnSelectDate: UIButton!
    
    
    
    //MARK:- Variable's
    
    var DocumentsArray = [Any]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cardView.layer.borderWidth = 1
    }
    
    func PassCOuntData(count : Int){
        //        Count = count
        //        self.DocCollectionView.reloadData()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
