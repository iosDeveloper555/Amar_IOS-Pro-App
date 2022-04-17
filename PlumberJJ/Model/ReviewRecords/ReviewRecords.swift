//
//  ReviewRecords.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/25/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

class ReviewRecords: NSObject {
    var reviewName:String=""
    var reviewTime:String=""
    var reviewDesc:String=""
    var reviewRate:String=""
    var reviewImage:String=""
    var ratterImage:String=""
    var reviewJobID:String=""
    
    
    init(name: String, time: String, desc: String, rate: String, img: String,ratting:String,jobid:String) {
        reviewName = name
        reviewTime = time
        reviewDesc = desc
        reviewRate = rate
        reviewImage = img
        ratterImage = ratting
        reviewJobID = jobid
        
        super.init()
    }
}
