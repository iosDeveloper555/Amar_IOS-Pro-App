//
//  Constant.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/13/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit
var theme:Theme=Theme()
var Appdel=UIApplication.shared.delegate as! AppDelegate
var appNameJJ:String {
    get {
        //    return Language_handler.VJLocalizedString("app_name", comment: nil)
        return Bundle.appName()
    }
}

var ProductAppName:String{
    get {
        return Bundle.appName()
    }
}

var ProductShortAppName:String{
    get {
        return Language_handler.VJLocalizedString("HFA", comment: nil)
    }
}

var appNameShortJJ :String{
    get {
        return Language_handler.VJLocalizedString("app_name", comment: nil)
    }
}

var kOk : String{
    get {
        return Language_handler.VJLocalizedString("ok", comment: nil)
    }
}

var locationDisableTitle : String{
    get {
        return Language_handler.VJLocalizedString("location_disable_title", comment: nil)
    }
}

var MinimummobileValidation : Int{
    get {
        return 10
    }
}
var MaximummobileValidation : Int{
    get {
        return 13
    }
}

var MaximumNameValidation : Int{
    get {
        return 20
    }
}
var MaximumFirstNameValidation : Int{
    get {
        return 15
    }
}
var MaximumLastNameValidation : Int{
    get {
        return 15
    }
}

var locationDisableMessage : String{
    get {
        return Language_handler.VJLocalizedString("location_disable_message", comment: nil)
    }
}

var googleApiKey = "AIzaSyBy_qsFdWFB915HywbMpt5QVn0cNlpo0xE"
var GoogleApiURLKey = String()
let storeInfoURL = "https://itunes.apple.com/jp/lookup/?id=1157981860"

var kPageCount = "10"

var kErrorMsg:String {
    get{
        return Language_handler.VJLocalizedString("error_msg", comment: nil)
    }
}

var kNetworkFail:String{
    get{
        return Language_handler.VJLocalizedString("network_fail", comment: nil)
    }
}

var koops:String{
    get{
        return Language_handler.VJLocalizedString("oops", comment: nil)
    }
}

var noLeads : String{
    get{
        return Language_handler.VJLocalizedString("no_leads", comment: nil)
    }
}
var isLanguageManagement : Int {
    get{
        return 1
    }
}

var kNetworkErrorMsg = "No network connection... Please connect to network and try again"
var kNoNetwork = "NoNetworkNotif"
var kNewLeadsNotif = "NewLeadsNotif"
var kMyLeadsNotif = "MyLeadsNotif"
var kPaymentPaidNotif = "paymentPaidNotification"
var kAccountstatus = "AccountStatusNotification"
var kLocationNotification = "UpdateLocationNotification"
var kJobCancelNotif = "JobCancelNotificancion"
var kNewLeadsOpenNotifNotif = "kNewLeadsOpenNotifNotification"
var kChatFromOthers = "ChatFromOthersNotification"
var kTypeStatus = "TypingStatus"
var kPushNotification = "PushNotification"
let kOpenGoogleMapScheme = "comgooglemaps://"
var kLanguage = "ta"
var isDemoApp = 0 // 0-> Not a Demo  1-> Demo 
var AvailablityisMandatory : Int = 0

var xmppHostName = "homegenieflorida.com"  //67.219.149.186 //192.168.1.150
var xmppJabberId = "homegenieflorida.com"  //messaging.dectar.com //casp83

// local
//http://192.168.1.45:3004 -> Stalin
//http://192.168.1.221:3004 -> Jainul

//MARK:-local
//var MainUrl = "http://192.168.1.45:3004"
//var BaseUrl = "\(MainUrl)/mobile/"

//MARK:-Staging
//var MainUrl = "https://www.via-hive.com"
//var BaseUrl = "\(MainUrl)/mobile/"

//MARK:-live
//var MainUrl  = "https://www.via-hive.com"
//Live Server
//var MainUrl  = "https://www.via-hive.com"
//Dev
//var MainUrl = "http://67.202.39.104:3005"
//var BaseUrl = "\(MainUrl)/mobile/"

var MainUrl = "https://www.dev.via-hive.com"
var BaseUrl = "\(MainUrl)/mobile/"

let Roomname:NSString = "join network"

