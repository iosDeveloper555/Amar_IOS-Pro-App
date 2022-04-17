//
//  RegSecondPageViewController.swift
//  PlumberJJ
//
//  Created by Gurulakshmi's Mac Mini on 24/07/18.
//  Copyright © 2018 Casperon Technologies. All rights reserved.
//

import UIKit
import GooglePlaces

import MobileCoreServices
import Alamofire
import DropDown

var ShowArray = [Slots]()
var selectedDays = [Int]()


class RegSecondPageViewController: RootBaseViewController , SelectedSlotDetailsDelegate{
    
    @IBOutlet weak var titleLable: CustomLabelHeader!
    @IBOutlet weak var submit_btn: CustomRoundButton!
    @IBOutlet weak var TableViewHeight: NSLayoutConstraint!
    ////////////////////////////////////
    @IBOutlet weak var ScrollView: UIScrollView!
    @IBOutlet weak var InnerScrollView: UIView!
    @IBOutlet weak var AvailablityTableView: UITableView!
    
    @IBOutlet weak var BackButtonView: UIView!
    @IBOutlet weak var SelectHrsLbl: UILabel!
    
    @IBOutlet weak var selectAllDayCheckBtn: UIButton!
    @IBOutlet weak var SeletAllDayView: UIView!
    @IBOutlet weak var selectAllDayLbl: UILabel!
    var AvailDaysModified : Bool?
    var locality : String?
    var AvailableArray = [AvailableRec]()
    var heightConstraint : NSLayoutConstraint!
    var SlotArray = [Slots]()
    
    private var selectedDayIndex:Int?
    private var isWholeSelected = true{
        didSet{
            if isWholeSelected == true{
                resetAvailability()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectAllDayCheckBtn.tintColor = PlumberThemeColor
        dump(selectedDays)
//        selectedDays.removeAll()
        titleLable.text = theme.setLang("add_Avail")
        self.submit_btn.setTitle(theme.setLang("continue"), for: .normal)
        SelectHrsLbl.text = self.theme.setLang("Select_Hrs")
        selectAllDayLbl.text = self.theme.setLang("select_allDay")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.submit_btn.applyGradientwithcorner()
        }
        
        let DaysArr = self.AvailableArray.filter{($0.wholeday == false)}
        
        selectAllDayCheckBtn.isSelected = DaysArr.count == 0
        selectAllDayCheckBtn.setImage(UIImage(named: DaysArr.count == 0 ? "checkBox_checked" : "checkBox_Normal"), for: UIControl.State())

        // Do any additional setup after loading the view.
        
        AvailablityTableView.delegate = self
        AvailablityTableView.dataSource = self
        AvailablityTableView.reloadData()
    
    }
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
       
    }
    
