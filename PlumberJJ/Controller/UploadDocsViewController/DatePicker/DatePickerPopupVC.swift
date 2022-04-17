//
//  DatePickerPopupVC.swift
//  PlumberJJ
//
//  Created by romil Sheth on 22/11/21.
//  Copyright © 2021 Casperon Technologies. All rights reserved.
//

import UIKit

class DatePickerPopupVC: UIViewController {
    @IBOutlet weak var datepicker:UIDatePicker!
    @IBOutlet weak var btnOk:UIButton!
    @IBOutlet weak var btnCancel:UIButton!
    var onDoneBlock : ((Date) -> Void)?
    var selectedDate = Date()
    override func viewDidLoad() {
        super.viewDidLoad()
        datepicker.minimumDate = Date()
        
        datepicker.date = selectedDate
        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnOkAction(_ sender : UIButton)
    {
        onDoneBlock!(datepicker.date)
        self.dismiss(animated: false, completion: nil)
    }
    @IBAction func btnCancelAction(_ sender : UIButton)
    {
        self.dismiss(animated: false, completion: nil)
    }
}
