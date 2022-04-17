//
//  HomePageRec.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 7/9/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class HomePageRec: NSObject {
    
    var tasker_name = String()
    var tasker_img = String()
    var work_location = String()
    var distance_unit = String()
    var radius = String()
    var average_review = String()
    var new_leads = String()
    var category_details = [categories]()
    var tasks_details = tasks()
    var currency_details = currency()
}

class categories: NSObject {
    var id = String()
    var category_name = String()
}

class tasks: NSObject {
    var lasttask_earnings = String()
    var lasttask_hours = String()
    var lasttask_starttime = String()
    var task_count = String()
    var task_earnings = String()
    var task_hours = String()
    var JobsCount = String()
}

class currency: NSObject {
    var code = String()
    var symbole = String()
}
