//
//  MyOrderOpenRecord.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 10/29/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit


class MyOrderOpenRecord: NSObject {
    var orderId:String=""
    var postedOn:String=""
    var UserName:String=""
    var userCatg:String=""
    var userLoc:String=""
    var userImg:String=""
    var orderstatus:String=""
    
    init(order_id: String, post_on: String, user_Img: String, user_name: String, user_catg: String , user_Loc: String, order_sta: String ) {
        orderId = order_id
        postedOn = post_on
        userImg = user_Img
        UserName = user_name
        userCatg = user_catg
        userLoc = user_Loc
        orderstatus = order_sta
        super.init()
    }
}
