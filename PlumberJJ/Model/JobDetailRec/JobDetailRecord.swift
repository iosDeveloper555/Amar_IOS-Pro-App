//
//  JobDetailRecord.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/27/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class JobDetailRecord: NSObject {
    var jobIdentity:String=""
    var Currency:String=""
    var JobID:String=""
    var jobDate:String=""
    var jobTime:String=""
    var jobTitle:String=""
    var jobDesc:String=""
    var jobStatus:String=""
    var jobStatusStr:String=""
    var jobUserName:String=""
    var jobEmail:String=""
    var jobPhone:String=""
    var jobLocation:String=""
    var jobLat:String=""
    var jobLong:String=""
    var Submit_rating : String = ""

    var jobBtnStatus:String=""
    var jobCancelReson:String = ""
    var Userid: String=""
    var Cancelreason:String = ""
    var RequireJobId: String = ""
    var userimage:String = ""
    var job_Status:String = ""
    var cashoption:String = ""
    var currency_symbol: String = ""
    var categoryEditArray:NSMutableArray = NSMutableArray()
    var checkSubCategoryArray:NSMutableArray = NSMutableArray()
    
    
}
class TrackingDetails : NSObject{
    var userLat = Double()
    var userLong = Double()
    var partnerLat = Double()
    var partnerLong = Double()
    var taskId = String()
    var selectedPage : Int = 0;
}
