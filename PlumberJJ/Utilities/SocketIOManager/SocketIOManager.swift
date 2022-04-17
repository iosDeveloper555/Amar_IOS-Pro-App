//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Gabriel Theodoropoulos on 1/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SocketIO

class Stackmessage {
    
    var stackArray = [NSDictionary]()
    
    func push(stringToPush: NSDictionary){
        self.stackArray.append(stringToPush)
    }
    
    func pop() -> NSDictionary? {
        if self.stackArray.first != nil {
            let stringToReturn = self.stackArray.first
            self.stackArray.removeFirst()
            return stringToReturn!
        } else {
            return nil
        }
    }
    
    func isEmpty() -> Bool {
        return stackArray.isEmpty
    }
}
var iSSocketDisconnected:Bool=Bool()

var iSChatSocketDisconnected:Bool=Bool()

class SocketIOManager: NSObject {
    
    var themes:Theme=Theme()
    var url_handler:URLhandler=URLhandler()
    var notificationmode : NSString = NSString()
  
  
    static let sharedInstance = SocketIOManager()
    
    var nick_name:NSString=NSString()
    var Appdel=UIApplication.shared.delegate as! AppDelegate
    var messageQueue = Stackmessage()

    
    let manager = SocketManager(socketURL: URL(string: MainUrl as String)!, config: [.log(true), .compress, .forcePolling(false), .reconnects(true),.forceNew(true), .reconnectAttempts(-1),.secure(false),.forceWebsockets(true)])
    var socket:SocketIOClient!
    
    
    let Chatmanager = SocketManager(socketURL: URL(string: MainUrl as String)!, config: [.log(true), .compress, .forcePolling(false), .reconnects(true),.forceNew(true), .reconnectAttempts(-1),.secure(false),.forceWebsockets(true)])
    var ChatSocket:SocketIOClient!
    
   
    override init() {
        super.init()
        //socket
        socket = manager.defaultSocket
        socket = manager.socket(forNamespace: "/notify")
        
        // chat socket
        
        ChatSocket = manager.defaultSocket
        ChatSocket = manager.socket(forNamespace: "/chat")
    }
    
    func establishConnection() {
        socket.connect()
        notificationmode = "socket"
        self.UpdateNotificationMode()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let providerid = objUserRecs.providerId
        
        socket.on("connect") {data, ack in
            print("..Check Socket Connection.....\(data).........")
            
            iSSocketDisconnected=false;
            self.roomcreation(Roomname as String, nickname: providerid as String)
        }
        
        
        socket.on("network disconnect") {data, ack in
            print("..Check Socket dis Connection.....\(data).........")
            
            iSSocketDisconnected=true;
            
        }
        
        
    }
    
    
    func establishChatConnection() {
        
        ChatSocket.connect()
        
        if themes.isUserLigin()
        {
            
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            
            let providerid = objUserRecs.providerId
            
            ChatSocket.on("connect") {data, ack in
                print("..Check Socket Connection.....\(data).........")
                iSChatSocketDisconnected = false
                
                SocketIOManager.sharedInstance.ChatWithNickname(providerid as String)
                
                
            }
            
            ChatSocket.on("disconnect") {data, ack in
                print("..Check Socket dis Connection.....\(data).........")
                iSChatSocketDisconnected=true;
                
                
                
            }
            
            ChatSocket.on("error") {data, ack in
                
                print("the socket erroe .......\(data)")
                
            }
        }
        
        
    }
    
    
    
    func RemoveAllListener()
    {
        notificationmode = "apns"
        self.UpdateNotificationMode()

        //Removing Chat Listeners
        ChatSocket.off("roomcreated")
        ChatSocket.off("updatechat")
        ChatSocket.off("single message status")
        ChatSocket.off("message status")
        ChatSocket.off("start typing")
        ChatSocket.off("stop typing")
        ChatSocket.off("connect")
        ChatSocket.off("disconnect")
        ChatSocket.off("error")
        
        
        //Removing Socket job related Listeners
        
        socket.off("connect")
        socket.off("network disconnect")
        socket.off("network created")
        socket.off("notification")
        socket.off("push notification")
        
        ChatSocket.disconnect()
        
        socket.disconnect()
        
        
    }
    
    
    
    
    func  UpdateNotificationMode(){
        
        if themes.isUserLigin()
        {
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            
            let providerid = objUserRecs.providerId
            let Param: Dictionary = ["user":providerid as String,"user_type":"tasker","mode":notificationmode,"type":"ios" ] as [String : Any]
            // print(Param)
            url_handler.makeCall(UpdateMode, param: Param as NSDictionary) {
                (responseObject, error) -> () in
                
                if(error != nil)
                {
                    
                }
                else
                {
                    if(responseObject != nil && (responseObject?.count)!>0)
                    {
                        let responseObject = responseObject!
                        let status=self.themes.CheckNullValue(responseObject.object(forKey: "status"))
                        if(status == "1")
                        {
                        }
                        else
                        {
                        }
                        
                        
                    }
                }
            }
        }
        
    }
    
    

    
    
