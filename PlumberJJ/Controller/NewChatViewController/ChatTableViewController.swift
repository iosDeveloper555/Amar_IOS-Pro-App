////
////  ViewController.swift
////  UUChatTableViewSwift
////
////  Created by XcodeYang on 8/13/15.
////  Copyright © 2015 XcodeYang. All rights reserved.
////
//
//import UIKit
//import Foundation
//import MediaPlayer
//import AVKit
//import AVFoundation
//
//private let leftCellId = "UUChatLeftMessageCell"
//private let rightCellId = "UUChatRightMessageCell"
//
//class ChatTableViewController: RootBaseViewController,UITableViewDataSource,UITableViewDelegate,AVPlayerViewControllerDelegate,OpenimageVCDelegate {
//    // var jobId:String!
//    var senderId:String!
//    var username: String!
//    var Userimg : String!
//    var Userid : String!
//    var RequiredJobid : String!
//    var objUserRecs:UserInfoRecord!
//    var  offlineMessage = ""
//    var textArray : NSMutableArray = NSMutableArray()
//    var FromDetailArray: NSMutableArray = NSMutableArray()
//    var getDateArray :NSMutableArray = NSMutableArray ()
//    var messgaeidarray : NSMutableArray = NSMutableArray()
//    var datatypearray : NSMutableArray = NSMutableArray()
//    var getthumbnailArray : NSMutableArray = NSMutableArray()
//    
//    
//    let titleImageView = UIImageView()
//    var chatTopView :ChatTopView!
//    var typingLabel = RSDotsView()
//    var topView = NSArray()
//    var chatTableView: UITableView!
//    var inputBackView: UUInputView!
//    var dataArray: NSMutableArray = NSMutableArray()
//    var inputViewConstraint: NSLayoutConstraint? = nil
//    let App_Delegate=UIApplication.shared.delegate as! AppDelegate
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        NotificationCenter.default.addObserver(self, selector: #selector(ChatTableViewController.keyboardFrameChanged(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
//        //  setUserStatus(false)
//        
//    }
//    
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//        
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceiveChat"), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(showMessage(_:)), name: NSNotification.Name(rawValue: "ReceiveChat"), object: nil)
//        
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceivePushChat"), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(showMessage(_:)), name: NSNotification.Name(rawValue: "ReceivePushChat"), object: nil)
//        
//        
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceiveTypingMessage"), object: nil)
//        
//        NotificationCenter.default.addObserver(self, selector: #selector(showTypingStatus(_:)), name: NSNotification.Name(rawValue: "ReceiveTypingMessage"), object: nil)
//        
//        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceiveStopTypingMessage"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(stopTypingStatus(_:)), name: NSNotification.Name(rawValue: "ReceiveStopTypingMessage"), object: nil)
//        
//    }
//    
//    
//    
//    func showTypingStatus(_ notification: Notification)
//    {
//        //                let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
//        //
//        //
//        //                let taskid : String = userInfo["taskid"]!
//        //
//        //
//        //                if (taskid == RequiredJobid as String)
//        //                {
//        
//        chatTopView.onllineBtn.isHidden=true
//        chatTopView.typingLabel.isHidden=false
//        chatTopView.typingLabel.text = "Typing..."
//        
//        // }
//        
//        
//    }
//    
//    func stopTypingStatus(_ notification: Notification) {
//        //                let userInfo:Dictionary<String,String!> = notification.userInfo as! Dictionary<String,String!>
//        //
//        //
//        //                let taskid : String = userInfo["taskid"]!
//        //
//        //
//        //                if (taskid == RequiredJobid as String)
//        //                {
//        chatTopView.onllineBtn.isHidden=false
//        chatTopView.typingLabel.isHidden=true
//        //   }
//        
//        
//    }
//    
//    
//    
//    
//    func showMessage(_ notification: Notification)
//    {
//        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
//        let providerid : String = objUserRecs.providerId as! String
//        
//        let userInfo:Dictionary<String,String?> = notification.userInfo as! Dictionary<String,String?>
//        let message_Array = notification.object as! NSArray
//        
//        let check_userid: String = userInfo["from"]!!
//        let Chatmessage:String! = userInfo["message"]!
//        let check_taskid = userInfo["task"]
//        let messgeid = userInfo["msgid"]
//        let getdate : String = userInfo["date"]! as! String
//        let getuserid = userInfo ["user_id"]
//        let getdatatype = userInfo ["datatype"]!
//        let userstats = userInfo ["usersts"]!
//        let getthumbnailimage = userInfo["thumbnail"]!
//        let tempidofVideo = userInfo ["tempidofVideo"]!
//        
//        
//        
//        if messgaeidarray.contains(messgeid!)
//        {
//            
//        }
//        else
//        {
//            messgaeidarray.add(messgeid!)
//            if check_taskid!! == RequiredJobid && getuserid!! == Userid
//            {
//                
//                
//                let mesg : UUChatModel = UUChatModel()
//                mesg.time = getdate as String
//                
//                if getdatatype  == "text"
//                {
//                    mesg.messageType = UUChatMessageType.text
//                    
//                    if (check_userid == providerid)
//                    {
//                        mesg.text = Chatmessage as String;
//                        mesg.from = UUChatFrom.me
//                    }
//                    else{
//                        mesg.text = Chatmessage as String;
//                        mesg.from = UUChatFrom.other
//                        
//                    }
//                    self.dataArray.add(mesg)
//                    chatTableView.beginUpdates()
//                    chatTableView.insertRows(at: [
//                        IndexPath(row: self.dataArray.count-1, section: 0)
//                        ], with: .automatic)
//                    chatTableView.endUpdates()
//                    self.tableViewScrollToBottom()
//                    
//                }
//                else if getdatatype  == "image"
//                {
//                    mesg.messageType = UUChatMessageType.image
//                    
//                    if (check_userid == providerid)
//                    {
//                        for i in 0..<self.dataArray.count {
//                            let model = self.dataArray[i] as! UUChatModel
//
//                            
//                            
//                            
//                            if model.tempid == tempidofVideo{
//                                mesg.from = UUChatFrom.me
////                                mesg.image = Chatmessage ;
//                                mesg.tempid = tempidofVideo!
//                                self.dataArray.replaceObject(at: i, with: mesg)
//                                self.chatTableView.beginUpdates()
//                                self.chatTableView.reloadRows(at: [
//                                    IndexPath(row: i, section: 0)
//                                    ], with: .automatic)
//                                self.chatTableView.endUpdates()
//                                self.tableViewScrollToBottom()
//                            }
//                        }
//                    }
//                    else{
////                        mesg.image = Chatmessage;
//                        mesg.from = UUChatFrom.other
//                        self.dataArray.add(mesg)
//                        chatTableView.beginUpdates()
//                        chatTableView.insertRows(at: [
//                            IndexPath(row: self.dataArray.count-1, section: 0)
//                            ], with: .automatic)
//                        chatTableView.endUpdates()
//                        self.tableViewScrollToBottom()
//                        
//                    }
//                    
//                }
//                else
//                {
//                    
//                    mesg.messageType = UUChatMessageType.video
//                    
//                    if (check_userid == providerid)
//                    {
//                        
//                        for i in 0..<self.dataArray.count {
//                            let model = self.dataArray[i] as! UUChatModel
//                            if model.tempid == tempidofVideo{
//                                print(" get video \(i)")
//                                mesg.text = Chatmessage as String;
//                                mesg.from = UUChatFrom.me
////                                mesg.image = getthumbnailimage
//                                mesg.addLoader = false
//                                    !                            mesg.tempid = tempidofVideo
//                                self.dataArray.replaceObject(at: i, with: mesg)
//                                self.chatTableView.beginUpdates()
//                                self.chatTableView.reloadRows(at: [
//                                    IndexPath(row: i, section: 0)
//                                    ], with: .automatic)
//                                self.chatTableView.endUpdates()
//                                self.tableViewScrollToBottom()
//                                
//                                
//                            }
//                        }
//                        print(" get video \(index)")
//                    }
//                    else{
//                        mesg.text = Chatmessage as String;
//                        mesg.from = UUChatFrom.other
////                        mesg.image = getthumbnailimage
//                        self.dataArray.add(mesg)
//                        chatTableView.beginUpdates()
//                        chatTableView.insertRows(at: [
//                            IndexPath(row: self.dataArray.count-1, section: 0)
//                            ], with: .automatic)
//                        chatTableView.endUpdates()
//                        self.tableViewScrollToBottom()
//                        
//                    }
//                    
//                }
//                
//                
//                
//                
//            }
//            else
//            {
//                let alertView = UNAlertView(title: appNameJJ, message:"You have a Message From User")
//                alertView.addButton("OK", action: {
//                    
//                    
//                    self.Userid = check_userid
//                    self.RequiredJobid = check_taskid!
//                    self.relaodMessageview()
//                    
//                })
//                alertView.show()
//                
//            }
//        }
//        
//        
//    }
//    func  relaodMessageview()  {
//        
//        self.messgaeidarray  = NSMutableArray()
//        self.textArray  = NSMutableArray()
//        self.FromDetailArray  = NSMutableArray()
//        self.getDateArray  = NSMutableArray ()
//        self.showProgress()
//        self.loadInitialchatView()
//    }
//    
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        NotificationCenter.default.removeObserver(self)
//        // inputBackView.userOffDataLbl.hidden = true
//    }
//    
//    //TODO: This method seems like would fix the problem of cells layout when Orientation changed.
//    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
//        //chatTableView.reloadData()
//        self.view.endEditing(true)
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationController?.isNavigationBarHidden = false
//        initBaseViews()
//        
//        objUserRecs = theme.GetUserDetails()
//        self.navigationController?.isNavigationBarHidden = false
//        topView = Bundle.main.loadNibNamed("ChatTopView", owner: self, options: nil) as! NSArray
//        chatTopView = topView[0] as! ChatTopView
//        chatTopView.frame = CGRect(x: self.chatTopView.frame.origin.x, y: self.chatTopView.frame.origin.y, width: (self.navigationController?.navigationBar.frame.size.width)!, height: self.chatTopView.frame.size.height)
//        chatTopView.backAction.addTarget(self, action: #selector(ChatTableViewController.backAction), for: UIControlEvents.touchUpInside)
//        self.navigationController?.navigationBar.addSubview(chatTopView)
//        print(self.navigationController?.navigationBar.frame )
//        print(chatTopView.frame )
//        
//        self.navigationItem.hidesBackButton = true
//        // self.blockMessage(true)
//        inputBackView.rightButton.isHidden = false
//        
//        chatTableView.register(UUChatLeftMessageCell.self, forCellReuseIdentifier: leftCellId)
//        chatTableView.register(UUChatRightMessageCell.self, forCellReuseIdentifier: rightCellId)
//        chatTableView.estimatedRowHeight = 100
//    }
//    
//    
//    func initBaseViews() {
//        //        navigationItem.rightBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Stop, target: self, action:#selector(ChatTableViewController.backAction))
//        //navigationItem.leftBarButtonItem = UIBarButtonItem.init(barButtonSystemItem: .Search, target: self, action: nil)
//        //        navigationController?.navigationBar.barTintColor = UIColor.purpleColor()
//        titleImageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
//        inputBackView = UUInputView()
//        self.view.addSubview(inputBackView)
//        inputViewConstraint = NSLayoutConstraint(
//            item: inputBackView,
//            attribute: NSLayoutAttribute.bottom,
//            relatedBy: NSLayoutRelation.equal,
//            toItem: self.view,
//            attribute: NSLayoutAttribute.bottom,
//            multiplier: 1.0,
//            constant: 0
//        )
//        inputBackView.snp_makeConstraints { (make) -> Void in
//            make.leading.trailing.equalTo(self.view)
//        }
//        view.addConstraint(inputViewConstraint!)
//        inputBackView.sendMessage(
//            imageBlock: { [weak self](image:UIImage, textView:UITextView,imagename : String, imageurl: URL) -> Void in
//                self!.sendImageMessage(textView.text!, getimage:image , imagefilename: imagename, getimageurl: imageurl)
//            },
//            textBlock: { [weak self](text:String, textView:UITextView) -> Void in
//                
//                self!.sendTextMessage(text)
//                
//            },
//            voiceBlock: { [weak self](voice:Data, textView:UITextView) -> Void in
//                
//            },
//
//            videoBlock :{ [weak self](vidofile:Data,  textView:UITextView, imagename:String, imageurl: URL)->Void in
//                self?.sendVideoMessage(vidofile, getfilename: imagename, getvideourl: imageurl)
//        })
//        
//        chatTableView = UITableView.init(frame: CGRect.zero, style: .plain)
//        chatTableView.dataSource = self
//        chatTableView.delegate = self
//        chatTableView.separatorStyle = UITableViewCellSeparatorStyle.none
//        chatTableView.keyboardDismissMode = UIScrollViewKeyboardDismissMode.interactive
//        chatTableView.estimatedRowHeight = 60
//        self.view.addSubview(chatTableView)
//        chatTableView.snp_makeConstraints { (make) -> Void in
//            make.top.leading.trailing.equalTo(self.view)
//            make.bottom.equalTo(inputBackView.snp_top)
//        }
//        chatTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
//        self.showProgress()
//        
////        appinfo.chatSenderId = Userid as String
////        appinfo.chatJobId = RequiredJobid as String
//        
//        loadInitialchatView()
//    }
//    
//    
//    func loadInitialchatView(){
//        
//        self.textArray  = NSMutableArray()
//        self.FromDetailArray = NSMutableArray()
//        self.messgaeidarray  = NSMutableArray()
//        self.getDateArray = NSMutableArray()
//        self.datatypearray = NSMutableArray()
//        self.dataArray = NSMutableArray()
//        self.getthumbnailArray = NSMutableArray()
//        
//        
//        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
//        //        if(jobId .isEqual(nil)){
//        //            jobId=""
//        //        }
//        let param=["user":self.theme.CheckNullValue(Userid)!,"tasker":objUserRecs.providerId as String,"task":self.theme.CheckNullValue(RequiredJobid)! , "type":"tasker","read_status":"tasker"];
//        
//        url_handler.makeCall(Chat_Details, param: param as NSDictionary as NSDictionary) {
//            (responseObject, error) -> () in
//            self.DismissProgress()
//            if(error != nil){
//                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault, title: "oops!!")
//                //self.setUserStatus(false)
//            }
//            else
//            {
//                if(responseObject != nil)
//                {
//                    
//                    print(responseObject)
//                    let status:String=responseObject?.object(forKey: "status") as! String
//                    
//                    let Dict:NSDictionary=responseObject!
////
////                    message_view.Timezone1 = self.theme.CheckNullValue(Dict.objectForKey("timezone1"))!
////
////                    message_view.Timezone2 = self.theme.CheckNullValue(Dict.objectForKey("timezone2"))!
//                    
//                    
//                    let taskerDetails = Dict.object(forKey: "user") as! NSDictionary
//                    self.setTitleImage(NSURL(string:self.theme.CheckNullValue(taskerDetails.object(forKey: "avatar")!)!)! as URL, text: self.theme.CheckNullValue(taskerDetails.object(forKey: "username"))!)
//                    
//                    
//                    
//                    let MessageDetails : NSMutableArray = Dict.object(forKey: "messages") as! NSMutableArray
//                    
//                    if MessageDetails.count > 0
//                    {
//                        for data  in MessageDetails
//                        {
//                            self.textArray.addObject(self.theme.CheckNullValue ((data as AnyObject).valueForKey("message"))!)
//                            self.FromDetailArray.addObject(self.theme.CheckNullValue((data as AnyObject).valueForKey("from"))!)
//                            self.getDateArray.addObject(self.theme.CheckNullValue((data as AnyObject).valueForKey("date"))!)
//                            self.messgaeidarray.addObject(self.theme.CheckNullValue((data as AnyObject).valueForKey("_id"))!)
//                            self.datatypearray.addObject(self.theme.CheckNullValue((data as AnyObject).valueForKey("datatype"))!)
//                            self.getthumbnailArray.addObject(self.theme.CheckNullValue((data as AnyObject).valueForKey("thumbnail"))!)
//                        }
//                        
//                        
//                        var k : Int
//                        for k=0 ; k<self.textArray.count; k += 1
//                        {
//                            
//                            let mesg : UUChatModel = UUChatModel()
//                            mesg.time = self.getDateArray.object(at: k) as! String
//                            
//                            if self.datatypearray.object(at: k) as! String == "text"
//                            {
//                                mesg.messageType = UUChatMessageType.Text
//                                
//                                if self.FromDetailArray.objectAtIndex(k) as! String ==  objUserRecs.providerId as String
//                                {
//                                    
//                                    mesg.from = UUChatFrom.Me
//                                    mesg.text = self.textArray.objectAtIndex(k) as? String
//                                    self.dataArray.addObject(mesg)
//                                    
//                                }
//                                else{
//                                    mesg.from = UUChatFrom.Other
//                                    mesg.text = self.textArray.objectAtIndex(k) as? String
//                                    self.dataArray.addObject(mesg)
//                                }
//                            }
//                            else if self.datatypearray.objectAtIndex(k) as! String == "image"
//                            {
//                                mesg.messageType = UUChatMessageType.Image
//                                
//                                if self.FromDetailArray.objectAtIndex(k) as! String ==  objUserRecs.providerId as String
//                                {
//                                    mesg.from = UUChatFrom.Me
//                                    mesg.image = self.textArray.objectAtIndex(k) as? String
//                                    self.dataArray.addObject(mesg)
//                                    
//                                }
//                                else{
//                                    mesg.from = UUChatFrom.Other
//                                    mesg.image = self.textArray.objectAtIndex(k) as? String
//                                    self.dataArray.addObject(mesg)
//                                }
//                            }
//                            else
//                            {
//                                mesg.messageType = UUChatMessageType.Video
//                                
//                                if self.FromDetailArray.objectAtIndex(k) as! String ==  objUserRecs.providerId as String
//                                {
//                                    mesg.from = UUChatFrom.Me
//                                    mesg.text = self.textArray.objectAtIndex(k) as? String
//                                    mesg.image = self.getthumbnailArray.objectAtIndex(k) as? String
//                                    self.dataArray.addObject(mesg)
//                                    
//                                }
//                                else{
//                                    mesg.from = UUChatFrom.Other
//                                    mesg.text = self.textArray.objectAtIndex(k) as? String
//                                    mesg.image = self.getthumbnailArray.objectAtIndex(k) as? String
//                                    
//                                    self.dataArray.addObject(mesg)
//                                }
//                                
//                                
//                            }
//                        }
//                        
//                        self.chatTableView.reloadData()
//                        
//                        self.tableViewScrollToBottom()
//                        
//                        
//                        
//                        
//                    }
//                    
//                }
//                else
//                {
//                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault, title: "oops!!")
//                    //self.setUserStatus(false)
//                }
//            }
//            
//        }
//        
//    }
//    
//    func setTitleImage(_ url:URL,text:String){
//        
//        //        let button1: UIButton = UIButton.init(type: UIButtonType.Custom)
//        //        button1.setImage(UIImage(named: "BackBtn"), forState: UIControlState.Normal)
//        //        button1.addTarget(self, action: #selector(ChatTableViewController.backAction), forControlEvents: UIControlEvents.TouchUpInside)
//        //        button1.frame = CGRectMake(0, 0, 25, 25)
//        //        let barButton0 = UIBarButtonItem(customView: button1)
//        //        let button: UIButton = UIButton.init(type: UIButtonType.Custom)
//        //        button.setImage(UIImage(data: data!), forState: UIControlState.Normal)
//        //        button.frame = CGRectMake(0, 0, 40, 40)
//        //        button.layer.cornerRadius = button.frame.width/2
//        //        button.clipsToBounds = true
//        //        let barButton = UIBarButtonItem(customView: button)
//        //
//        //        let barButton1 = UIBarButtonItem.init(title: text, style: UIBarButtonItemStyle.Plain, target: self, action: nil)
//        //        barButton1.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.whiteColor()], forState: UIControlState.Normal)
//        //        self.navigationItem.leftBarButtonItems = [barButton0,barButton,barButton1]
//        
//        chatTopView.profileImage.setImageWithURL(url)
//        chatTopView.profileImage.layer.cornerRadius = chatTopView.profileImage.frame.width/2
//        chatTopView.profileImage.clipsToBounds = true
//        chatTopView.name.text = text
//        
//    }
//    
//    func sendImageMessage(_ text:String,getimage : UIImage, imagefilename : String, getimageurl : URL){
//        
//        let  number = arc4random_uniform(1000000);
//        
//        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
//        
//        let providerid : String = objUserRecs.providerId
//        
//        
//        
//        let mesg : UUChatModel = UUChatModel()
//        mesg.messageType = UUChatMessageType.image
//        mesg.from = UUChatFrom.me
//        mesg.image = ""
//        mesg.imagedata = getimage
//        mesg.tempid = "\(number)"
//        self.dataArray.add(mesg)
//        
//        
//        chatTableView.beginUpdates()
//        chatTableView.insertRows(at: [
//            IndexPath(row: self.dataArray.count-1, section: 0)
//            ], with: .automatic)
//        chatTableView.endUpdates()
//        
//        self.tableViewScrollToBottom()
//        
//        let imagedata : Data = getimage.jpeg(.low)!
//        
//        SocketIOManager.sharedInstance.sendImage(text, withNickname:self.Userid as String, Providerid: providerid as String, taskid: self.RequiredJobid as String, data_type:"image", imagename: imagefilename, imagefile: imagedata,gettempid: "\(number)")
//        
//        
//    }
//    
//    func sendVideoMessage(_ getvideo : Data, getfilename : String, getvideourl : URL){
//        let  number = arc4random_uniform(1000000);
//        
//        
//        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
//        
//        let providerid : String = objUserRecs.providerId
//        
//        
//        let mesg : UUChatModel = UUChatModel()
//        mesg.messageType = UUChatMessageType.Video
//        mesg.from = UUChatFrom.me
//        mesg.image = ""
//        mesg.text = getvideourl.absoluteString
//        mesg.addLoader = true
//        mesg.tempid = "\(number)"
//        self.dataArray.add(mesg)
//        chatTableView.beginUpdates()
//        chatTableView.insertRows(at: [
//            IndexPath(row: self.dataArray.count-1, section: 0)
//            ], with: .automatic)
//        chatTableView.endUpdates()
//        
//        
//        self.tableViewScrollToBottom()
//        
//        
//        let compressedURL = URL(fileURLWithPath: NSTemporaryDirectory() + UUID().uuidString + ".mov")
//        self.compressVideo(getvideourl, outputURL: compressedURL) { (session) in
//            switch session.status {
//            case .unknown:
//                break
//            case .waiting:
//                break
//            case .exporting:
//                break
//            case .completed:
//                let compresseData = try? Data(contentsOf: compressedURL)
//                print("File size after compression: \(Double(compresseData!.count / 1048576)) mb")
//                
//                SocketIOManager.sharedInstance.sendvideo("", withNickname:self.Userid as String, Providerid: providerid as String, taskid: self.RequiredJobid as String, data_type:"video", imagename: getfilename, imagefile: compresseData!,gettempid:"\(number)")
//                
//                break
//            case .failed:
//                break
//            case .cancelled:
//                break
//            }
//        }
//        
//        
//    }
//    
//    func compressVideo(_ inputURL: URL, outputURL: URL, handler:@escaping (_ session: AVAssetExportSession)-> Void) {
//        let urlAsset = AVURLAsset(url: inputURL, options: nil)
//        if let exportSession = AVAssetExportSession(asset: urlAsset, presetName: AVAssetExportPreset640x480) {
//            exportSession.outputURL = outputURL
//            exportSession.outputFileType = AVFileTypeQuickTimeMovie
//            exportSession.shouldOptimizeForNetworkUse = true
//            exportSession.exportAsynchronously { () -> Void in
//                handler(exportSession)
//            }
//        }
//    }
//    
//    
//    
//    func tableViewScrollToBottom() {
//        if dataArray.count > 0
//        {
//            
//            let indexPath = IndexPath.init(row: dataArray.count-1, section: 0)
//            self.chatTableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: false)
//        }
//    }
//    
//    
//    
//    func sendTextMessage(_ text:String){
//        
//        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
//        
//        let providerid : String = objUserRecs.providerId
//        
//        
//        SocketIOManager.sharedInstance.sendStopTypingMessage(Userid as String, taskerid: providerid as String,taskid: self.theme.CheckNullValue(RequiredJobid)!)
//        
////        SocketIOManager.sharedInstance.sendMessage(text, withNickname:Userid as String, Providerid:providerid as String , taskid:RequiredJobid as String,data_type :"text",timezone_1:message_view.Timezone1  as String,timezone_2: message_view.Timezone2 as String,Sender:message_view.Timezone1 as String)
////
//        
//    }
//    func blockMessage(_ status:Bool){
//        
//        if(status == true){
//            inputBackView.rightButton.isHidden = true
//            inputBackView.contentTextView.text = ""
//            inputBackView.placeHolderLabel.text = "You can't chat with him/her right now"
//            inputBackView.contentTextView.isUserInteractionEnabled = false
//            
//        }else{
//            inputBackView.rightButton.isHidden = false
//            inputBackView.placeHolderLabel.text = "Type Your message"
//            inputBackView.contentTextView.isUserInteractionEnabled = true
//            
//        }
//        
//        
//    }
//    
//    func receiverOffline(_ notification:Notification){
//        let error = notification.object
//        print(error)
//        // setUserStatus(false)
//    }
//    
//    func setUserStatus(_ isAlive:Bool){
//        
//        
//        if(isAlive==true){
//            self.blockMessage(false)
//            
//            chatTopView.onllineBtn.setTitle(" Online", forState: UIControlState.Normal)
//            chatTopView.onllineBtn.setImage(UIImage(named: "OnlineImg"), forState: UIControlState.Normal)
//            chatTopView.typingLabel.hidden = true
//            //            userOffDataLbl.hidden=true
//            //            inputbar.userInteractionEnabled=true
//        }else{
//            chatTopView.onllineBtn.setTitle(" Offline", forState: UIControlState.Normal)
//            chatTopView.onllineBtn.setImage(UIImage(named: "OfflineImg"), forState: UIControlState.Normal)
//            self.blockMessage(true)
//            
//            chatTopView.typingLabel.hidden = true
//            
//            // chatTopView.onlineLabel.clipsToBounds=true
//            //            userOffDataLbl.hidden=false
//            //            inputbar.userInteractionEnabled=false
//        }
//        //chatTopView.onlineLabel.iconPadding = 10
//        
//        chatTopView.profileImage.layer.borderWidth=1
//        chatTopView.profileImage.layer.borderColor=UIColor.whiteColor().CGColor
//        chatTopView.profileImage.layer.cornerRadius=chatTopView.profileImage.frame.width/2
//        chatTopView.profileImage.layer.masksToBounds=true
//        
//    }
//    
//    
//    // private method
//    
//    func backAction(){
//        self.navigationController?.navigationBarHidden = true
//        if navigationController?.viewControllers.count>1 {
//            self.navigationController?.popViewControllerAnimated(true)
//        } else {
//            self.dismissViewControllerAnimated(true, completion: nil)
//        }
//    }
//    
//    @objc func keyboardFrameChanged(_ notification: Notification) {
//        
//        let dict = NSDictionary(dictionary: notification.userInfo!)
//        let keyboardValue = dict.object(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
//        let bottomDistance = mainScreenSize().height - keyboardValue.cgRectValue.origin.y
//        let duration = Double(dict.object(forKey: UIKeyboardAnimationDurationUserInfoKey) as! NSNumber)
//        
//        UIView.animate(withDuration: duration, animations: {
//            self.inputViewConstraint!.constant = -bottomDistance
//            self.view.layoutIfNeeded()
//        }, completion: {
//            (value: Bool) in
//            self.tableViewScrollToBottom()
//            
//            
//        })
//    }
//    
//    fileprivate func mainScreenSize() -> CGSize {
//        return UIScreen.main.bounds.size
//    }
//    
//    // tableview delegate & dataSource
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.dataArray.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        //
//        //        let RightCellIdentifier: String = "UUChatRightMessageCell"
//        //        let LeftCellIdentifier: String = "UUChatLeftMessageCell"
//        
//        var cell: UUChatRightMessageCell! = tableView.dequeueReusableCell(withIdentifier: "UUChatRightMessageCell") as! UUChatRightMessageCell
//        var cell1: UUChatLeftMessageCell! = tableView.dequeueReusableCell( withIdentifier: "UUChatLeftMessageCell") as! UUChatLeftMessageCell
//        let model = self.dataArray.object(at: indexPath.row) as! UUChatModel
//        
//        
//        if model.from == UUChatFrom.me
//        {
//            var  cell: UUChatRightMessageCell! = UUChatRightMessageCell()
//            cell = tableView.dequeueReusableCell(withIdentifier: "UUChatRightMessageCell") as! UUChatRightMessageCell
//            cell.configUIWithModel(self.dataArray.object(at: indexPath.row) as! UUChatModel)
//            
//            if model.messageType == UUChatMessageType.Video
//            {
//                cell.contentButton.isUserInteractionEnabled = true
//                cell.contentButton.accessibilityValue = model.text
//                cell.contentButton.accessibilityHint = "video"
//                cell.contentButton.addTarget(self, action: #selector(playVideo(_:)), for:.touchUpInside)
//            }
//                
//            else if model.messageType == UUChatMessageType.text
//            {
//                cell.contentLabel.isHidden = false
//                cell.contentButton.setBackgroundImage(nil, for: UIControlState())
//                cell.contentButton.setBackgroundImage(UIImage(named: "right_message_back"), for: UIControlState())
//                cell.contentButton.setImage(nil, for: UIControlState())
//                cell.contentButton.isUserInteractionEnabled = false
//                
//                
//            }else if model.messageType == UUChatMessageType.image
//            {
//                cell.contentLabel.text = ""
//                cell.contentLabel.isHidden = true
//                cell.contentButton.isUserInteractionEnabled = true
//                if model.image == ""
//                {
//                    
//                }
//                cell.contentButton.accessibilityValue = model.image
//                cell.contentButton.accessibilityHint = "image"
//                cell.contentButton.addTarget(self, action: #selector(playVideo(_:)), for:.touchUpInside)
//                
//                
//                
//            }
//            
//            
//            cell1 = UUChatLeftMessageCell()
//            
//            cell1.configUIWithModel(self.dataArray.object(at: indexPath.row) as! UUChatModel)
//            
//            return cell
//        }
//        else if model.from == UUChatFrom.other
//        {
//            var cell1: UUChatLeftMessageCell! = UUChatLeftMessageCell()
//            cell = UUChatRightMessageCell()
//            cell1=tableView.dequeueReusableCell( withIdentifier: "UUChatLeftMessageCell") as! UUChatLeftMessageCell
//            cell1.configUIWithModel(self.dataArray.object(at: indexPath.row) as! UUChatModel)
//            
//            if model.messageType == UUChatMessageType.Video
//            {
//                cell1.contentButton.isUserInteractionEnabled = true
//                cell1.contentButton.accessibilityValue = model.text
//                cell1.contentButton.accessibilityHint = "video"
//                cell1.contentButton.addTarget(self, action: #selector(playVideo(_:)), for:.touchUpInside)
//            }
//                
//            else if model.messageType == UUChatMessageType.text
//            {
//                cell1.contentLabel.isHidden = false
//                cell1.contentButton.setBackgroundImage(nil, for: UIControlState())
//                cell1.contentButton.setBackgroundImage(UIImage(named: "left_message_back"), for: UIControlState())
//                cell1.contentButton.setImage(nil, for: UIControlState())
//                cell1.contentButton.isUserInteractionEnabled = false
//                
//            }
//            else if model.messageType == UUChatMessageType.image
//            {
//                cell1.contentLabel.text = ""
//                cell1.contentLabel.isHidden = true
//                cell1.contentButton.isUserInteractionEnabled = true
//                cell1.contentButton.accessibilityValue = model.image
//                cell1.contentButton.accessibilityHint = "image"
//                cell1.contentButton.addTarget(self, action: #selector(playVideo(_:)), for:.touchUpInside)
//                
//            }
//            
//            cell = UUChatRightMessageCell()
//            cell.configUIWithModel(self.dataArray.object(at: indexPath.row) as! UUChatModel)
//            
//            return cell1
//        }
//        return cell
//        
//    }
//    
//    
//    func playVideo(_ sender: UIButton) {
//        
//        print("video url \(sender.accessibilityHint!) \(sender.accessibilityValue!)")
//        
//        if sender.accessibilityHint! == "image"
//        {
//            self.displayViewController(.bottomBottom,getimageval:sender.accessibilityValue!)
//            
//        }
//        else
//        {
//            
//            let videoURL = URL(string:sender.accessibilityValue!)
//            let player = AVPlayer.init(url:videoURL!)
//            let playerViewController = AVPlayerViewController()
//            
//            if #available(iOS 9.0, *) {
//                playerViewController.delegate = self
//            } else {
//                // Fallback on earlier versions
//            }
//            playerViewController.player = player
//            playerViewController.player!.play()
//            playerViewController.showsPlaybackControls = true
//            self.present(playerViewController, animated: true, completion:nil)
//            
//        }
//        
//        
//    }
//    func displayViewController(_ animationType: SLpopupViewAnimationType,getimageval:String) {
//        
//        
//        let popupimage : OpenimageVC = OpenimageVC(nibName:"OpenimageVC",bundle: nil)
//        popupimage.getimage = getimageval as NSString
//        popupimage.delegate = self;
//        self.presentpopupViewController(popupimage, animationType:animationType, completion: { () -> Void in
//            
//        })    }
//    
//    func pressedCancel(sender: OpenimageVC) {
//        self.dismissPopupViewController(.bottomBottom)
//        
//    }
//    
//    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.view.endEditing(true)
//    }
//    
//    // action
//    
//    @IBAction func sendImage(_ btn:UIButton) {
//        self.view.endEditing(true)
//        
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let libraryAction = UIAlertAction(title: "本地相册", style: .default) { (action:UIAlertAction) -> Void in
//            
//        }
//        let takePhotoAction = UIAlertAction(title: "拍照", style: .default) { (action:UIAlertAction) -> Void in
//            
//        }
//        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        alert.addAction(cancelAction)
//        alert.addAction(libraryAction)
//        alert.addAction(takePhotoAction)
//        self.present(alert, animated: true, completion: nil)
//    }
//    
//    
//}
//
//extension UIImage {
//    enum JPEGQuality: CGFloat {
//        case lowest  = 0
//        case low     = 0.25
//        case medium  = 0.5
//        case high    = 0.75
//        case highest = 1
//    }
//    
//    /// Returns the data for the specified image in PNG format
//    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
//    /// - returns: A data object containing the PNG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
//    var png: Data? { return UIImagePNGRepresentation(self) }
//    
//    /// Returns the data for the specified image in JPEG format.
//    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
//    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
//    func jpeg(_ quality: JPEGQuality) -> Data? {
//        return UIImageJPEGRepresentation(self, quality.rawValue)
//    }
//}
//
//
//
