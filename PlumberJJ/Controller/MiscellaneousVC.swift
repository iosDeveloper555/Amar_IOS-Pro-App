//
//  MiscellaneousVC.swift
//  PlumberJJ
//
//  Created by Casperon on 15/03/17.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

protocol MiscellaneousVCDelegate {
    
    func pressedCancelMaterial(_ sender: MiscellaneousVC)
    
}

class MiscellaneousVC: RootBaseViewController,UITextFieldDelegate ,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource{
    var isCanceled = false
    
    @IBOutlet var nomaterialsLbl: UILabel!
    @IBOutlet var btnOk: ButtonColorView!
    @IBOutlet var btnAdd: UIButton!
    @IBOutlet var lblNotedesc: UILabel!
    @IBOutlet var lblNote: UILabel!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var borderview: UIView!
    @IBOutlet var cancelbtn: ButtonColorView!
    @IBOutlet var okview: UIView!
    var tablecount : NSInteger!
    var materialArray : NSMutableArray = NSMutableArray()
    var jobIDStr:String = ""
    var currency:String = ""
    var allDetails = NSMutableArray()
    var isName = false
    var isRent = false
    var materilDetailDict:Dictionary = ["name":"","price":"","row":""]
    var details = materialDetails()
    var isSelected = false
    var delegate:MiscellaneousVCDelegate?
    
    @IBOutlet var noMaterialView: UIView!
    @IBOutlet var addMaterialImgView:UIImageView!
    
    
    
    struct materialDetails{
        var name :String = ""
        var price:String = ""
    }
    