//MARK:-Api's
//http://162.243.206.138:3002/mobile/provider/register
var HomePageDatas = "\(BaseUrl)provider/provider-home"
var DailyEarningsUrl = "\(BaseUrl)provider/daily-earningsstats"
var MainEarningsUrl = "\(BaseUrl)provider/weekly-earningsstats"
var completionUrl = "\(BaseUrl)provider"
var RegUrl="\(BaseUrl)provider/register"
var LoginUrl="\(BaseUrl)provider/login"
var MobileLoginUrl="\(BaseUrl)app/check-tasker"
var ForgotpasswdUrl="\(BaseUrl)provider/forgot-password"
var ChangepasswdUrl = "\(BaseUrl)provider/change-password"
var updateProviderLocation="\(BaseUrl)provider/update-provider-geo"
var GetBankingDetails="\(BaseUrl)provider/get-banking-info"
var SaveBankingDetails="\(BaseUrl)provider/save-banking-info"
var getNewLeads="\(BaseUrl)provider/new-job"
var getMissLeads="\(BaseUrl)provider/missed-jobs"
var myJobsUrl="\(BaseUrl)provider/jobs-list"
var sortesList = "\(BaseUrl)provider/recent-list"
var viewProfile="\(BaseUrl)provider/provider-info"
var reviewsUrl="\(BaseUrl)provider/provider-rating"
var EarningStatsUrl="\(BaseUrl)provider/earnings-stats"
var JobsStatsUrl="\(BaseUrl)provider/jobs-stats"
var JobDetailUrl="\(BaseUrl)provider/view-job"
var GetEditInfoUrl="\(BaseUrl)provider/get-edit-info"
var AcceptRideUrl="\(BaseUrl)provider/accept-job"
var RejectJobUrl="\(BaseUrl)provider/reject-job"
var CancelReasonUrl="\(BaseUrl)provider/cancellation-reason"
var CancelJobUrl="\(BaseUrl)provider/cancel-job"
var StartDestinationUrl="\(BaseUrl)provider/start-off"
var ArrivedDestinationUrl="\(BaseUrl)provider/arrived"
var JobStartUrl="\(BaseUrl)provider/start-job"
var JobCompletedUrl="\(BaseUrl)provider/job-completed"
var PaymentCumMoreInfoUrl="\(BaseUrl)provider/job-more-info"
var stepByStepInfoUrl="\(BaseUrl)provider/job-timeline"
var RequestCashUrl="\(BaseUrl)provider/receive-cash"
var CashReceivedUrl="\(BaseUrl)provider/cash-received"
var RequestPaymentUrl="\(BaseUrl)provider/request-payment"
var GetRatingsOptionUrl="\(BaseUrl)get-rattings-options"
var SaveRatingsOptionUrl="\(BaseUrl)submit-rattings"
var UpdateImageUrlUrl="\(BaseUrl)provider/update_image"
var UpdateWorkingLocation="\(BaseUrl)provider/update_worklocation"
var UpdateBioUrl="\(BaseUrl)provider/update_bio"
var UpdateEmailUrl="\(BaseUrl)provider/update_email"
var UpdateUsernameUrl="\(BaseUrl)provider/update_username"
var UpdateRadiusUrl="\(BaseUrl)provider/update_radius"
var UpdateAddressUrl="\(BaseUrl)provider/update_address"
var UpdateMobileUrl="\(BaseUrl)provider/update_mobile"
var UpdateWorkingDays = "\(BaseUrl)provider/update-workingdadys"
var UpdateMobileOTPUrl="\(BaseUrl)provider/update_mobile"
var EnableAvailabilty="\(BaseUrl)provider/tasker-availability"
var GettingAvailablty="\(BaseUrl)provider/get-availability"
var Chat_Details="\(BaseUrl)chat/chathistory"
var UserAvailableUrl="\(BaseUrl)app/chat/availablity"
var ChatListUrl="\(BaseUrl)app/getmessage"
var UpdateMode="\(BaseUrl)user/notification_mode"
var Logout_url="\(BaseUrl)app/provider/logout"
var Appinfo_url="\(BaseUrl)app/mobile/appinfo"
var Get_TransactionUrl="\(BaseUrl)app/provider-transaction"
var View_Transaction_Detail="\(BaseUrl)app/providerjob-transaction"
var Get_NotificationsUrl="\(BaseUrl)app/notification"
var Get_ReviewsURl="\(BaseUrl)app/get-reviews"
var get_mainCategory="\(BaseUrl)provider/get-maincategory"
var Get_SubCategory="\(BaseUrl)provider/get-subcategory"
var deleteCategory="\(BaseUrl)tasker/delete-category"
var add_Category="\(BaseUrl)tasker/add-category"
var getSubCategory_Dtl="\(BaseUrl)provider/get-subcategorydetails"
var getEditCategory_Detail="\(BaseUrl)tasker/category-detail"
var update_Category="\(BaseUrl)tasker/update-category"
var about_usURL="\(BaseUrl)app/mobile/aboutus"
var termsurl = "\(BaseUrl)app/mobile/termsandconditions"
var privacyurl = "\(BaseUrl)app/mobile/privacypolicy"
var reg_form1 = "\(BaseUrl)provider/register/form1"
var reg_form2 = "\(BaseUrl)provider/register/form2"
var reg_form3 = "\(BaseUrl)provider/register/form3"
var reg_form4 = "\(BaseUrl)provider/register/save"
var registration_Qestion = "\(BaseUrl)provider/register/questions"
var catergory_Url = "\(BaseUrl)provider/register/parent-category"
var subCatergory_Url = "\(BaseUrl)provider/register/child-category"
var registerExperience="\(BaseUrl)provider/register/experience"
var registerImageupload = "\(BaseUrl)provider/register/image-upload"
//var finalCall = "\(BaseUrl)provider/register/save"
var GetCategories = "\(BaseUrl)app/categories"
var Aggremant_Domain = "\(BaseUrl)app/mobile/contractoragreement"
var updatePersonalInformation = "\(BaseUrl)provider/update_personalinfo"

