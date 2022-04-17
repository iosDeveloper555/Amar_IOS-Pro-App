//
//  SessionManager.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 7/24/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class SessionManager: NSObject {
    
    static let sharedinstance = SessionManager()
    
    //Add Materials Details
    var ItemsArray = [Extraitems]()
    var TaskerDescription = [Any]()
    var isReviewSkipped : Bool = false
    var ExpertsAvailableRadius : String = ""
    var GlobalQWorkingArray = [Any]()
    static var DocumentStatus = String()
}

class Extraitems: NSObject {
    var ItemIndex : Int = 0
    var ToolName : String = ""
    var ToolCost : String = ""
}


