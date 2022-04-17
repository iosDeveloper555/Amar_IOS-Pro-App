//
//  newleadsxibTableViewCell.swift
//  PlumberJJ
//
//  Created by Casperon iOS on 16/09/17.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class newleadsxibTableViewCell: UITableViewCell {

    let deleteIndex:IndexPath=IndexPath()
    
    @IBOutlet var statuslabl: UILabel!
    
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var orderIdLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var catgLbl: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var totalView: UIView!
    var theme : Theme = Theme()
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var user_name_img: UIImageView!
    @IBOutlet weak var booking_timer_Img: UIImageView!
    @IBOutlet weak var my_location_Img: UIImageView!
    
    func loadMyOrderNewLeadTableCell(_ objOpenRec:MyOrderOpenRecord){
        /*deleteBtn.layer.cornerRadius=deleteBtn.frame.size.width/2;
         deleteBtn.layer.borderWidth=1
         deleteBtn.layer.borderColor=PlumberThemeColor.cgColor
         deleteBtn.layer.masksToBounds=true*/
        
        self.user_name_img.tintColor = .gray
        self.booking_timer_Img.tintColor = .gray
        self.my_location_Img.tintColor = .gray
        
        userImgView.layer.cornerRadius = userImgView.frame.size.width / 2;
        userImgView.backgroundColor = UIColor.lightGray
        userImgView.clipsToBounds=true
        userImgView.layer.masksToBounds = true;
        userImgView.layer.borderWidth = 0;
        userImgView.contentMode = UIView.ContentMode.scaleAspectFill
        userImgView.layer.borderWidth=2.0
        userImgView.layer.borderColor=UIColor.white.cgColor
        totalView.layer.shadowOffset = CGSize(width: 2, height: 2)
        //totalView.layer.cornerRadius=14;
        totalView.layer.cornerRadius = 6.0
        totalView.layer.masksToBounds = true
        totalView.layer.shadowOpacity = 0.2
        totalView.layer.shadowRadius = 2
        //        nameLbl.adjustsFontSizeToFitWidth = true
        //        orderIdLbl.adjustsFontSizeToFitWidth = true
        orderIdLbl.text="\(theme.setLang("Booking_Id")) : \(objOpenRec.orderId)"
        let dateStr = "\(objOpenRec.postedOn)"
        dateLbl.text = dateStr
//        var GetDateArr :NSArray = dateStr.componentsSeparatedByString(",")
//        if GetDateArr.count > 0
//        {
//            
//            dateLbl.text="\(self.theme.CheckNullValue(GetDateArr.objectAtIndex(0))!)"
//            timelabel.text = "\(self.theme.CheckNullValue(GetDateArr.objectAtIndex(1))!)"
//        }
        
        NSLog("Get Date array=%@", objOpenRec.userLoc)
        
        nameLbl.text="\(objOpenRec.UserName)"
        catgLbl.text="\(objOpenRec.userCatg)"
        locationLbl.text="\(objOpenRec.userLoc)"

        statuslabl.text="\(objOpenRec.orderstatus)"
        
        userImgView.sd_setImage(with: URL(string:objOpenRec.userImg), placeholderImage: UIImage(named: "PlaceHolderSmall"))
        
        if(objOpenRec.orderstatus  == "Confirmed")
        {
            statuslabl.textColor = UIColor.purple
        }
            
        else if(objOpenRec.orderstatus == "Completed")
        {
            statuslabl.textColor=UIColor.green
            // 0.0, 1.0, and 0.0 and whose alpha value is 1.0.
        }
            
        else if(objOpenRec.orderstatus == "Cancelled")
        {
            statuslabl.textColor=UIColor.red
            // 1.0, 0.0, and 0.0 and whose alpha value is 1.0.
        }
            
        else  if(objOpenRec.orderstatus == "Closed")
        {
            statuslabl.textColor=UIColor(red: 34.0/2555.0, green: 139/255.0, blue: 34/255.0, alpha: 1.0)
        }
        else
        {
            statuslabl.textColor=UIColor.orange
        }
        
    }
    @IBAction func didClickDeleteBtn(_ sender: AnyObject) {
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

    
}
