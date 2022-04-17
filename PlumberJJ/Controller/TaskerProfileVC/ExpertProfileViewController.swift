//
//  ExpertProfileViewController.swift
//  PlumberJJ
//
//  Created by CasperoniOS on 06/08/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class ExpertProfileViewController: RootBaseViewController,LoadProfileDatas {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var profileBorderView: UIView!
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var ratingView: SetColorView!
    @IBOutlet weak var ratingLbl: UILabel!
    @IBOutlet weak var taskernameLbl: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var taskerinfoLbl: UILabel!
    @IBOutlet weak var hiremeLbl: UILabel!
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var availabilityLbl: UILabel!
    @IBOutlet weak var availTbl: UITableView!
    @IBOutlet weak var descriptionView: UIView!
    
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var avaiHeight: NSLayoutConstraint!
    @IBOutlet weak var descheight: NSLayoutConstraint!
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var ProfilePageScrollView: UIScrollView!
    
    var colorsArr = [#colorLiteral(red: 0.08235294118, green: 0.7490196078, blue: 0.8156862745, alpha: 1),#colorLiteral(red: 0.3254901961, green: 0.6509803922, blue: 0.2431372549, alpha: 1),#colorLiteral(red: 0.9058823529, green: 0.3960784314, blue: 0.1803921569, alpha: 1)]
    var imageArr = [#imageLiteral(resourceName: "catDesign1"),#imageLiteral(resourceName: "catDesign2"),]
    var ObjAvailArray = [AvailableRec]()
    var AboutArray = [Any]()
    var DescriptionStr = String()
    var CategoryArray = [categoryModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.theme.yesTheDeviceisHavingNotch(){
            HeaderViewHeight.constant = 100
        }
        self.ProfilePageScrollView.isHidden = true
//        self.profileBorderView.setView(cornerRadius:self.profileBorderView.frame.size.height/2, Bgcolor: UIColor.white, titleColor:UIColor.black)
        self.profileImg.setView(cornerRadius:self.profileImg.frame.size.height/2, Bgcolor: UIColor.white, titleColor:UIColor.black)
        self.profileBorderView.layer.cornerRadius = self.profileBorderView.frame.size.height/2
        self.profileBorderView.dropShadow(shadowRadius:6)
        self.ratingView.setView(cornerRadius:self.ratingView.frame.size.height/2 , Bgcolor: UIColor.white, titleColor: UIColor.black)
        self.profileImg.layer.borderWidth = 2.0
        self.profileImg.layer.borderColor = PlumberThemeColor.cgColor
        availTbl.register(UINib(nibName:"AvailableDaysTableCell", bundle: nil), forCellReuseIdentifier: "availabledayscell")
        availTbl.estimatedRowHeight = 75
        availTbl.rowHeight = UITableView.automaticDimension
        availTbl.tableFooterView  = UIView()
        self.backBtn.tintColor = PlumberThemeColor
        self.editBtn.setTitle(self.theme.setLang("Edit"), for: .normal)
        self.GetUserDetails()
        // Do any additional setup after loading the view.
    }
    
    func Refresh() {
        self.CategoryArray.removeAll()
        self.ObjAvailArray.removeAll()
        self.GetUserDetails()
    }
    
    @IBAction func didclickback(_ sender: AnyObject) {
        self.view.endEditing(true)
//        self.frostedViewController.view.endEditing(true)
//        // Present the view controller
//        //
//        self.frostedViewController.presentMenuViewController()
        self.findHamburguerViewController()?.showMenuViewController()
    }
    
    @IBAction func didclickedityBtn(_ sender: Any) {
        let myViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController (withIdentifier: "EditProfileVCSID") as? EditProfileViewController
        //        myViewController!.availabilityStorage = self.AvailableAllDaysArray
        myViewController!.AvailablityArray = self.ObjAvailArray
        myViewController?.delegate = self
        self.navigationController?.pushViewController(withFade: myViewController!, animated: false)
        //        self.navigationController?.pushViewController(myViewController!, animated: true)
    }
    
    
    func GetUserDetails(){
        self.showProgress()
        let objUserRecs:UserInfoRecord=self.theme.GetUserDetails()
        
        let Param: Dictionary = ["provider_id":objUserRecs.providerId]
        
        url_handler.makeCall(viewProfile, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            if(error != nil)
            {
                self.view.makeToast(message: kErrorMsg, duration: 3, position: HRToastActivityPositionDefault as AnyObject, title: Appname)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.theme.CheckNullValue(responseObject["status"])
                    
                    if(status == "1") || (status == "3")
                    {
                        let Response = responseObject["response"] as? [String:Any] ?? [:]
                        self.taskernameLbl.text=self.theme.CheckNullValue(Response["provider_name"])
                        let Doublerat =  Double(self.theme.CheckNullValue(Response["avg_review"]))
                        let doubleStr = String(format: "%.1f", Doublerat!)
                        if doubleStr != "0.0"{
                            self.ratingLbl.text = doubleStr
                        }else{
                            self.ratingLbl.text = "0"
                        }
                        self.AboutArray = Response["about"] as! [Any]
                        var Arr = [String]()
                        for Objects in self.AboutArray{
                            let Objects = Objects as? [String:Any]
                            let Str = self.theme.CheckNullValue(Objects?["answer"])
                            if Str != "" {
                                Arr.append(Str)
                            }
                            if Arr.count > 1{
                                self.DescriptionStr = Arr.joined(separator: ".")
                            }else{
                                self.DescriptionStr = Arr.joined(separator: " ")
                            }
                        }
                        if self.DescriptionStr != "" {
                            self.taskerinfoLbl.text = self.DescriptionStr
                            self.descheight.constant = self.taskerinfoLbl.intrinsicContentSize.height + 50.0
                            self.descriptionView.layoutIfNeeded()
                            self.view.updateConstraints()
                            self.view.layoutIfNeeded()
                        }else{
                            //self.hireTop.constant = self.descTop.constant
                            self.descheight.constant = 0
                            self.descriptionView.layoutIfNeeded()
                            self.view.updateConstraints()
                            self.view.layoutIfNeeded()
                        }
                        self.addressLbl.text = self.theme.CheckNullValue(Response["Working_location"])
                        let imgurl = self.theme.CheckNullValue(Response["image"])
                        
                        UserDefaults.standard.set(imgurl, forKey: "userDP")
                        UserDefaults.standard.synchronize()
                        

                        self.profileImg.sd_setImage(with: URL(string:imgurl)) { (image, error, cache, urls) in
                            if (error != nil) {
                                self.profileImg.image = UIImage(named: "PlaceHolderSmall")
                            } else {
                                self.profileImg.image = image
                            }
                        }
                        
                        self.theme.saveUserImage(self.theme.CheckNullValue(Response["image"]) as NSString)
                        self.theme.saveTaskerMobileNumber(self.theme.CheckNullValue(Response["mobile_number"]))
                        let CategoryArray = Response["category_Details"] as? [Any]
                        if(CategoryArray!.count>0){
                            //                            let cat_array : NSArray = (responseObject.object(forKey: "response") as AnyObject).object(forKey: "category_Details") as! NSArray
                            
                            for (_,element) in CategoryArray!.enumerated()
                            {
                                let category = categoryModel()
                                category.catname = self.theme.CheckNullValue((element as AnyObject).object(forKey: "categoryname") as AnyObject)
                                category.cattype = self.theme.CheckNullValue((element as AnyObject).object(forKey: "ratetype") as AnyObject)
                                category.catamount = self.theme.CheckNullValue((element as AnyObject).object(forKey: "hourlyrate") as AnyObject)
                                category.catimage = self.theme.CheckNullValue((element as AnyObject).object(forKey: "icon") as AnyObject)
                                
                                self.CategoryArray.append(category)
                            }
                        }
                        
                        self.categoryCollectionView.reloadData()
                        //
                        if self.ObjAvailArray.count != 0{
                            self.ObjAvailArray.removeAll()
                        }
                        
                        let AvailablityArray = Response["availability_days"] as? [Any]
                        
                        for objDict in AvailablityArray!{
                            let objDict = objDict as? [String:Any]
                            let objAvailRec = AvailableRec()
                            objAvailRec.day = self.theme.CheckNullValue(objDict?["day"])
                            objAvailRec.selected = objDict?["selected"] as? Bool
                            objAvailRec.wholeday = objDict?["wholeday"] as? Bool
                            
                            let SlotsArray = objDict?["slot"] as? [Any]
                            for SlotsObj in SlotsArray!{
                                let SlotsObj = SlotsObj as? [String:Any]
                                let SlotsRec = Slots()
                                SlotsRec.slotIndex = SlotsObj?["slot"] as? Int
                                SlotsRec.TimeInterval = self.theme.CheckNullValue(SlotsObj?["time"])
                                SlotsRec.selected = SlotsObj?["selected"] as? Bool ?? false
                                objAvailRec.SlotArray.append(SlotsRec)
                            }
                            self.ObjAvailArray.append(objAvailRec)
                        }
                        self.availTbl.reloadData()
                        self.avaiHeight.constant = self.availTbl.contentSize.height
                        self.availTbl.layoutIfNeeded()
                        self.view.layoutIfNeeded()
                        self.ProfilePageScrollView.isHidden = false
                    }
                    else
                    {
                        self.view.makeToast(message: kErrorMsg, duration: 3, position: HRToastActivityPositionDefault as AnyObject, title: Appname)
                    }
                }
                else
                {
                    self.view.makeToast(message: kErrorMsg, duration: 3, position: HRToastActivityPositionDefault as AnyObject, title: Appname)
                }
            }
            
        }
    }
    
    private func setfontForPrice(with currency:String, _ amount:String, hour:String) -> NSAttributedString{
        
        let currencyAttribute = [NSAttributedString.Key.baselineOffset: 10, NSAttributedString.Key.font: UIFont(name: plumberMediumFontStr, size: 25) ?? UIFont.systemFont(ofSize: 25)] as [NSAttributedString.Key : Any]
        
        let decimalAttribute = [NSAttributedString.Key.font: UIFont(name: plumberMediumFontStr, size: 15) ?? UIFont.systemFont(ofSize: 15)] as [NSAttributedString.Key : Any]
        let normalAttribute = [NSAttributedString.Key.font: UIFont(name: plumberMediumFontStr, size: 30) ?? UIFont.systemFont(ofSize: 30)]as [NSAttributedString.Key : Any]
        let mutableAttributedString = NSMutableAttributedString()
        let currencyAttributedStr = NSAttributedString(string: currency, attributes: currencyAttribute)
        mutableAttributedString.append(currencyAttributedStr)
        
        let amountAttributedStr = NSAttributedString(string: amount, attributes: normalAttribute)
        mutableAttributedString.append(amountAttributedStr)
        
        
        let decimalAttributedStr = NSAttributedString(string: hour, attributes: decimalAttribute)
        mutableAttributedString.append(decimalAttributedStr)
        return  mutableAttributedString
    }
}

