//
//  ChatListDisplayRecords.swift
//  PlumberJJ
//
//  Created by Aravind Natarajan on 03/02/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

import UIKit

class ChatListDisplayRecords: NSObject {
    var chatName:NSString=""
    var chatImage:NSString=""
    var chatId:NSString=""
    var chatJobId:NSString=""
    var chatMsg:NSString=""
     var chatMsgTime:NSString=""
    var chatStatus:NSString=""
    
    init(chat_name: String, chat_Image: String, chat_id: String, chat_jobid: String, chat_msg: String , chat_msgTime: String, chat_status: String) {
        chatName = chat_name as NSString
        chatImage = chat_Image as NSString
        chatId = chat_id as NSString
        chatJobId = chat_jobid as NSString
        chatMsg = chat_msg as NSString
         chatMsgTime = chat_msgTime as NSString
        chatStatus = chat_status as NSString
        super.init()
    }
}
