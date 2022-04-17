//
//  ChatListViewController.swift
//  PlumberJJ
//
//  Created by Aravind Natarajan on 02/02/16.
//  Copyright © 2016 Casperon Technologies. All rights reserved.
//

import UIKit
import SDWebImage


class ChatListViewController: RootBaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    var chatListArr:NSMutableArray=NSMutableArray()
    var nameArray:NSMutableArray=NSMutableArray()
    var p_idArray:NSMutableArray=NSMutableArray()
    var job_idArray:NSMutableArray=NSMutableArray()
    var msgArray:NSMutableArray=NSMutableArray()
    var msg_timeArray:NSMutableArray=NSMutableArray()
    var imageArray:NSMutableArray=NSMutableArray()
    var user_idArray : NSMutableArray = NSMutableArray()
    var Category_idArray : NSMutableArray = NSMutableArray()
    var created_dateArray : NSMutableArray = NSMutableArray()
    var tasker_statusArray : NSMutableArray = NSMutableArray()
    var GetlastmesgfromArray : NSMutableArray = NSMutableArray()
    @IBOutlet weak var titleHeader: UILabel!

    @IBOutlet weak var headerviewheight: NSLayoutConstraint!
    
    @IBOutlet weak var chatListTblView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.theme.yesTheDeviceisHavingNotch(){
            headerviewheight.constant = 100
        }
        
        titleHeader.text = Language_handler.VJLocalizedString("chat", comment: nil)
                // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let Nb=UINib(nibName: "ChatListTableViewCell", bundle: nil)
        self.chatListTblView.register(Nb, forCellReuseIdentifier: "ChatCell")
        self.chatListTblView.estimatedRowHeight=120
        self.chatListTblView.rowHeight = UITableView.automaticDimension
        self.chatListTblView.separatorColor=UIColor.lightGray
        self.chatListTblView.tableFooterView=UIView()
        
        self.GetChatList()
        

    }
    func GetChatList(){
        
        
        chatListArr=NSMutableArray()
        nameArray=NSMutableArray()
        p_idArray=NSMutableArray()
        job_idArray=NSMutableArray()
        msgArray=NSMutableArray()
        msg_timeArray=NSMutableArray()
        imageArray=NSMutableArray()
        user_idArray   = NSMutableArray()
        Category_idArray = NSMutableArray()
        created_dateArray = NSMutableArray()
        tasker_statusArray = NSMutableArray()
        GetlastmesgfromArray = NSMutableArray()
        

        
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        
        let param=["type":"0","userId":"\(objUserRecs.providerId)"]
        // print(Param)
        
        url_handler.makeCall(ChatListUrl, param: param as NSDictionary) {
            (responseObject, error) -> () in
            self.DismissProgress()
            
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                 if(responseObject != nil)
                    {
                        let responseObject = responseObject!
                    let Dict:NSDictionary=responseObject
                    
                        let Status=self.theme.CheckNullValue(Dict.object(forKey: "status") as AnyObject) as NSString
                    
                    
                    
                    if(Status == "1")
                    {
                        
                        let ChatList: NSMutableArray = ((Dict.object(forKey: "response")! as AnyObject).object(forKey: "message") as? NSMutableArray)!
                       
                            for  Dict in ChatList
                            {
                                
                                let image=self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "user_image") as AnyObject)
                                let name=self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "user_name") as AnyObject)
                                let p_id=self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "task_id") as AnyObject)
                                let job_id=self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "booking_id") as AnyObject)
                                let userid=self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "user_id") as AnyObject)
                                let category=self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "category") as AnyObject)
                                let created_date = self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "created") as AnyObject)
                                let tasker_status = self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "tasker_status") as AnyObject)
                                let lastmsgfrom = self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "last_message_from") as AnyObject)
                                

                                
                                self.nameArray.add(name)
                                self.p_idArray.add(p_id)
                                self.job_idArray.add(job_id)
                                //self.msgArray.addObject(msg)
                                //                            self.msg_timeArray.addObject(msg_time)
                                self.imageArray.add(image)
                                self.user_idArray.add(userid)
                                self.Category_idArray.add(category)
                                self.created_dateArray.add(created_date)
                                self.tasker_statusArray.add(tasker_status)
                                self.GetlastmesgfromArray.add(lastmsgfrom)

                            }
                            self.chatListTblView.reloadData()
                        
                      
                        
                    }
                    else
                    {
                        
                        let Response:NSString = self.theme.CheckNullValue((Dict as AnyObject).object(forKey: "response") as AnyObject) as NSString
//                        self.view.makeToast(message:"\(Response)", duration: 3, position: HRToastPositionDefault as AnyObject, title: "Oops!!!")
                        
                        
                    }
                    
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    
                }
            }
            
        }
    }
    
    @IBAction func didClickbackBtn(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        // Present the view controller
        //
        self.frostedViewController.presentMenuViewController()    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if(self.p_idArray.count > 0){
            chatListTblView.backgroundView = nil
            chatListTblView.separatorStyle = .singleLine
            return 1
        }else{
            loadNoData()
        }
        return 1
    }
    func loadNoData() {
        let nibView = Bundle.main.loadNibNamed("EmptyDataView", owner: self, options: nil)![0] as! EmptyDataView
        nibView.frame = self.chatListTblView.bounds;
        nibView.msgLbl.text = self.theme.setLang("not_yet_chat")
        nibView.msgLbl.font = PlumberLargeFont
        self.chatListTblView.backgroundView=nibView
        chatListTblView.backgroundView = nibView
        chatListTblView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.p_idArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatListTableViewCell
        
        Cell.Provider_image.sd_setImage(with: URL(string: "\(imageArray[indexPath.row])"), placeholderImage: UIImage(named: "PlaceHolderSmall"))
        
        //Cell.Provider_image.sd_setImageWithURL(NSURL(string: "\(imageArray[indexPath.row])"), completed: themes.block)
        Cell.Chat_Lbl.text="\(nameArray[indexPath.row])"
        Cell.Provider_image.layer.cornerRadius = Cell.Provider_image.frame.size.height / 2;
        Cell.Provider_image.layer.masksToBounds = true;
        Cell.Provider_image.layer.borderWidth = 0;
        Cell.Provider_image.contentMode = UIView.ContentMode.scaleAspectFill
        Cell.selectionStyle=UITableViewCell.SelectionStyle.none
        
        Cell.Time_Lab.text = "\(job_idArray[indexPath.row])"
        Cell.catagory_labl.text="\(Category_idArray[indexPath.row])"
        Cell.created_date.text = "\(created_dateArray[indexPath.row])"
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        
       
        if (tasker_statusArray.object(at: indexPath.row) as! String == "1" && GetlastmesgfromArray.object(at: indexPath.row) as! String  != "\(objUserRecs.providerId)")
        {
            Cell.border_view.backgroundColor = PlumberThemeColor
        }
        else{
            Cell.border_view.backgroundColor = UIColor.clear
        }
        Cell.border_view.layer.cornerRadius = Cell.border_view.frame.size.width/2
        Cell.border_view.clipsToBounds=true
        
        
        return Cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let objChatVc = self.storyboard!.instantiateViewController(withIdentifier: "ChatVCSID") as! MessageViewController
        objChatVc.jobId=self.job_idArray[indexPath.row] as! String
        objChatVc.Userid = self.user_idArray[indexPath.row] as? String
        objChatVc.username = self.nameArray[indexPath.row] as? String
        objChatVc.Userimg = self.imageArray[indexPath.row] as? String
        objChatVc.RequiredJobid = self.p_idArray[indexPath.row] as? String
        self.navigationController!.pushViewController(withFade: objChatVc, animated: false)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
