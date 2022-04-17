//
//  AddMaterialsViewController.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 7/24/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

protocol RefreshViewcontrollerDelegate {
    func RefreshPage()
}

class AddMaterialsViewController: RootBaseViewController {

    //UIVIew
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var innerScrollView: UIView!
    @IBOutlet weak var innerScrollHeaderView: UIView!
    @IBOutlet weak var addMaterialView: UIView!
    @IBOutlet weak var doneView: UIView!
    //UILabel
    @IBOutlet weak var inneScrollSubheaderLbl: UILabel!
    @IBOutlet weak var mainHeaderLbl: UILabel!
    //UIbutton
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addItemsBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    //NSLayoutConstraint
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var TableViewHeight: NSLayoutConstraint!
    //TableView
    @IBOutlet weak var addMaterialsTableView: UITableView!
    @IBOutlet weak var BottomStackView: UIStackView!
    
    
    let Themes = Theme()
    var ToolName = String()
    var ToolCost = String()
    var rowCount = NSInteger()
    var jobIDStr = String()
    var currency = String()
    var ItemsPresent : Bool = false
    var Delegate:RefreshViewcontrollerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.Themes.yesTheDeviceisHavingNotch(){
            HeaderViewHeight.constant = 100
        }
        self.SetUI()
        self.RegisterNib()
    }
    
    func SetUI(){
        self.rowCount = 0
        self.TableViewHeight.constant = 0
        self.addMaterialsTableView.isHidden = true
        self.HeaderView.dropShadow(shadowRadius: 8)
        self.backBtn.tintColor = PlumberThemeColor
        self.mainHeaderLbl.text = self.Themes.setLang("Material_details")
        self.inneScrollSubheaderLbl.text = self.Themes.setLang("add_if_any")
        self.addItemsBtn.setTitle(self.Themes.setLang("add_Item"), for: .normal)
        self.addItemsBtn.setTitleColor(PlumberThemeColor, for: .normal)
        self.doneBtn.setTitle(self.Themes.setLang("skip"), for: .normal)
        self.doneBtn.setTitleColor(.white, for: .normal)
        self.addMaterialView.layer.borderWidth = 1.0
        self.addMaterialView.layer.borderColor = PlumberThemeColor.cgColor
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.Themes.addGradient(self.doneView, colo1: lightorangecolor, colo2: darkorangecolor, direction: .LefttoRight, Frame: CGRect(x: 0, y: 0, width: self.doneView.frame.width, height: self.doneView.frame.height), CornerRadius: true, Radius: self.doneView.frame.height/2)
            })
        self.addMaterialView.layer.cornerRadius = self.addMaterialView.frame.height/2
        self.doneView.layer.cornerRadius = self.doneView.frame.height/2
    }
    
    func RegisterNib(){
        addMaterialsTableView.register(UINib(nibName:"AddMaterialViewCell", bundle: nil), forCellReuseIdentifier: "AddMaterials")
        addMaterialsTableView.rowHeight = UITableView.automaticDimension
        addMaterialsTableView.estimatedRowHeight = 110
    }

    private func validData() -> Bool{
        for object in SessionManager.sharedinstance.ItemsArray{
            if object.ToolCost == "" || object.ToolName == ""{
                self.view.makeToast(message:self.Themes.setLang("miscell_details_missing"), duration: 2, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                return false
            }
        }
        return true
    }
    
    @IBAction func didclickOptions(_ sender: UIButton) {
        self.view.endEditing(true)
        guard validData() else{return}
        let ButtonTag = sender.tag
        if ButtonTag == 0{//AddItem
            let ItemsDict = Extraitems()
            self.TableViewHeight.constant = 100
            self.doneBtn.setTitle(self.Themes.setLang("done"), for: .normal)
            self.inneScrollSubheaderLbl.text = self.Themes.setLang("MaterialDescription")
            self.view.layoutIfNeeded()
            self.addMaterialsTableView.isHidden = false
            SessionManager.sharedinstance.ItemsArray.append(ItemsDict)
            self.addMaterialsTableView.reloadData()
        }else if ButtonTag == 1{//Done
            var Parameter = [String:Any]()
            let MisceliniousArray : NSArray = SessionManager.sharedinstance.ItemsArray.map{(["name":$0.ToolName,"price": $0.ToolCost])} as NSArray
            Parameter["miscellaneous"] = MisceliniousArray
            Parameter["job_id"] = "\(jobIDStr)"
            let obj = theme.GetUserDetails()
            Parameter["provider_id"] = "\(obj.providerId)"
            self.CompleteJob(Parameter: Parameter as NSDictionary)
        }
    }
    
    func CompleteJob(Parameter : NSDictionary){
        self.showProgress()
        url_handler.makeCall(JobCompletedUrl, param: Parameter) {
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
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.Themes.CheckNullValue(responseObject["status"])
                    if(status == "1")
                    {
                        let Response = responseObject["response"] as? [String:Any]
                        let Message = self.Themes.CheckNullValue(Response?["message"])
//                        self.Themes.AlertView(appNameJJ, Message: Message, ButtonTitle: kOk)
                        self.theme.ShowNotification(Title: self.theme.setLang("job_completed"), message: Message, Indentifier: kOk)
                        self.navigationController?.popViewControllerwithFade(animated: false)
                        self.Delegate?.RefreshPage()
                        SessionManager.sharedinstance.ItemsArray.removeAll()
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
    
    @objc func DeleteField(sender : UIButton){
        let index = sender.tag
        SessionManager.sharedinstance.ItemsArray.remove(at: index)
        self.addMaterialsTableView.reloadData()
        if(SessionManager.sharedinstance.ItemsArray.count == 0){
            self.TableViewHeight.constant = 0
            self.doneBtn.setTitle(self.Themes.setLang("skip"), for: .normal)
            self.inneScrollSubheaderLbl.text = self.Themes.setLang("add_if_any")
            SessionManager.sharedinstance.ItemsArray.removeAll()
        }
    }
    
    @IBAction func didclickBackButton(_ sender: Any) {
        self.navigationController?.popViewControllerwithFade(animated: false)
        self.rowCount = 0
        SessionManager.sharedinstance.ItemsArray.removeAll()
    }
}
extension AddMaterialsViewController : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SessionManager.sharedinstance.ItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let Cell = tableView.dequeueReusableCell(withIdentifier:"AddMaterials", for: indexPath) as! AddMaterialViewCell
        Cell.selectionStyle = UITableViewCell.SelectionStyle.none
        Cell.nameTxtFld.placeholder = self.Themes.setLang("tool_name")
        Cell.costTxtFld.placeholder =  "\(self.Themes.setLang("tool_rent"))"
        Cell.currencyLbl.text = "\(currency)"
        Cell.deleteBtn.setTitle(self.Themes.setLang("delete"), for: .normal)
        Cell.nameTxtFld.tag = indexPath.row
        Cell.costTxtFld.tag = indexPath.row+500
        Cell.nameTxtFld.text = SessionManager.sharedinstance.ItemsArray[indexPath.row].ToolName
        Cell.costTxtFld.text = SessionManager.sharedinstance.ItemsArray[indexPath.row].ToolCost
        if Cell.nameTxtFld.text == "" || Cell.costTxtFld.text == ""{
            ItemsPresent = false
        }else{
            ItemsPresent = true
        }
        Cell.nameTxtFld.delegate = self
        Cell.costTxtFld.delegate = self
        Cell.deleteBtn.tag = indexPath.row
        Cell.deleteBtn.addTarget(self, action: #selector(DeleteField(sender :)), for: .touchUpInside)
        Cell.deleteBtn.setTitleColor(.red, for: .normal)
        return Cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.TableViewHeight.constant = self.addMaterialsTableView.contentSize.height
        self.addMaterialsTableView.layoutIfNeeded()
        self.addMaterialsTableView.setNeedsLayout()
    }
}

extension AddMaterialsViewController:UITextFieldDelegate{
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = textField.tag
        let localIndex = index >= 500 ? index - 500 : index
        guard SessionManager.sharedinstance.ItemsArray.count > localIndex else{return}
        if textField.tag >= 500{
            SessionManager.sharedinstance.ItemsArray[localIndex].ToolCost = Themes.CheckNullValue(textField.text)
        }else{
            SessionManager.sharedinstance.ItemsArray[localIndex].ToolName = Themes.CheckNullValue(textField.text)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
