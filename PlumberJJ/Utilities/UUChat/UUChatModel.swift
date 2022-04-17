//
//  UUChatModel.swift
//  UUChatTableViewSwift
//
//  Created by 杨志平 on 11/22/15.
//  Copyright © 2015 XcodeYang. All rights reserved.
//

import UIKit

enum UUChatFrom : Int {
    case me
    case other
}

enum UUChatMessageType : Int {
    case text
    case image
    case voice
    case video
//    case Map
}

class UUChatModel: NSObject {
    var from:UUChatFrom = .me
    var messageType:UUChatMessageType = .text
    var userName:String!
    var time:String!
    var headImage:UIImage!
    
    var text:String?
    var image:UIImage?
    var addLoader : Bool?
    var tempid: String?
    var imagedata:UIImage?
    var voice:NSData?
    var voiceSecond:String?
    
    class func creatMessageFromMeByText(_ text:String) -> UUChatModel{
        let model = UUChatModel()
        model.messageType = .text
        model.text = text
        model.configMeBaseInfo()
        return model
    }
    
    class func creatMessageFromMeByImage(_ image:UIImage) -> UUChatModel{
        let model = UUChatModel()
        model.messageType = .image
        model.image = image
        model.configMeBaseInfo()
        return model
    }
    
    class func creatMessageFromMeByVoice(_ voice:Data) -> UUChatModel{
        let model = UUChatModel()
        model.messageType = .voice
        model.voice = voice as NSData
        model.voiceSecond = "5"
        model.configMeBaseInfo()
        return model
    }
    
    fileprivate func configMeBaseInfo() {
        self.from = .me
        self.userName = "Daniel"
        self.time = arc4random()%2==1 ? NSDate.init(timeIntervalSince1970: TimeInterval(arc4random()%1000)).description : ""
        self.headImage = UIImage(named: "headImage")
    }
    
    class func creatRandomArray(count:Int) -> [UUChatModel] {
        var array = [UUChatModel]()
        for _ in 0...(count) {
            let model:UUChatModel = UUChatModel()
            model.messageType = .text
            model.from = arc4random()%2==0 ? .me:.other
            model.userName = model.from == .me ? "Daniel":"Sister"
            model.time = arc4random()%2==1 ? NSDate.init(timeIntervalSince1970: TimeInterval(arc4random()%1000)).description : ""
            model.headImage = UIImage(named: "headImage")
            model.text = UUChatModel.randomStr()
            array.append(model)
        }
        return array
    }
    
    class func randomStr() -> String {
        let str:NSMutableString = "A scroll view tracks the movements of fingers and adjusts the origin accordingly. The view that is showing its content “through” the scroll view draws that portion of itself based on the new origin, which is pinned to an offset in the content view. The scroll view itself does no drawing except for displaying vertical and horizontal scroll indicators. The scroll view must know the size of the content view so it knows when to stop scrolling; by default, it “bounces” back when scrolling exceeds the bounds of the content"
             let index: Int = Int(arc4random()%100 + 5)
        return str.substring(to: index)
    }
}