extension ExpertProfileViewController:UICollectionViewDelegate,UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.CategoryArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:"profilecateogry", for: indexPath) as! ProfileCategoryCollectionViewCell
        let model = self.CategoryArray[indexPath.row]
        let imgurl = "\(MainUrl)/\(model.catimage)"
        print("image url",imgurl)
        cell.catImage.sd_setImage(with: URL(string:imgurl)) { (image, error, cache, urls) in
            if (error != nil) {
                cell.catImage.image = UIImage(named: "PlaceHolderSmall")
            } else {
                cell.catImage.image = image
            }
        }
        cell.catName.text = model.catname
        cell.borderView.layer.cornerRadius = 10.0
        cell.borderView.layer.masksToBounds = true
        let temp = indexPath.row % self.colorsArr.count
        cell.borderView.backgroundColor = self.colorsArr[temp]
        print("indexPath.row%3",indexPath.row%3)
        if indexPath.row%3 == 0
        {
            cell.catbackImage.image = self.imageArr[0]
        }else if indexPath.row%3 == 1
        {
            cell.catbackImage.image = self.imageArr[1]
        }else if indexPath.row%3 == 2
        {
            
        }
        //        cell.catRate.text = "\(self.theme.getappCurrencycode()) \(model.catamount)"
        if model.cattype == "Flat"
        {
            cell.catRate.attributedText = self.setfontForPrice(with: self.theme.getappCurrencycode(), model.catamount, hour: "")
        }
        else{
            cell.catRate.attributedText = self.setfontForPrice(with: self.theme.getappCurrencycode(), model.catamount, hour: "/hr")
            
        }
        return cell
    }
    
    
}
extension ExpertProfileViewController : UITableViewDelegate,UITableViewDataSource
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ObjAvailArray.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->     UITableViewCell {
        let avialCell:AvailableDaysTableCell = tableView.dequeueReusableCell(withIdentifier: "availabledayscell") as! AvailableDaysTableCell
        avialCell.DayLbl.text = ObjAvailArray[indexPath.row].day
        avialCell.TimeLbl.text = self.theme.setLang("Not_Selected")
        if ObjAvailArray[indexPath.row].wholeday == true {
            avialCell.TimeLbl.text = self.theme.setLang("Wholeday")
        }
        else
        {
            let ShowingArry = ObjAvailArray[indexPath.row].SlotArray.filter {($0.selected == true)}
            let titleArray = ShowingArry.map{(self.theme.CheckNullValue($0.TimeInterval))}
            if titleArray.count > 0{
                let combainedString = titleArray.joined(separator: ",")
                avialCell.TimeLbl.text = combainedString
            }
            else{
                avialCell.TimeLbl.text = self.theme.setLang("Not_Selected")
            }
        }
        
        avialCell.selectionStyle=UITableViewCell.SelectionStyle.none
        
        return avialCell
        
    }
}
