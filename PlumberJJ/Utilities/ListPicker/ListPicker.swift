//
//  ListPicker.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 8/17/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import CZPicker

@objc protocol ListPickerDelegate{
    @objc optional func getSelected_ListValue(value:String,index:Int)
    @objc optional func getgetSelected_List(list:[String])
}

class ListPicker: UIView {
    
    static let sharedInstance = ListPicker()
    var delegate : ListPickerDelegate!
    var List = [String]()
    var fromViewController = UIViewController()
    
    func show(_ viewController: UIViewController, list: [String], header: String, cancelTitle: String = "Cancel", confirmTitle:String = "Confirm", needFooter:Bool = false ) {
        
        self.List = list
        self.fromViewController = viewController
        self.delegate = viewController as? ListPickerDelegate
        
        let picker = CZPickerView(headerTitle: header, cancelButtonTitle: cancelTitle, confirmButtonTitle: confirmTitle)
        picker?.frame.size = CGSize(width: 50.0, height: (picker?.frame.size.height)!)
        
        picker?.checkmarkColor = PlumberThemeColor
        picker?.confirmButtonBackgroundColor = PlumberThemeColor
        picker?.headerBackgroundColor = .white
        picker?.headerTitleColor = PlumberThemeColor
        
        picker?.delegate = self
        picker?.dataSource = self
        
        picker?.needFooterView = needFooter
        picker?.sizeToFit()
        picker?.show()
        
    }
}

extension ListPicker: CZPickerViewDelegate, CZPickerViewDataSource  {
    
    func numberOfRows(in pickerView: CZPickerView!) -> Int {
        return self.List.count
    }
    
    func czpickerView(_ pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        return self.List[row]
    }
    
    func czpickerViewDidClickCancelButton(_ pickerView: CZPickerView!) {
        self.fromViewController.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func czpickerView(pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
        let selectedList = rows.compactMap{($0 as! Int)}.map{(self.List[$0])}
        self.delegate.getgetSelected_List!(list: selectedList )
        self.fromViewController.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func czpickerView(_ pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        self.delegate.getSelected_ListValue!(value: self.List[row], index: row)
        self.fromViewController.navigationController?.setNavigationBarHidden(true, animated: true)
    }
}