    @objc func OpenUpCollectionViewController(sender : UIButton){
        let index = sender.tag
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AvailablityVCID") as?  AvailablityViewController{
            if let navigator = self.navigationController
            {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                viewController.selectedDayRec = AvailableArray[index]
                viewController.SelectedDateindex = index
                viewController.Delegate = self
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
    }
   
    func SelectedStols(SlotRec: AvailableRec, at index: Int, status: String) {
        self.AvailableArray.remove(at: index)
        self.AvailableArray.insert(SlotRec, at: index)
        
        if status == "SAVE"{
            let SlotSelectedArray = AvailableArray[index].SlotArray.filter{($0.selected == true)}
            if AvailableArray[index].wholeday == true || SlotSelectedArray.count > 0 {
                if !selectedDays.contains(index){
                    selectedDays.append(index)
                }
            }else{
                if selectedDays.contains(index){
                    if let ObjectIndex =  selectedDays.firstIndex(of: index){
                        selectedDays.remove(at: ObjectIndex)
                    }
                }
            }
        }else if status == "BACK"{
            
        }
        
        
        self.AvailablityTableView.reloadData()
    }
    
//
//    @objc func OpenUpCollectionView(sender : UIButton){
//        self.theme.MakeAnimation(view: self.AvailCollectionView, animation_type: CSAnimationTypeSlideUp)
//        self.view.addSubview(AvailCollectionView)
//        AvailCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: AvailCollectionView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: AvailCollectionView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: AvailCollectionView!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: AvailCollectionView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute:.bottom, multiplier: 1, constant: 0).isActive = true
//        heightConstraint =  NSLayoutConstraint(item: AvailCollectionView!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 0)
//        heightConstraint?.isActive = true
//        AvailCollectionView.layoutIfNeeded()
//        selectedDayIndex = sender.tag
//        guard AvailableArray.count > sender.tag else{return}
//        AvailCollectionView.AvailLbl.text = AvailableArray[sender.tag].day
//        SlotArray = AvailableArray[sender.tag].SlotArray
//        print("The isWholeSelected in OpenUpCollectionView is \(isWholeSelected)")
//        if AvailableArray[sender.tag].wholeday == true{
//            isWholeSelected = true
//            AvailCollectionView.AvailablityCOllectionView.isHidden = true
//            AvailCollectionView.OrView.isHidden = true
//        }
//        else{
//            isWholeSelected = false
//            AvailCollectionView.AvailablityCOllectionView.isHidden = false
//            AvailCollectionView.OrView.isHidden = false
//        }
//        AvailCollectionView.WholeDayCheckBtn.backgroundColor = isWholeSelected ? PlumberThemeColor : .gray
//        AvailCollectionView.AvailablityCOllectionView.reloadData()
//    }
    
    @IBAction func didclickbackinAvailView(_ sender: UIButton) {
        resetAvailability()
        
        self.AvailablityTableView.reloadData()
    }
    
    @IBAction func didclickDoneinAvailView(_ sender: UIButton) {
        self.AvailablityTableView.reloadData()
        TableViewHeight.constant = AvailablityTableView.contentSize.height
        self.view.updateConstraints()
        self.view.layoutIfNeeded()
        if let index = selectedDayIndex{
            let SlotSelectedArray = AvailableArray[index].SlotArray.filter{($0.selected == true)}
            if AvailableArray[index].wholeday == true || SlotSelectedArray.count > 0 {
                if !selectedDays.contains(index){
                    selectedDays.append(index)
                }
            }else{
                if selectedDays.contains(index){
                    if let ObjectIndex =  selectedDays.firstIndex(of: index){
                    selectedDays.remove(at: ObjectIndex)
                    }
                }
            }
        }
        // Don't Delete this code
    }
    
    private func convertSlotToDict(_ slot:Slots) -> [String: Any]{
        var obj = [String:Any]()
        obj["slot"] = slot.slotIndex ?? 0
        obj["time"] = slot.TimeInterval ?? ""
        obj["selected"] = slot.selected
        return obj
    }
    
    @IBAction func didclickwholeDayCheck(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isWholeSelected = sender.isSelected
        if let index = selectedDayIndex, AvailableArray.count > index{
            AvailableArray[index].wholeday = isWholeSelected
            AvailableArray[index].selected = true
        }
    }
    
    private func resetAvailability(){
        if let index = selectedDayIndex, AvailableArray.count > index{
            AvailableArray[index].SlotArray.forEach{($0.selected = false)}
            AvailableArray[index].wholeday = isWholeSelected
        }
    }
    
    @IBAction func didClickSubmitbtn(_ sender: UIButton) {
        // submit call
           self.MovetothirdPage()
    }
    


    func MovetothirdPage()
    {
      //self.showProgress()
        var FinalWorkingArray = [Any]()
        print("The selectedDays is as follows!\(selectedDays)")
        selectedDays = selectedDays.removeDuplicates(array: selectedDays)
        print("The selectedDays is as follows¡\(selectedDays)")
        selectedDays.sort()
        print("The selectedDays is as follows Newwwwwww¡\(selectedDays)")
        for index in selectedDays{
            if AvailableArray[index].wholeday == true {
                AvailableArray[index].selected = true
                var Object = [String : Any]()
                let SlotfilteredArray = AvailableArray[index].SlotArray.map{($0.slotIndex)!}
                Object = ["day":AvailableArray[index].day,"selected":AvailableArray[index].selected!,"wholeday":AvailableArray[index].wholeday!,"slots":SlotfilteredArray]
                FinalWorkingArray.append(Object)
            }else{
                AvailableArray[index].selected = true
                AvailableArray[index].wholeday = false
                var Object = [String : Any]()
                let SlotfilteredArray = AvailableArray[index].SlotArray.filter{($0.selected == true)}
                let SlotsIndexArray = SlotfilteredArray.map{($0.slotIndex)!}
              //let SlotfilteredArray = AvailableArray[index].SlotArray.map{(self.convertSlotToDict($0))}
                Object = ["day":AvailableArray[index].day,"selected":AvailableArray[index].selected!,"wholeday":AvailableArray[index].wholeday!,"slots":SlotsIndexArray/*SlotfilteredArray*/]
                FinalWorkingArray.append(Object)
            }
        }
//        SessionManager.sharedinstance.GlobalQWorkingArray = FinalWorkingArray
        print("The FinalWorkingArray is as Follows\(FinalWorkingArray)")
        Registerrec["working_days"] = FinalWorkingArray
    
        if AvailablityisMandatory == 1{
            self.theme.AlertView(ProductAppName, Message: Language_handler.VJLocalizedString("Please_select_your_available_days", comment: nil), ButtonTitle: kOk)
        }else{
            
            self.MoveToApp()
            
//                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFourthPageViewController") as?  RegFourthPageViewController{
//                    if let navigator = self.navigationController
//                    {
//                        let backItem = UIBarButtonItem()
//                        backItem.title = ""
//                        self.navigationItem.backBarButtonItem = backItem
//                        navigator.pushViewController(withFade: viewController, animated: false)
//                    }
//            }
            /*
                                            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentsVCID") as? UploadDocumentsViewController {
                                                if let navigator = self.navigationController {
                                                    //viewController.subCatId =
                                                    navigator.pushViewController(withFade: viewController, animated: false)
                                                }
                                            }
            
            */
            
//            if SessionManager.DocumentStatus == "1"{
//                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UploadDocumentsVCID") as? UploadDocumentsViewController {
//                    if let navigator = self.navigationController {
//                        navigator.pushViewController(withFade: viewController, animated: false)
//                    }
//                }
//            }else{
//                if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFourthPageViewController") as?  RegFourthPageViewController{
//                    if let navigator = self.navigationController
//                    {
//                        let backItem = UIBarButtonItem()
//                        backItem.title = ""
//                        self.navigationItem.backBarButtonItem = backItem
//                        navigator.pushViewController(withFade: viewController, animated: false)
//                    }
//                }
//            }
        }
    }
    
    @IBAction func didClickbackbtn(_ sender: UIButton) {
//        if(selectAllDayCheckBtn.isSelected == true)
//        {
////            selectAllDayCheckBtn.isSelected = false
////            selectAllDayCheckBtn.setImage(UIImage(named: "checkBox_Normal"), for: UIControlState())
////
//            self.AvailableArray.forEach{($0.wholeday=false)}
//            self.AvailableArray.forEach{($0.selected=false)}
//            AvailablityTableView.reloadData()
//            selectedDays.removeAll()
//            for i in 0...AvailableArray.count-1{
//                if selectedDays.count < 0{
//                    if !selectedDays.contains(i){
//                        selectedDays.remove(at: i)
//                    }
//                }
//            }
//        }
//        else
//        {
////            selectAllDayCheckBtn.isSelected = true
////            selectAllDayCheckBtn.setImage(UIImage(named: "checkBox_checked"), for: UIControlState())
//
//            self.AvailableArray.forEach{($0.wholeday=true)}
//            self.AvailableArray.forEach{($0.selected=true)}
//            AvailablityTableView.reloadData()
//            for i in 0...AvailableArray.count-1{
//                selectedDays.append(i)
//            }
//        }
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
    @IBAction func didclickSelectAllDay(_ sender: Any) {
        if(selectAllDayCheckBtn.isSelected == true)
        {
            selectAllDayCheckBtn.isSelected = false
            selectAllDayCheckBtn.setImage(UIImage(named: "checkBox_Normal"), for: UIControl.State())
            self.AvailableArray.forEach{($0.wholeday=false)}
            self.AvailableArray.forEach{($0.selected=false)}
            for Item in 0...self.AvailableArray.count-1{
               let Slots = self.AvailableArray[Item].SlotArray
               Slots.forEach{($0.selected=false)}
            }
            AvailablityTableView.reloadData()
            selectedDays.removeAll()
            for i in 0...AvailableArray.count-1{
                if selectedDays.count < 0{
                    if !selectedDays.contains(i){
                    selectedDays.remove(at: i)
                }
                }
            }
        }
        else
        {
            selectAllDayCheckBtn.isSelected = true
            selectAllDayCheckBtn.setImage(UIImage(named: "checkBox_checked"), for: UIControl.State())
            
            self.AvailableArray.forEach{($0.wholeday=true)}
            self.AvailableArray.forEach{($0.selected=true)}
            AvailablityTableView.reloadData()
            for i in 0...AvailableArray.count-1{
                selectedDays.append(i)
            }
        }
    }
    
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension RegSecondPageViewController : UITableViewDelegate,UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AvailableArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AvailablityCell", for: indexPath) as! AvailablityCell
        cell.DaysLabel?.text = AvailableArray[indexPath.row].day
        cell.AddorEdit.tag = indexPath.row
        cell.AddorEdit.addTarget(self, action: #selector(OpenUpCollectionViewController(sender :)), for: .touchUpInside)
        cell.DescriptionLabel.text = self.theme.setLang("Not_Selected")
        cell.AddorEdit.setTitle(self.theme.setLang("Add"), for: .normal)
//        guard SlotArray.count > indexPath.row else{return cell}
        if AvailableArray[indexPath.row].wholeday == true{
            cell.DescriptionLabel.text = self.theme.setLang("Wholeday")
            cell.AddorEdit.setTitle("Edit", for: .normal)
        }
        else {
             ShowArray = AvailableArray[indexPath.row].SlotArray.filter {($0.selected == true)}
            let titleArray = ShowArray.map{(self.theme.CheckNullValue($0.TimeInterval))}
            if titleArray.count > 0{
                cell.AddorEdit.setTitle(self.theme.setLang("Edit"), for: .normal)
                let combainedString = titleArray.joined(separator: ",")
                cell.DescriptionLabel.text = combainedString
            }else{
                cell.AddorEdit.setTitle(self.theme.setLang("Add"), for: .normal)
                cell.DescriptionLabel.text = self.theme.setLang("Not_Selected")
            }
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        TableViewHeight.constant = AvailablityTableView.contentSize.height
        AvailablityTableView.layoutIfNeeded()
        self.view.updateConstraints()
        self.view.layoutIfNeeded()
    }
    func MoveToApp(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewcontroller()
     
    }
}

extension Array{
    func removeDuplicates(array: [Int]) -> [Int] {
        var encountered = Set<Int>()
        var result: [Int] = []
        for value in array {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        return result
    }
   
}
