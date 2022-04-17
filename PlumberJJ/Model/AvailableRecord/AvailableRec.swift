//
//  AvailableRec.swift
//  PlumberJJ
//
//  Created by Gurulakshmi's Mac Mini on 26/07/18.
//  Copyright © 2018 Casperon Technologies. All rights reserved.
//

import UIKit

class AvailableRec: NSObject {
    var day : String = ""
    var ismorning: Bool?
    var isaftn : Bool?
    var isevening : Bool?
    var selected : Bool?
    var wholeday : Bool?
    var SlotArray = [Slots]()
}

class Slots: NSObject {
    var slotIndex : Int?
    var TimeInterval : String?
    var selected = false
}