    func LeaveRoom(_ nickname: String)
    {
        
  
        
        if socket.status == .connected
            
        {
                let param = ["user":nickname];
            
            socket.emit("network disconnect", param)
            
         

        }
        print("iosjjjj \(self.nick_name)")
        print("***************SOCKET DISCONNECTED******************")
    }
    
    
    
    func LeaveChatRoom(_ nickname: String)
    {
        
        if ChatSocket.status == .connected
            
        {
            
            let param = ["user":nickname];

            
            ChatSocket.emit("disconnect",param)
        }
        print("iosjjjj \(self.nick_name)")
        print("***************SOCKET DISCONNECTED******************")
    }
    
    
    
    func  reconnection () {
//        socket.reconnect()
    }
    
    
    func emitTracking(_ user:String,tasker:String,task:String,lat:String,long:String,bearing:String,lastdrive:String){
      
        if socket.status == .connected
        {
        let jsonString:NSDictionary = ["user":user,"tasker":tasker,"task":task,"lat":lat,"lng":long,"bearing":bearing,"lastdriving":lastdrive  ];
        socket.emit("tasker tracking", jsonString)
        }
        else
        {
            socket.connect()
        }
    }
    
    
    
    
    func ChatWithNickname(_ nickname: String) {
        
        
        if (ChatSocket.status == .connected)
            
        {
            let param = ["user":nickname];
            
            ChatSocket.emit("create room",param)
            // let dictData:NSMutableDictionary = NSMutableDictionary()
        }
        
        ChatSocket.on("roomcreated") {[weak self] data, ack in
            //  dictData["message"]=data[0]
            print("..TEST DATA.....\(data).........")
            
            self!.listenstartTyping()
            self!.listenstoptTyping()
            self!.listenSingleMessageStatus()
            self!.ListeningMessageStatus()
            self!.getChatMessage { (messageInfo) -> Void in
                
                DispatchQueue.main.async {
                    NSLog("The Chat message information=%@", messageInfo)

                }
            }
            
            
            // self?.Appdel.socketChatNotification(dictData);
        }
        
    }
    
    func sendMessage(_ message: String, withNickname nickname: String, Providerid: String, taskid: String) {
        
        if(ChatSocket.status == .connected)
        {
        // socket.emit("new message", nickname, message)
        let jsonString:NSDictionary = ["user":nickname,"tasker":Providerid,"message":message,"task":taskid,"from":Providerid]
        ChatSocket.emit("new message", jsonString)
        }
        else
        {
            ChatSocket.on(clientEvent: .connect) {data, ack in
                repeat {
                    if let message = self.messageQueue.pop() {
                        self.ChatSocket.emit("new message", message)
                    }
                }while !self.messageQueue.isEmpty()
                
            }
            let jsonString:NSDictionary = ["user":nickname,"tasker":Providerid,"message":message,"task":taskid,"from":Providerid]

            messageQueue.push(stringToPush: jsonString)

        }
    }
    
    
    func getChatMessage(_ completionHandler: (_ messageInfo: [String: AnyObject]) -> Void) {
        
        let dictData:NSMutableDictionary = NSMutableDictionary()
        
        
        ChatSocket.on("updatechat") {[weak self] data, ack in
            dictData["message"]=data[0]
            print("..TEST DATA.....\(dictData).........")
            self?.Appdel.socketChatNotification(dictData);
            
        }
    }
    
    
    func roomcreation (_ RoomName : String,nickname: String)
    {
        if (socket.status == .connected)
        {
            let param = ["user":nickname];
            
            socket.emit(RoomName, param)
        }
        socket.on("network created") {data, ack in
            print("..new  Socket Connection.....\(data).........")
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            
            let providerid = objUserRecs.providerId
            self.connectToServerWithNickname(providerid as String, completionHandler: { (userList) in
                
            })
            
            
        }
        
    }
    func connectToServerWithNickname(_ nickname: String ,completionHandler: (_ userList: [[String: AnyObject]]?) -> Void) {
        
        let dictData:NSMutableDictionary = NSMutableDictionary()
        
        socket.on("notification") {[weak self] data, ack in
            dictData["message"]=data[0]
            print("..TEST DATA.....\(dictData).........")
            self!.Appdel.socketNotification(dictData);
            
        }
        
        socket.on("web notification") {[weak self] data, ack in
            dictData["message"]=data[0]
            print("..TEST DATA.....\(dictData).........")
            self!.Appdel.socketNotification(dictData);
            
        }
    }
    
    
    func sendingSinglemessagStatus (_ taskid : String ,taskerid : String , Userid : String ,usertype:String ,messagearray:NSArray)
        