    @IBAction func didClickAddMaterial(_ sender: AnyObject) {
        if tablecount == 0{
            noMaterialView.isHidden = false
        }else{
            noMaterialView.isHidden = true
        }
        if isSelected == false{
            isSelected = true
            noMaterialView.isHidden = true
            
            addMaterialImgView.image = UIImage.init(named: "Checked Checkbox 2-26")
            materialTableview.isHidden = false
            tablecount = 2
            materialTableview.reload()
            
        }else{
            isSelected = false
            addMaterialImgView.image = UIImage.init(named: "Unchecked Checkbox-48")
            tablecount = 0
            materialTableview.reload()
            allDetails = NSMutableArray()
            noMaterialView.isHidden = false
        }
    }
    
    
    @IBAction func didclickapply(_ sender: AnyObject) {
        
        self.view.endEditing(true)
       if isSelected == false{
        self.addmaterial()
       }
       else if (isName == true && isRent == true) || ((isName == false && isRent == false) && tablecount<2){
       self.addmaterial()
        }
            
        else if isName == true && isRent == false {
            
            self.theme.AlertView("\(appNameJJ)", Message:theme.setLang("Tool rent is Missing"), ButtonTitle: kOk)
            
        }
        else if isName == false && isRent == true {
            
            self.theme.AlertView("\(appNameJJ)", Message:theme.setLang("Tool Name is Missing"), ButtonTitle: kOk)
            
        }
        else if isName == false && isRent == false  && tablecount>=1 {
            self.theme.AlertView("\(appNameJJ)", Message:theme.setLang("Tool Name and Tool Rent is Missing"), ButtonTitle: kOk)
        }
    }
    func addmaterial()
    {
        self.showProgress()
        url_handler.makeCall(JobCompletedUrl, param: formDict()) {
            (responseObject, error) -> () in
            self.DismissProgress()
            
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    if(status == "1")
                    {
                        let _:NSDictionary=(responseObject.object(forKey: "response"))! as! NSDictionary
                        self.delegate?.pressedCancelMaterial(self)
                    }
                    else
                    {//alertImg
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
            
        }
    }
    @IBOutlet var materialTableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        noMaterialView.isHidden = false
        nomaterialsLbl.text = theme.setLang("Yet no materials added")
        titleLbl.text = theme.setLang("miscell_detail")
        lblNote.text = theme.setLang("note")
        lblNotedesc.text = theme.setLang("misc_disc")
        btnAdd.setTitle(theme.setLang("add_mat"), for: UIControl.State())
        btnOk.setTitle(theme.setLang("ok"), for: UIControl.State())
        cancelbtn.setTitle(theme.setLang("cancel"), for: UIControl.State())
        
        borderview.layer.cornerRadius = 5
        borderview.clipsToBounds=true
        borderview.layer.borderWidth = 1.0
        borderview.layer.borderColor = PlumberThemeColor.cgColor
        okview.layer.cornerRadius = 3
        okview.clipsToBounds=true
        cancelbtn.layer.cornerRadius = 3
        cancelbtn.clipsToBounds=true
        materialTableview.isHidden = true
        
        tablecount = 0
        
        materialTableview.register(UINib(nibName: "MaterialCell", bundle: nil), forCellReuseIdentifier: "materialcell")
        materialTableview.estimatedRowHeight = 50
        materialTableview.rowHeight = UITableView.automaticDimension
        materialTableview.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didclickback(_ sender: AnyObject) {
        self.delegate?.pressedCancelMaterial(self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return tablecount
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->     UITableViewCell {
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "materialcell", for: indexPath) as! MaterialCell
        
        if isCanceled == true{
            if allDetails.count == 0{
                cell.toolname.text = ""
                cell.toolrent.text = ""
            }
            else if allDetails.count > indexPath.row{
                let value = allDetails.object(at: indexPath.row)
                cell.toolname.text = (value as AnyObject).value(forKey: "name") as? String
                cell.toolrent.text=(value as AnyObject).value(forKey: "price") as? String
            }
            else {
                cell.toolname.text = ""
                cell.toolrent.text = ""
            }
            //    cell.toolname.text =
        }
        cell.selectionStyle=UITableViewCell.SelectionStyle.none
        cell.cancelbtn.tag = indexPath.row
        cell.toolname.delegate = self
        cell.toolrent.delegate = self
        cell.toolrent.tag = indexPath.row
        cell.toolname.tag = indexPath.row
        cell.toolrent.placeholder = theme.setLang("tool_rent")
        cell.toolname.placeholder = theme.setLang("tool_name")
        let paddingView = UILabel.init(frame: CGRect(x: 20, y: 2, width: 30, height: 20))
        paddingView.text = "  \(currency)"
        paddingView.font = UIFont.init(name: "Roboto", size: 14)
        cell.toolrent.leftView = paddingView;
        cell.toolrent.leftViewMode = UITextField.ViewMode.always
        cell.addfieldbtn.setTitle(theme.setLang("add_field"), for: UIControl.State())
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        doneToolbar.backgroundColor=UIColor.white
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title:theme.setLang("done"), style: UIBarButtonItem.Style.done, target: self, action: #selector(MiscellaneousVC.doneButtonAction))
        doneToolbar.items = [flexSpace,done]
        
        doneToolbar.sizeToFit()
        
        cell.toolrent.inputAccessoryView = doneToolbar
        
        if indexPath.row ==  tablecount-1
        {
            cell.toolname.isHidden = true
            cell.toolrent.isHidden = true
            if tablecount == 1 {
                isSelected = false
                addMaterialImgView.image = UIImage.init(named: "Unchecked Checkbox-48")
                tablecount = 0
                materialTableview.reload()
                allDetails = NSMutableArray()
                noMaterialView.isHidden = false
            }
            cell.cancelbtn.isHidden = true
            cell.addfieldbtn.isHidden = false
            isCanceled = false
            cell.addfieldbtn.addTarget(self, action: #selector(MiscellaneousVC.AddFieldAction(_:)), for: UIControl.Event.touchUpInside)
        }
        else
        {
            if (indexPath.row <  tablecount-1)
            {
                if tablecount == 2{
                    cell.cancelbtn.isHidden = true
                }
                else{
                    cell.cancelbtn.isHidden = false
                    cell.cancelbtn.addTarget(self, action: #selector(MiscellaneousVC.DeleteFieldAction(_:)), for: UIControl.Event.touchUpInside)
                }
            }
            else
            {
                cell.cancelbtn.isHidden = true
            }
            cell.toolname.isHidden = false
            cell.toolrent.isHidden = false
            cell.cancelbtn.isHidden = false
            cell.cancelbtn.addTarget(self, action: #selector(MiscellaneousVC.DeleteFieldAction(_:)), for: UIControl.Event.touchUpInside)
            cell.addfieldbtn.isHidden = true
        }
        
        
        return cell
    }
    
    
    @objc func doneButtonAction()
    {
        view.endEditing(true)
        
    }
    
    
    @objc func AddFieldAction(_ sender:UIButton){
        //self.view.endEditing(true)
        if tablecount == 0{
            noMaterialView.isHidden = false
            
        }else{
            noMaterialView.isHidden = true
            
        }
        if isRent == true && isName == true{
            isRent = false
            isName = false
            tablecount = tablecount+1
            materialTableview.reload()
            //            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            //                let indexPath = NSIndexPath.init(forRow: self.tablecount-1, inSection: 0)
            //                self.materialTableview.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            //            })
        }
        
    }
    
    
    
    @objc func DeleteFieldAction(_ sender:UIButton){
        self.view.endEditing(true)
        if tablecount == 0{
            noMaterialView.isHidden = false
            
        }else{
            noMaterialView.isHidden = true
            
        }
        print("get row \(sender.tag)")
        if sender.tag < allDetails.count{
            allDetails.removeObject(at: sender.tag)
        }
        print(allDetails)
        isRent = true
        isName = true
        
        tablecount = tablecount-1
        isCanceled = true
        materialTableview.reload()
    }
    
    
    func formDict()->NSDictionary{
        let dictRecord = NSMutableDictionary()
        let materialarr: NSMutableArray = NSMutableArray()
        var materialDict : NSDictionary = NSDictionary()
        for i in 0 ..< allDetails.count {
            let maerialDet = allDetails.object(at: i) as! NSDictionary
            
            materialDict = ["name" :maerialDet.value(forKey: "name"), "price":maerialDet.value(forKey: "price")!]
            materialarr.add(materialDict)
            //            dictRecord["miscellaneous[\(i)][name]"] = maerialDet.value(forKey: "name")
            //            dictRecord["miscellaneous[\(i)][price]"] = maerialDet.value(forKey: "price")
        }
        dictRecord["miscellaneous"] = materialarr
        dictRecord["job_id"] = "\(jobIDStr)"
        let obj = theme.GetUserDetails()
        dictRecord["provider_id"] = "\(obj.providerId)"
        
        
        print(dictRecord)
        return dictRecord
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        print(textField.tag)
        print(textField.text)
        let indexPathOfLastSelectedRow = IndexPath(row: textField.tag, section: 0)
        let tableViewCell = materialTableview.cellForRow(at: indexPathOfLastSelectedRow) as! MaterialCell
        let isReturn = false
        //        for i in 0 ..< allDetails.count{
        //            let item = allDetails.objectAtIndex(i) as! NSDictionary
        //            if item.valueForKey("row") as! String == "\(textField.tag)"{
        //                isReturn = true
        //                if textField == tableViewCell.toolname{
        //                    materilDetailDict.updateValue(textField.text!, forKey:"name")
        //                    materilDetailDict.updateValue(item.valueForKey("price") as! String, forKey:"price")
        //                    materilDetailDict.updateValue("\(textField.tag)", forKey:"row")
        //                    allDetails.removeObjectAtIndex(i)
        //                    allDetails.addObject(materilDetailDict)
        //                }else if textField == tableViewCell.toolrent{
        //                    materilDetailDict.updateValue(item.valueForKey("name") as! String, forKey:"name")
        //                    materilDetailDict.updateValue(textField.text!, forKey:"price")
        //                    materilDetailDict.updateValue("\(textField.tag)", forKey:"row")
        //                    allDetails.removeObjectAtIndex(i)
        //                    allDetails.addObject(materilDetailDict)
        //                }
        //            }
        //        }
        //
        if isReturn == false{
            if textField == tableViewCell.toolname{
                if textField.text != ""{
                    isName = true
                }
                else
                {
                    isName = false
                    
                }
                details.name = textField.text!
                
            }else if textField == tableViewCell.toolrent{
                if textField.text != ""{
                    isRent = true
                }
                else
                {
                    isRent = false
                    
                }
                details.price = textField.text!
            }
            if isName == true && isRent == true{
                if details.name != nil && details.price != nil{
                    materilDetailDict.updateValue(details.name, forKey:"name")
                    materilDetailDict.updateValue(details.price, forKey:"price")
                    materilDetailDict.updateValue("\(textField.tag)", forKey:"row")
                    allDetails.add(materilDetailDict)
                    print(allDetails.count)
                    details = materialDetails()
                }
            }
        }
        
        print(allDetails)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