//New
var GetDocumentsList = "\(BaseUrl)provider/document-list"
var uploadDocument = "\(BaseUrl)provider/upload-document"
var updateDocument = "\(BaseUrl)provider/update-document"
var editDocument = "\(BaseUrl)provider/upload-editdocument"




var GetDocReqById="\(BaseUrl)provider/categories/getchild"
var UploadDocReqById="\(BaseUrl)provider/uploadDocumentPic"
var UploadMyAllDocReqById="\(BaseUrl)provider/updateMyDocuments"

var getMyDocumentsById="\(BaseUrl)provider/getMyDocuments"
var checkExpireDocumentsId="\(BaseUrl)provider/checkExpireDocuments"

var background_check_payment="\(BaseUrl)provider/background-check"



var Appname:String {
    get {
        return theme.setLang("app_name")
    }
}


//http://162.243.206.138:3002/mobile/chat/chathistory



class MyTextField: UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}


struct JSON {
    static let encoder = JSONEncoder()
}
extension Encodable {
    subscript(key: String) -> Any? {
        return dictionary[key]
    }
    var dictionary: [String: Any] {
        return (try? JSONSerialization.jsonObject(with: JSON.encoder.encode(self))) as? [String: Any] ?? [:]
    }
}


//struct UpdateSSN: Codable {
//    let ssn, addressApt, addressCity, addressState: String?
//    let addressZipcode, addressLine1, providerID: String?
//    let taskerID: String?
//
//    enum CodingKeys: String, CodingKey {
//        case ssn
//        case addressApt = "address[apt]"
//        case addressCity = "address[city]"
//        case addressState = "address[state]"
//        case addressZipcode = "address[zipcode]"
//        case addressLine1 = "address[line1]"
//        case providerID = "provider_id"
//        case taskerID = "tasker_id"
//    }
//
//    var asDictionary : [String:Any] {
//        let mirror = Mirror(reflecting: self)
//        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
//          guard let label = label else { return nil }
//          return (label, value)
//        }).compactMap { $0 })
//        return dict
//      }
//}


struct UpdateSSN: Codable {
    let ssn: String?
    let address: Address?
    let providerID: String?
    
    enum CodingKeys: String, CodingKey {
        case ssn, address
        case providerID = "provider_id"
    }
    
    
}

// MARK: - Address
struct Address: Codable {
    let apt, city, state, zipcode: String?
    let line1: String?
}