    {
        
        if(ChatSocket.status == .connected)
        {
            let jsonString:NSDictionary = ["task":taskid,"tasker":taskerid,"user":Userid ,"usertype":usertype,"message": messagearray];
            ChatSocket.emit("single message status", jsonString)
            
        }
        else
        {
            ChatSocket.connect()
        }
        
    }
    
    func listenSingleMessageStatus() {
        let dictData:NSMutableDictionary = NSMutableDictionary()
        ChatSocket.on("single message status") {[weak self] data, ack in
            dictData["message"]=data[0]
            print("..Singlemessage message....\(dictData).........")
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "readSinglemessagestatus") , object: data[0])
            
            // self?.Appdel.socketStopTypeNotification(data[0] as! NSDictionary)
        }
        
    }
    
    
    
    
    func SendingMessagestatus (_ typeofapp: String, Userid: String, taskerid : String,taskid : String)
    {
        if(ChatSocket.status == .connected)
        {
            let jsonString:NSDictionary = ["task":taskid,"tasker":taskerid,"user":Userid,"type":typeofapp];
            ChatSocket.emit("message status", jsonString)
        }
        else
        {
            ChatSocket.connect()
        }
        
        
        
        
    }
    
    
    func ListeningMessageStatus ()
    {
        let dictData:NSMutableDictionary = NSMutableDictionary()
        ChatSocket.on("message status") {[weak self] data, ack in
            dictData["message"]=data[0]
            print(". message.Status...\(dictData).........")
            
            NotificationCenter.default.post(name:NSNotification.Name(rawValue: "readmessagestatus") , object: data[0])
            
            //  self?.Appdel.socketTypeNotification(data[0] as! NSDictionary)
        }
        
        
    }
    fileprivate func listenForOtherMessages() {
        
        
    }
    
    func sendStartTypingMessage(_ Userid: String,taskerid: String,taskid : String ) {
        
        
        if(ChatSocket.status == .connected)
        {
            let jsonString:NSDictionary = ["to":Userid,"from":taskerid ,"task":taskid,"user":Userid,"tasker":taskerid,"task":taskid,"type":"tasker"]
            NSLog("the json string=%@", jsonString)
            ChatSocket.emit("start typing", jsonString)
        }
        else
        {
            ChatSocket.connect()
        }
        
        
        
    }
    func listenstartTyping() {
        let dictData:NSMutableDictionary = NSMutableDictionary()
        ChatSocket.on("start typing") {[weak self] data, ack in
            dictData["message"]=data[0]
            print("..Start typing message....\(dictData).........")
            self?.Appdel.socketTypeNotification(data[0] as! NSDictionary)
        }
        
    }
    
    
    func sendStopTypingMessage(_ Userid: String,taskerid: String,taskid : String) {
        
        if(ChatSocket.status == .connected)
        {
            let jsonString:NSDictionary = ["to":Userid,"from":taskerid,"user":Userid,"tasker":taskerid,"task":taskid,"type":"tasker"]
            NSLog("the json string=%@", jsonString)
            ChatSocket.emit("stop typing", jsonString)
        }
        else
        {
            ChatSocket.connect()
        }
    }
    
    func listenstoptTyping() {
        let dictData:NSMutableDictionary = NSMutableDictionary()
        ChatSocket.on("stop typing") {[weak self] data, ack in
            dictData["message"]=data[0]
            print("..Stop typing message....\(dictData).........")
            self?.Appdel.socketStopTypeNotification(data[0] as! NSDictionary)
        }
    }
}
