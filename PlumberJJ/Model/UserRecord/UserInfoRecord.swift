//
//  UserInfoRecord.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/19/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit

@objcMembers class UserInfoRecord: NSObject {
    @objc var providerName:String=""
    @objc var providerId:String=""
    @objc  var providerImage:String=""
    @objc var providerEmail:String=""
    @objc  var providerContactNo:String=""
    
  @objc init(prov_name: String, prov_ID: String, prov_Image: String, prov_Email: String, prov_mob: String) {
        providerName = prov_name
        providerId = prov_ID
        providerImage = prov_Image
        providerEmail = prov_Email
        providerContactNo = prov_mob
        super.init()
    }
}
