//
//  MessageViewController.swift
//  Plumbal
//
//  Created by Casperon Tech on 20/01/16.
//  Copyright © 2016 Casperon Tech. All rights reserved.
//

//
//
//+(id)sharedInstance;
//-(void)loadOldMessages;
//-(void)sendMessage:(Message *)message;
//-(void)news;
//-(void)dismiss;

import UIKit
import AVFoundation
import SDWebImage

protocol keyboardHideDelegate {
    func hideKeyBoard(_ checkKeyboard:String)
}
class MessageViewController: RootBaseViewController,InputbarDelegate,MessageGatewayDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate {
    
    @IBOutlet var User_lbl: UILabel!
    @IBOutlet var typingLbl: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var inputbar: Inputbar!
    @IBOutlet weak var onlinelbl: SMIconLabel!
    @IBOutlet weak var userImg: UIButton!
    
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var userImgView: UIImageView!
    @IBOutlet weak var userOffDataLbl: UILabel!
    var messgaeidarray : NSMutableArray = NSMutableArray()
    var textArray : NSMutableArray = NSMutableArray()
    var FromDetailArray: NSMutableArray = NSMutableArray()
    var userstatusArray : NSMutableArray = NSMutableArray()
    var getDateArray :NSMutableArray = NSMutableArray ()
    var tableArray:TableArray=TableArray()
    var gateway:MessageGateway=MessageGateway()
    var chat:Chat=Chat()
    
    var jobId:String = ""
    var senderId:String = ""
    var username: String!
    var Userimg : String!
    var Userid : String!
    var RequiredJobid : String!
    var delegate:keyboardHideDelegate!
    var isJobCompleted = false
    
