
//
//  RatingsViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 12/11/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//


import UIKit
import AssetsLibrary
import Foundation
import Alamofire
import SDWebImage

class RatingsViewController: RootBaseViewController,RateDelegate,UITextViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet weak var TitleView: UIView!
    @IBOutlet weak var TitleLabel: UILabel!
    @IBOutlet weak var selectedRatingView: UIView!
    @IBOutlet weak var commentsView: UIView!
    @IBOutlet weak var SubmitView: UIView!
    @IBOutlet weak var selectedRatingImage: UIImageView!
    @IBOutlet weak var selectedRatingLbl: UILabel!
    @IBOutlet weak var RatinsPopUpView: UIView!
    //NSLayoutContstrains
    @IBOutlet weak var HeaderLblHeight: NSLayoutConstraint!
    @IBOutlet weak var selectedRateHeight: NSLayoutConstraint!
    @IBOutlet weak var commentsViewHeight: NSLayoutConstraint!
    @IBOutlet weak var SubmitViewHeight: NSLayoutConstraint!
    @IBOutlet weak var MainPopUpHeight: NSLayoutConstraint!
    @IBOutlet weak var emojiViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var EmojiView: EmojiRateView!
    
     var jobIDStr:String = ""
    @IBOutlet weak var ratingBtn: UIButton!
    let imagePicker = UIImagePickerController()
    //var theme:Theme=Theme()
    var get_imagedata : Data = Data()
    var get_pickerimage: UIImage?
    var RatingStr = String()
    var ratingsOptArr:NSMutableArray = [];
    @IBOutlet weak var reviewTxtView: UITextView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        theme.addGradient(self.SubmitView, colo1: PlumberLightThemeColor, colo2: PlumberThemeColor, direction: .LefttoRight, Frame: CGRect(x: 0, y: 0, width: self.SubmitView.frame.width, height: self.SubmitViewHeight.constant), CornerRadius: true, Radius: self.SubmitViewHeight.constant/2)
        self.SubmitView.setNeedsLayout()
        self.SubmitView.layoutIfNeeded()
    }
   
    override func viewDidLoad() {
        
        
        self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.ratingBtn.isHidden=true
        super.viewDidLoad()
        ratingBtn.setTitle(theme.setLang("submit"), for: UIControl.State())
        self.TitleLabel.text = theme.setLang("how_was_job")
        reviewTxtView.font = PlumberMediumFont
        reviewTxtView.text = self.theme.setLang("comment_Opt")
        reviewTxtView.textContainerInset = UIEdgeInsets(top: 10,left: 15,bottom: 0,right: 0);
        reviewTxtView.textColor = .gray
        imagePicker.delegate=self
        reviewTxtView.delegate = self
        reviewTxtView.layer.masksToBounds=true

        imagePicker.delegate=self
        GetRatingsOption()
        self.ratingBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        self.SubmitView.layer.cornerRadius = self.SubmitView.frame.height/2
        self.RatinsPopUpView.layer.cornerRadius = 8
        self.TitleView.isHidden = false
        self.HeaderLblHeight.constant = 70
        self.selectedRatingView.isHidden = true
        self.selectedRateHeight.constant = 0
        self.EmojiView.isHidden = false
        self.emojiViewHeight.constant = 45
        self.commentsView.isHidden = true
        self.commentsViewHeight.constant = 0
        self.SubmitView.isHidden = true
        self.SubmitViewHeight.constant = 0
        self.MainPopUpHeight.constant = self.HeaderLblHeight.constant + self.emojiViewHeight.constant + 150
        EmojiView.Delegate = self
        EmojiView.chooseEmojiAt(index: 4)
        theme.addGradient(self.SubmitView, colo1: PlumberLightThemeColor, colo2: PlumberThemeColor, direction: .LefttoRight, Frame: CGRect(x: 0, y: 0, width: self.SubmitView.frame.width, height: self.SubmitViewHeight.constant), CornerRadius: true, Radius: self.SubmitViewHeight.constant/2)
        // Do any additional setup after loading the view.
    }
    
    func RateData(selectedEmoji: UIImage, selectedRate: Int) {
        print("The selectedRate is --->\(selectedRate)")
        self.ratingBtn.contentHorizontalAlignment = UIControl.ContentHorizontalAlignment.center
        self.RatingStr = theme.CheckNullValue(selectedRate)
        //--TitleView
        self.TitleView.isHidden = true
        self.HeaderLblHeight.constant = 0
        self.TitleView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.25, animations: {
            self.TitleView.layoutIfNeeded()
        })
        //--selectedRatingView
        self.selectedRatingView.isHidden = false
        self.selectedRateHeight.constant = 80
        self.selectedRatingView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.25, animations: {
            self.selectedRatingView.layoutIfNeeded()
        })
        //--commentsView
        self.commentsView.isHidden = false
        self.commentsViewHeight.constant = 70
        self.commentsView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.25, animations: {
            self.commentsView.layoutIfNeeded()
        })
        //--SubmitView
        self.SubmitView.isHidden = false
        self.SubmitViewHeight.constant = 40
        theme.addGradient(self.SubmitView, colo1: PlumberLightThemeColor, colo2: PlumberThemeColor, direction: .LefttoRight, Frame: CGRect(x: 0, y: 0, width: self.SubmitView.frame.width, height: self.SubmitViewHeight.constant), CornerRadius: true, Radius: self.SubmitViewHeight.constant/2)
        self.SubmitView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.25, animations: {
            self.SubmitView.layoutIfNeeded()
        })
        self.MainPopUpHeight.constant = self.selectedRateHeight.constant + self.emojiViewHeight.constant + self.commentsViewHeight.constant + 100
        self.RatinsPopUpView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.25, animations: {
            self.RatinsPopUpView.layoutIfNeeded()
        })
        //----------------------------------------------
        self.selectedRatingImage.image = selectedEmoji
        if self.RatingStr == "1"{
            self.selectedRatingLbl.text = theme.setLang("Terrible")
        }else if self.RatingStr == "2"{
            self.selectedRatingLbl.text = theme.setLang("Bad")
        }else if self.RatingStr == "3"{
            self.selectedRatingLbl.text = theme.setLang("Okay")
        }else if self.RatingStr == "4"{
            self.selectedRatingLbl.text = theme.setLang("Good")
        }else if self.RatingStr == "5"{
            self.selectedRatingLbl.text = theme.setLang("Great")
        }
    }
    
    func GetRatingsOption(){
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["holder_type":"provider", "user":
            objUserRecs.providerId,"job_id":jobIDStr] as [String : Any]
       
        self.showProgress()
        url_handler.makeCall(GetRatingsOptionUrl, param: Param  as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    if(status == "1")
                    {
                        let  listArr:NSArray=(responseObject.object(forKey: "review_options") as? NSArray)!
                        if(listArr.count>0){
                             self.ratingBtn.isHidden=false
                            
                            for (_, element) in listArr.enumerated() {
                                let result1:RatingsRecord=RatingsRecord()
                                result1.title=self.theme.CheckNullValue((element as AnyObject).object(forKey: "option_title"))
                                let optionInt : Int = ((element as AnyObject).object(forKey: "option_id")) as! Int
                                let strOptionId = "\(optionInt)"
                                result1.optionId=self.theme.CheckNullValue(strOptionId)
                                result1.rateCount = String(5)
                                self.ratingsOptArr .add(result1)
                            }
                        }else{
                            self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                        }
                        //This code will run in the main thread:
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
            
        }
    }
    
    func PassRating(){
        
    }
    
    
    func SaveUserRatings(){
                let param : NSDictionary =  self.dictForrating()
                 NSLog("getDevicetoken =%@", self.dictForrating())
                self.showProgress()
                let objUserRecs:UserInfoRecord=theme.GetUserDetails()
//        ["devicetype": "ios", "device":"\(theme.GetDeviceToken())", "user":"\(user_id)" , "type":"tasker"]
        let URL = try! URLRequest(url: SaveRatingsOptionUrl, method: .post, headers: ["devicetype": "ios", "device":"\(theme.GetDeviceToken())", "user":"\(objUserRecs.providerId)", "type":"tasker"])
            
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(self.get_imagedata, withName: "file", fileName: "file.png", mimeType: "")
            
            for (key, value) in param {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
            
        }, with: URL, encodingCompletion: { encodingResult in
            
                switch encodingResult {
                case .success(let upload, _, _):
                print("s")
                upload.responseJSON { response in
                if let J = response.result.value {
                
                    let JSON = J as! NSDictionary
                self.DismissProgress()
                print("JSON: \(JSON)")
                    let Status = self.theme.CheckNullValue(JSON.object(forKey: "status"))
                let response = JSON.object(forKey: "response") as! NSDictionary
                if(Status == "1")
                {
                //        self.view.makeToast(message:self.themes.CheckNullValue(response.objectForKey("msg"))!, duration: 4, position: HRToastPositionDefault as AnyObject, title: "")
                    self.navigationController?.popToRootViewController(animated: true)
                    self.theme.ShowNotification(Title: self.theme.setLang("rating"), message: self.theme.CheckNullValue(response.object(forKey: "msg")), Indentifier: "")
                    
                    SessionManager.sharedinstance.isReviewSkipped = false
                }
                else
                {
                    self.theme.AlertView(appNameJJ, Message: self.theme.CheckNullValue(response.object(forKey: "msg")), ButtonTitle: kOk)
//                    self.view.makeToast(message:self.theme.CheckNullValue(response.object(forKey: "msg")), duration: 4, position: HRToastPositionDefault as AnyObject, title: "")
                }
                }
                }
                
                case .failure(let encodingError):
                self.DismissProgress()
                print(" the encodeing error is \(encodingError)")
                
                self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
        })
    }
    @IBAction func didClickBackbtn(_ sender: AnyObject) {
    
         self.navigationController?.popToRootViewController(animated: true)
         SessionManager.sharedinstance.isReviewSkipped = true
    }
    @IBAction func didClickRateUserBtn(_ sender: AnyObject) {
//        self.theme.AlertView("\(appNameJJ)", Message:"\(theme.setLang("Your Rating Submitted Successfully"))", ButtonTitle: kOk)
                SaveUserRatings()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dictForrating()->NSDictionary{
        var cmtstr:NSString=""
        if(reviewTxtView.text=="comment_Opt"){
            cmtstr=""
        }else{
            cmtstr=reviewTxtView.text! as NSString
        }
        
        let reviewDict:NSMutableDictionary=NSMutableDictionary()
        for i in 0 ..< ratingsOptArr.count {
            let str1: String = "ratings[\(i)][option_title]"
            let str2: String = "ratings[\(i)][option_id]"
            let str3: String = "ratings[\(i)][rating]"
            let objRatingsRecs: RatingsRecord = ratingsOptArr[i] as! RatingsRecord
            reviewDict.setValue(objRatingsRecs.title, forKey:str1)
            reviewDict.setValue(objRatingsRecs.optionId,forKey:str2)
            reviewDict.setValue(self.RatingStr, forKey: str3)
        }
        reviewDict.setValue("tasker", forKey: "ratingsFor")
        reviewDict.setValue(jobIDStr, forKey: "job_id")
        reviewDict.setValue(cmtstr, forKey: "comments")
        reviewDict.setValue("ios", forKey: "type") 

        

        return reviewDict
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(range.location==0 && text==" "){
            return false
        }
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        if (range.location >= 200 && text != " "){
            return false
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    func ratingsCount(_ withRateVal:Float , withIndex:IndexPath){
        
        let objRatingsRecs: RatingsRecord = ratingsOptArr[withIndex.row] as! RatingsRecord
        objRatingsRecs.rateCount = String (withRateVal)
        ratingsOptArr.replaceObject(at: withIndex.row, with: objRatingsRecs)
    }
    func validateTxtFields () -> Bool{
    var isOK:Bool=true
        if(reviewTxtView.text.count==0){
            ValidationAlert(Language_handler.VJLocalizedString("review_mand", comment: nil))
            isOK = false
            return isOK
        }
//        for var i = 0; i < ratingsOptArr.count; i++ {
//            let objRatingsRecs: RatingsRecord = ratingsOptArr[i] as! RatingsRecord
//            let rateVal: Float = Float(objRatingsRecs.rateCount as String)!
//            if rateVal == 0 {
//                ValidationAlert("\(objRatingsRecs.title) is mandatory")
//                isOK = false
//                 break;
//            }
//        }
        
        
        
        
        
        
        
        
    return isOK
    }
    
    func ValidationAlert(_ alertMsg:String){
        let popup = NotificationAlertView.popupWithText("\(alertMsg)")
        popup.hideAfterDelay = 3
        //popup.position = NotificationAlertViewPosition.Bottom
        popup.animationDuration = 1
        popup.show()
    }
    
 
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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