    let App_Delegate=UIApplication.shared.delegate as! AppDelegate
    override func viewDidLoad() {
        
        if theme.yesTheDeviceisHavingNotch(){
            self.HeaderViewHeight.constant = 100
        }
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        
        _ = objUserRecs.providerId
                
        //  SocketIOManager.sharedInstance.send("tasker", Userid:Userid as String, taskerid:providerid as String, taskid: RequiredJobid as String)
        
        tableView.tableFooterView = UIView()
        super.viewDidLoad()
        //  setUserStatus(false)
        setInputbar()
        self.setTableView()
        self.SetImageView()
        self.showProgress()
        loadInitialchatView()
        
        
        let tapgesture:UITapGestureRecognizer=UITapGestureRecognizer(target:self, action:#selector(DismissKeyboard))
        tapgesture.delegate = self;
        
        view.addGestureRecognizer(tapgesture)
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receiveChatNotification:", name: "ChatFromOthersNotification", object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DismissKeyboard), name:NSNotification.Name(rawValue: "Dismisskeyboard"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.receiveTypestaus(_:)), name: NSNotification.Name(rawValue: kTypeStatus), object: nil)
        // Do any additional setup after loading the view.
    }
    
    @objc override func DismissKeyboard()
    {
        inputbar.resignFirstResponder()
    }
    deinit
    {
        NotificationCenter.default.removeObserver(self)
    }
    
    func SetImageView()
    {
        userImgView.layer.cornerRadius = userImgView.frame.size.height / 2;
        userImgView.clipsToBounds=true
        userImgView.layer.masksToBounds = true;
        userImgView.layer.borderWidth = 0;
        userImgView.contentMode = UIView.ContentMode.scaleAspectFill
        userImgView.layer.borderWidth=2.0
        userImgView.layer.borderColor=PlumberThemeColor.cgColor
    }
    
    func loadInitialchatView()
    {
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let providerid = objUserRecs.providerId
        
        let param=["user":self.theme.CheckNullValue(Userid),"tasker":providerid as String,"task":self.theme.CheckNullValue(RequiredJobid) , "type":"tasker","read_status":"tasker"];
        
        url_handler.makeCall(Chat_Details, param: param as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            
            if(error != nil)
            {
                // self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "oops!!")
                //self.setUserStatus(false)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let Dict:NSDictionary=responseObject
                    
                    _=self.theme.CheckNullValue(Dict.object(forKey: "status") as AnyObject) as NSString
                    
                    let taskerDetails = Dict.object(forKey: "user") as! NSDictionary
                    
                    self.userImgView.sd_setImage(with: URL(string:
                        self.theme.CheckNullValue(taskerDetails.object(forKey: "avatar") as AnyObject as AnyObject)), placeholderImage: UIImage(named: "PlaceHolderSmall"))
                    
                    // self.userImgView.sd_setImageWithURL(NSURL(string:imageurl), placeholderImage: UIImage(named: "PlaceHolderSmall"))
                    self.User_lbl.text = self.theme.CheckNullValue(taskerDetails.object(forKey: "username") as AnyObject)
                    
                    let MessageDetails : NSMutableArray = Dict.object(forKey: "messages") as! NSMutableArray
                    
                    if MessageDetails.count > 0
                    {
                        
                        for data  in MessageDetails
                        {
                            self.textArray.add(self.theme.CheckNullValue ((data as AnyObject).value(forKey: "message") as AnyObject))
                            self.FromDetailArray.add(self.theme.CheckNullValue((data as AnyObject).value(forKey: "from") as AnyObject))
                            self.userstatusArray .add(self.theme.CheckNullValue((data as AnyObject).value(forKey: "user_status") as AnyObject))
                            self.messgaeidarray.add(self.theme.CheckNullValue((data as AnyObject).value(forKey: "_id") as AnyObject))
                            self.getDateArray.add(self.theme.CheckNullValue((data as AnyObject).value(forKey: "date") as AnyObject))
                            
                        }
                        
                        for k in 0..<self.textArray.count
                        {
                            let mesg : Message = Message()
                            mesg.text = (self.textArray.object(at: k) as! String);
                            let text = self.getDateArray.object(at: k)  as! String
                            let types: NSTextCheckingResult.CheckingType = .date
                            var getdate = Foundation.Date()
                            let detector = try? NSDataDetector(types: types.rawValue)
                            let matches = detector!.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))
                            for match in matches {
                                getdate = (match.date!)
                            }
                            mesg.date = getdate
                            if self.FromDetailArray.object(at: k) as! String == providerid as String
                            {
                                mesg.sender = MessageSender.myself;
                                if (self.userstatusArray.object(at: k) as! String == "2")
                                {
                                    mesg.status = MessageStatus.read
                                }
                                else if (self.userstatusArray.object(at: k) as! String == "1")
                                {
                                    mesg.status = MessageStatus.received
                                }
                            }
                            else{
                                mesg.sender = MessageSender.someone;
                            }
                            self.tableArray.addObject(mesg)
                        }
                        
                        self.tableView.reloadData();                      self.tableViewScrollToBottomAnimated(true)
                        self.inputbar.isUserInteractionEnabled = true
                        
                        let delayTime = DispatchTime.now() + Double(Int64(2 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                        DispatchQueue.main.asyncAfter(deadline: delayTime) {
                            if SocketIOManager.sharedInstance.ChatSocket.status == .connected
                            {
                                
                                SocketIOManager.sharedInstance.SendingMessagestatus("tasker", Userid: self.Userid as String, taskerid: providerid as String, taskid: self.RequiredJobid as String)
                            }
                        }
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "oops!!")
                    //self.setUserStatus(false)
                }
            }
        }
    }
    func setUserStatus(_ isAlive:Bool){
        
        if(isAlive==true){
            onlinelbl.text="Online"
            onlinelbl.icon = UIImage(named: "OnlineImg")
            userOffDataLbl.isHidden=true
            inputbar.isUserInteractionEnabled=true
        }
        else
        {
            onlinelbl.text="Offline"
            
            onlinelbl.icon = UIImage(named: "OfflineImg")
            
            onlinelbl.clipsToBounds=true
            userOffDataLbl.isHidden=false
            inputbar.isUserInteractionEnabled=false
        }
        onlinelbl.iconPadding = 5
        onlinelbl.iconPosition = SMIconLabelPosition.left
        
        //        userImgView.layer.borderWidth=1
        userImgView.layer.borderColor=PlumberThemeColor.cgColor
        userImgView.layer.cornerRadius=userImg.frame.width/2
        userImgView.layer.masksToBounds=true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceiveChat"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showMessage(_:)), name: NSNotification.Name(rawValue: "ReceiveChat"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceivePushChat"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showPushMessage(_:)), name: NSNotification.Name(rawValue: "ReceivePushChat"), object: nil)
                
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceiveTypingMessage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(showTypingStatus(_:)), name: NSNotification.Name(rawValue: "ReceiveTypingMessage"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "ReceiveStopTypingMessage"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(stopTypingStatus(_:)), name: NSNotification.Name(rawValue: "ReceiveStopTypingMessage"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "readmessagestatus"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.ReadmessageStatus(_:)), name:NSNotification.Name(rawValue: "readmessagestatus"), object: nil)
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "readSinglemessagestatus"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MessageViewController.ReadSinglemessageStatus(_:)), name:NSNotification.Name(rawValue: "readSinglemessagestatus"), object: nil)
                
        let controller:MessageViewController=self
        self.view.keyboardTriggerOffset = inputbar.frame.size.height;
        setTest()
        
        view.addKeyboardPanning { (keyboardFrameInView:CGRect, opening:Bool, closing:Bool) -> Void in
            
            var toolBarFrame:CGRect=self.inputbar.frame
            toolBarFrame.origin.y = keyboardFrameInView.origin.y - toolBarFrame.size.height;
            self.inputbar.frame = toolBarFrame;
            
            var tableViewFrame:CGRect = self.tableView.frame;
            tableViewFrame.size.height = toolBarFrame.origin.y - 80;
            self.tableView.frame = tableViewFrame;
            
            controller.tableViewScrollToBottomAnimated(true)
        }
    }
    
    @objc func ReadSinglemessageStatus(_ notification: Notification){
        
        guard let url = notification.object else {
            return // or throw
        }
        
        let blob = url as! NSDictionary // or as! Sting or as! Int
        if(blob.count>0){
            
            NSLog("get singlemessage =%@", blob)
            let taskid : String = theme.CheckNullValue(blob.object(forKey: "task") as AnyObject)
            
            if taskid == RequiredJobid as String
            {
                
                let mesg : Message = tableArray.lastObject()
                mesg.status = MessageStatus.read
                
                tableView.reloadData()
                
                // NSInteger lastRowIndex = [tableView numberOfRowsInSection:lastSectionIndex] - 1;
                
            }
        }
    }
    
    @objc func ReadmessageStatus(_ notification: Notification){
        
        guard let url = notification.object else {
            return // or throw
        }
        
        let blob = url as! NSDictionary // or as! Sting or as! Int
        if(blob.count>0){
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            let providerid = objUserRecs.providerId
            
            let taskid : String = theme.CheckNullValue(blob.object(forKey: "task") as AnyObject)
            
            if taskid == RequiredJobid as String
            {
                textArray  = NSMutableArray()
                FromDetailArray = NSMutableArray()
                userstatusArray  = NSMutableArray()
                messgaeidarray  = NSMutableArray()
                self.tableArray = TableArray()
                gateway = MessageGateway()
                self.getDateArray = NSMutableArray()
                
                if blob.count > 0
                {
                    
                    let MessageDetails : NSMutableArray = blob.object(forKey: "messages") as! NSMutableArray
                    
                    for data  in MessageDetails
                    {
                        self.textArray.add(self.theme.CheckNullValue ((data as AnyObject).value(forKey: "message") as AnyObject))
                        self.FromDetailArray.add(self.theme.CheckNullValue((data as AnyObject).value(forKey: "from") as AnyObject))
                        self.userstatusArray .add(self.theme.CheckNullValue((data as AnyObject).value(forKey: "user_status") as AnyObject))
                        self.messgaeidarray.add(self.theme.CheckNullValue((data as AnyObject).value(forKey: "_id") as AnyObject))
                        self.getDateArray.add(self.theme.CheckNullValue((data as AnyObject).value(forKey: "date") as AnyObject))
                        
                    }
                    
                    for k in 0..<self.textArray.count
                    {
                        let mesg : Message = Message()
                        mesg.text = (self.textArray.object(at: k) as! String)
                        
                        let text = self.getDateArray.object(at: k)  as! String
                        let types: NSTextCheckingResult.CheckingType = .date
                        var getdate = Foundation.Date()
                        let detector = try? NSDataDetector(types: types.rawValue)
                        let matches = detector!.matches(in: text, options: .reportCompletion, range: NSMakeRange(0, text.count))
                        
                        for match in matches {
                            getdate = (match.date!)
                        }
                        mesg.date = getdate
                        
                        
                        if self.FromDetailArray.object(at: k) as! String == providerid as String
                        {
                            mesg.sender = MessageSender.myself;
                            
                            if (self.userstatusArray.object(at: k) as! String == "2")
                            {
                                mesg.status = MessageStatus.read
                            }
                            else if (self.userstatusArray.object(at: k) as! String == "1")
                            {
                                mesg.status = MessageStatus.received
                            }
                        }
                        else{
                            mesg.sender = MessageSender.someone;
                        }
                        
                        self.tableArray.addObject(mesg)
                    }
                    
                    self.tableView.reloadData()
                    self.tableViewScrollToBottomAnimated(true)
                    
                }
            }
        }
    }
    
    @objc func showTypingStatus(_ notification: Notification)
    {
        typingLbl.text = "typing......"
    }
    
    @objc func stopTypingStatus(_ notification: Notification) {
        typingLbl.text = ""
    }
    
    @objc func showPushMessage(_ notification: Notification){
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        
        //       inputbar.resignFirstResponder()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        
        let providerid = objUserRecs.providerId
        
        let message_Array = notification.object as! NSArray

        let check_userid = userInfo["from"]
        
        let Chatmessage = userInfo["message"]
        let check_taskid = userInfo["task"]
        let messgeid = userInfo["msgid"]
        _ = userInfo["date"]
        let getUserid = userInfo["user_id"]
        
        let userstats = userInfo ["usersts"]!
        
        if messgaeidarray.contains(messgeid)
        {
            
        }
        else
        {
            messgaeidarray.add(messgeid)
            if "\(check_taskid)" == "\(RequiredJobid)" && "\(getUserid)" == "\(Userid)"
            {
                
                let mesg : Message = Message()
                
                if ("\(check_userid)" == "\(providerid)")
                {
                    mesg.text = Chatmessage;
                    mesg.sender = MessageSender.myself;
                    //  mesg.date = getdatefromweb
                    mesg.date = Foundation.Date()
                    
                    if (userstats  == "2")
                    {
                        mesg.status = MessageStatus.read
                    }
                    else if (userstats  == "1")
                    {
                        mesg.status = MessageStatus.received
                    }
                }
                else{
                    
                    let delayTime = DispatchTime.now() + Double(Int64(3 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
                    DispatchQueue.main.asyncAfter(deadline: delayTime) {
                        
                        if SocketIOManager.sharedInstance.ChatSocket.status == .connected
                        {
                            SocketIOManager.sharedInstance.sendingSinglemessagStatus(self.RequiredJobid as String, taskerid:providerid as String, Userid: self.Userid as String ,usertype:"tasker",messagearray: message_Array)
                        }
                    }
                    
                    mesg.text = Chatmessage as! String;
                    mesg.sender = MessageSender.someone;
                    mesg.date =  Foundation.Date()
                    // mesg.date = NSDate()
                                        
                }
                self.tableArray.addObject(mesg)
                
                tableView.reloadData()
                self.tableViewScrollToBottomAnimated(true)
                
            }
            else
            {
                let alertView = UNAlertView(title: appNameJJ, message:"You have a Message From User")
                alertView.addButton(self.theme.setLang("ok"), action: {
                    
                    self.Userid = check_userid
                    self.RequiredJobid = check_taskid
                    self.Reload_Messageview()
                    
                })
                AudioServicesPlayAlertSound(1315);
                
                alertView.show()
                
            }
        }
    }
    
    @objc func showMessage(_ notification: Notification)
    {
        //                inputbar.resignFirstResponder()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let providerid = objUserRecs.providerId
        let userInfo:Dictionary<String,String> = notification.userInfo as! Dictionary<String,String>
        let message_Array = notification.object as! NSArray
        let check_userid = userInfo["from"]
        let Chatmessage = userInfo["message"]
        let check_taskid = userInfo["task"]
        let messgeid = userInfo["msgid"]
        let getdate = userInfo["date"]
        let getUserid = userInfo["user"]
        let text = getdate
        let types: NSTextCheckingResult.CheckingType = .date
        var getdatefromweb = Foundation.Date()
        let detector = try? NSDataDetector(types: types.rawValue)
        let matches = detector!.matches(in: text!, options: .reportCompletion, range: NSMakeRange(0, text!.count))
        
        for match in matches {
            getdatefromweb = (match.date!)
        }
        
        let userstats = userInfo ["usersts"]!
        
        if messgaeidarray.contains(messgeid!)
        {
            
        }
        else
        {
            messgaeidarray.add(messgeid!)
            if "\(check_taskid)" == "\(RequiredJobid)" && "\(getUserid)" == "\(Userid)"
            {
                
                let mesg : Message = Message()
                
                if (check_userid == providerid)
                {
                    mesg.text = Chatmessage;
                    mesg.sender = MessageSender.myself;
                    mesg.date = getdatefromweb
                    // mesg.date = NSDate()
                    
                    if (userstats  == "2")
                    {
                        mesg.status = MessageStatus.read
                    }
                    else if (userstats  == "1")
                    {
                        mesg.status = MessageStatus.received
                    }
                }
                else{
                    mesg.text = Chatmessage;
                    mesg.sender = MessageSender.someone;
                    mesg.date = getdatefromweb
                    // mesg.date = NSDate()
                    SocketIOManager.sharedInstance.sendingSinglemessagStatus(RequiredJobid as String, taskerid:providerid as String, Userid: Userid as String ,usertype:"tasker",messagearray: message_Array)
                    
                }
                
                let systemSoundID: SystemSoundID = 1016
                // to play sound
                AudioServicesPlaySystemSound (systemSoundID)
                self.tableArray.addObject(mesg)
                
                
                tableView.reloadData()
                self.tableViewScrollToBottomAnimated(true)
                
            }
            else
            {
                let alertView = UNAlertView(title: appNameJJ, message:self.theme.setLang("You have a Message From User"))
                alertView.addButton(self.theme.setLang("ok"), action: {
                    self.Userid = check_userid
                    self.RequiredJobid = check_taskid
                    self.Reload_Messageview()
                })
                AudioServicesPlayAlertSound(1315);
                alertView.show()
            }
        }
    }
    
    func   Reload_Messageview() {
        
        tableView.tableFooterView = UIView()
        //  setUserStatus(false)
        self.setTableView()
        
        self.showProgress()
        textArray  = NSMutableArray()
        FromDetailArray = NSMutableArray()
        userstatusArray  = NSMutableArray()
        messgaeidarray  = NSMutableArray()
        self.tableArray = TableArray()
        gateway = MessageGateway()
        self.getDateArray = NSMutableArray()
        
        loadInitialchatView()
        setInputbar()
        self.SetImageView()
    }
    
    @IBAction func didClickOptions(_ sender: AnyObject) {
        if(sender.tag == 0)
        {
            self.navigationController?.popViewControllerwithFade(animated: false)
        }
    }
    func setTest()
    {
        chat = Chat()
        chat.sender_name = "Player 1"
        chat.receiver_id = "12345"
        chat.sender_id = "54321"
        let texts: NSArray = []
        var last_message: Message? = nil
        for text in texts {
            let message: Message = Message()
            message.text = text as? String
            message.sender = .someone
            message.status = .received
            message.chat_id = chat.identifier()
            (LocalStorage.sharedInstance() as AnyObject).store(message)
            last_message = message
        }
        chat.numberOfUnreadMessages = texts.count
        if(last_message != nil)
        {
            chat.last_message = last_message!
        }
        
    }
    @objc func receiveTypestaus(_ notification:Notification)
    {
        let str:NSString!=notification.object as? NSString
        if(str == "Type")
        {
            onlinelbl.isHidden=true
            typingLbl.isHidden=false
            // typingLbl.startAnimating()
        }
        else if(str == "StopType")
        {
            onlinelbl.isHidden=false
            typingLbl.isHidden=true
            // typingLbl.stopAnimating()
        }
    }
    func receiveChatNotification(_ notification:Notification)
    {
        let str:NSString!=notification.object as! NSString
        if(str != nil)
        {
            MessageFromIn(str as String)
        }
        //  setUserStatus(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        theme.saveHidestatus("Hide")
    }
    
    func setInputbar()
    {
        if isJobCompleted == true{
            self.inputbar.isHidden = true
        }else{
            self.inputbar.isHidden = false
            self.inputbar.placeholder = nil;
            self.inputbar.delegate = self;
            //self.inputbar.leftButtonImage = UIImage(named: "share")
            self.inputbar.rightButtonText = theme.setLang("Send");
            self.inputbar.rightButtonTextColor = UIColor(red: 0, green: 124/255.0, blue: 1, alpha: 1)
        }
    }
    
    func setTableView()
    {
        self.tableArray = TableArray()
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.tableFooterView = UIView(frame: CGRect(x: 0.0, y: 0.0,width: view.frame.size.width, height: 10.0))
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none;
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(MessageCell.classForCoder(), forCellReuseIdentifier: "MessageCell")
        
    }
    func setGateway()
    {
        gateway = MessageGateway()
        gateway.delegate = self;
        gateway.chat = self.chat;
        gateway.loadOldMessages()
    }
    
    //TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tableArray.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableArray.numberOfMessages(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let CellIdentifier: String = "MessageCell"
        var cell: MessageCell! = (tableView.dequeueReusableCell(withIdentifier: CellIdentifier) as! MessageCell)
        if (cell == nil) {
            cell = MessageCell(style: .default, reuseIdentifier: CellIdentifier)
        }
        if(self.tableArray.object(at: indexPath) != nil){
            cell.message = self.tableArray.object(at: indexPath)
        }
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.tableArray.title(forSection: section)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let message: Message = self.tableArray.object(at: indexPath)
        return message.heigh
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let frame: CGRect = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 40)
        let view: UIView = UIView(frame: frame)
        view.backgroundColor = UIColor.clear
        view.autoresizingMask = .flexibleWidth
        let label: UILabel = UILabel()
        label.text = self.tableArray.title(forSection: section)
        label.textAlignment = .center
        label.font = UIFont(name: "Helvetica", size: 20.0)
        label.sizeToFit()
        label.center = view.center
        label.font = UIFont(name: "Helvetica", size: 13.0)
        label.backgroundColor = UIColor(red: 207 / 255.0, green: 220 / 255.0, blue: 252.0 / 255.0, alpha: 1)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        label.autoresizingMask = UIView.AutoresizingMask()
        view.addSubview(label)
        return view
        
    }
    func tableViewScrollToBottomAnimated(_ animated: Bool) {
        let numberOfSections:NSInteger=tableArray.numberOfSections()
        let numberOfRows:NSInteger=tableArray.numberOfMessages(inSection: numberOfSections-1)
        if(numberOfRows != 0)
        {
            tableView.scrollToRow(at: tableArray.indexPathForLastMessage(), at: UITableView.ScrollPosition.bottom, animated: animated)
        }
    }
    
    func inputbarDidPressRightButton(_ inputbar: Inputbar!) {
        
        theme.saveHidestatus("Don't Hide")
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let providerid = objUserRecs.providerId
        SocketIOManager.sharedInstance.sendMessage(inputbar.text(), withNickname:Userid as String, Providerid:providerid as String , taskid:RequiredJobid as String)
    }
    func MessageFromIn(_ str: String) {
        
        let message: Message = Message()
        message.text = str
        message.date = Foundation.Date()
        message.chat_id = "1"
        message.sender = .someone
        //Store Message in memory
        self.tableArray.addObject(message)
        //Insert Message in UI
        do
        {
            try moveTable(message)
        }
        catch
        {
            print("there is an error")
        }
    }
    
    func moveTable (_ message:Message)throws
    {
        let indexPath: IndexPath =  tableArray.indexPath(for: message)
        
        self.tableView.beginUpdates()
        if self.tableArray.numberOfMessages(inSection: indexPath.section) == 1 {
            self.tableView.insertSections(IndexSet(integer:indexPath.section), with: .none)
        }
        self.tableView.insertRows(at: [indexPath], with: .bottom)
        self.tableView.endUpdates()
        self.tableView.scrollToRow(at: self.tableArray.indexPathForLastMessage(), at: .bottom, animated: true)
    }
    
    func inputbarDidPressLeftButton(_ inputbar: Inputbar!) {
        //        let alertView: UIAlertView = UIAlertView(title: "Left Button Pressed", message: "", delegate: nil, cancelButtonTitle: "Ok", otherButtonTitles: "")
        //        alertView.show()
        
    }
    
    func gatewayDidReceiveMessages(_ array: [Any]!) {
        self.tableArray.addObjects(from: array)
        self.tableView.reloadData()
    }
    
    func gatewayDidUpdateStatus(for message: Message) {
        let indexPath: IndexPath = tableArray.indexPath(for: message)
        let cell: MessageCell = self.tableView.cellForRow(at: indexPath) as! MessageCell
        cell.updateMessageStatus()
    }
    
    func inputbarDidBecomeFirstResponder(_ inputbar: Inputbar!) {
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let providerid = objUserRecs.providerId
        SocketIOManager.sharedInstance.sendStartTypingMessage(Userid as String, taskerid: providerid as String,taskid: self.theme.CheckNullValue(RequiredJobid))
    }

    func inputbarTextEndEditingChat(_ inputbar: Inputbar!) {
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let providerid = objUserRecs.providerId
        SocketIOManager.sharedInstance.sendStopTypingMessage(Userid as String, taskerid: providerid as String,taskid: self.theme.CheckNullValue(RequiredJobid))
    }
}
