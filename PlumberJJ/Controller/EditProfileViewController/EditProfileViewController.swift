        //
//  EditProfileViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/25/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit
import MobileCoreServices
import AssetsLibrary
import Foundation
//import WDImagePicker
import AVFoundation
//import GradientCircularProgress
import Alamofire
import SDWebImage
import Photos
//import PhoneNumberKit
import GoogleMaps

extension NSMutableData {
    func appendString(_ string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
    }
}
extension UITextField
{
    func roundTheViews(){
        self.layer.cornerRadius=3
        self.layer.borderWidth=0.5
        self.layer.borderColor=UIColor.lightGray.cgColor
        self.layer.masksToBounds=true
    }
}

protocol LoadProfileDatas {
    func Refresh()
}

private var selectedDaysArr = [Int]()

class EditProfileViewController: RootBaseViewController,UIActionSheetDelegate,UITextViewDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDelegate,UITableViewDataSource,WDImagePickerDelegate,UIScrollViewDelegate,SelectedSlotDetailsDelegate {
    
    //MARK: - Outlet
    var locationManager = CLLocationManager()

    @IBOutlet weak var viewradius: UIView!
    @IBOutlet weak var sliderradius: UISlider!
    @IBOutlet weak var lblradius: UILabel!
    @IBOutlet var map_animation_view : CSAnimationView!
    @IBOutlet weak var markerView: CSAnimationView!

    @IBOutlet var viewMap1:GMSMapView!
    @IBOutlet var btnPin:UIButton!

    
    @IBOutlet var Placesearch_tableview: UITableView!
    
    @IBOutlet weak var location_leading: NSLayoutConstraint!
    @IBOutlet var Location_tableview: UITableView!
    @IBOutlet var place_searchview: UIView!
    @IBOutlet var editAvailabilitytableview: UITableView!
    @IBOutlet var working_loca: UITextField!
    @IBOutlet weak var bannerImg: UIImageView!
    @IBOutlet weak var userImg: UIImageView!
    @IBOutlet weak var editProfileScrollView: UIScrollView!
    
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var phoneTxtField: UITextField!
    @IBOutlet weak var addressTxtField: UITextField!
    @IBOutlet weak var cCodeTxtField: UITextField!
    @IBOutlet weak var countryTxtField: UITextField!
    @IBOutlet weak var postalCodeTxtField: UITextField!
    @IBOutlet weak var stateTxtField: UITextField!
    @IBOutlet weak var cityTxtField: UITextField!
    @IBOutlet weak var lastname_txt: UITextField!
    
    
    
    @IBOutlet weak var lastView: UIView!
    @IBOutlet weak var lasetName_Lbl: UILabel!
    @IBOutlet var category_TblView: UITableView!
    @IBOutlet weak var category_View: UIView!
    //let progressbar = GradientCircularProgress()
      let picker = UIImagePickerController()
    
    var selectedBtn = NSMutableArray()
    var getTextfieldtag : NSString = NSString()
    var availabilityStorage:NSArray!
    var category_Array:NSMutableArray = NSMutableArray()
    var editCatDtls_Array:NSMutableArray = NSMutableArray()
    var delegate:LoadProfileDatas?
    var imagePicker = WDImagePicker()
    
    @IBOutlet weak var btnUpdate3: UIButton!
    @IBOutlet weak var btnUpdate2: UIButton!
    @IBOutlet weak var btnUpdate4: UIButton!
    @IBOutlet weak var btnUpdate5: UIButton!
    @IBOutlet weak var btnUpdate6: UIButton!
    @IBOutlet weak var btnUpdate7: UIButton!

    @IBOutlet  var worklbl: UILabel!
    @IBOutlet  var categorylbl: UIButton!
    @IBOutlet  var avail: UILabel!
    @IBOutlet  var editprofile: UILabel!
    @IBOutlet weak var category_height: NSLayoutConstraint!
    @IBOutlet weak var lblEmail: SMIconLabel!
    @IBOutlet weak var lblMobile: SMIconLabel!
    @IBOutlet weak var lblAddress: SMIconLabel!
    @IBOutlet weak var lbluserName: SMIconLabel!
    @IBOutlet weak var lblRadius: SMIconLabel!
//    @IBOutlet var AvailCollectionView: AvailCollectionView!
    var availInc = Int()
//    var isPhoneVerified = false
    
    @IBOutlet weak var EditTableViewHeight: NSLayoutConstraint!
    var heightConstraint : NSLayoutConstraint!
    var SlotArray = [Slots]()
    
    private var selectedDayIndex:Int?
    private var isWholeSelected = false{
        didSet{
            if isWholeSelected == true{
//                resetAvailability()
            }
        }
    }
    
    var AvailablityArray = [AvailableRec]()
    var tempAvailablityArray = [AvailableRec]()
    var tempSlotArray = [Slots]()
    
    @IBOutlet var usernameTxtfield: UITextField!
    @IBOutlet var radiusTxtfield: UITextField!
    @IBOutlet weak var backBtn: UIButton!
    
    var tField: UITextField!
    var otpStr : String = String()
    var otp_status : String = String()
    var imagedata : Data = Data()
    var Contact:String=String()
    var Addaddress_Data : Addaddress = Addaddress()
    var categoryArray: NSMutableArray = NSMutableArray()
    
    enum PlaceType: CustomStringConvertible {
        case all
        case geocode
        case address
        case establishment
        case regions
        case cities
        
        var description : String {
            switch self {
            case .all: return ""
            case .geocode: return "geocode"
            case .address: return "address"
            case .establishment: return "establishment"
            case .regions: return "regions"
            case .cities: return "cities"
            }
        }
    }
    
    struct Place {
        let id: String
        let description: String
    }
    
    var places = [Place]()
    var setstatus:Bool=Bool()
    var placeType: PlaceType = .all
    
    
        // New fields for SSN etc
    
    
    @IBOutlet weak var ssnTextFiled: UITextField!
    @IBOutlet weak var aptTextField: UITextField!
    
    @IBOutlet weak var cityTextField: UITextField!
    
    @IBOutlet weak var stateTextFiled: UITextField!
    
    @IBOutlet weak var zipCodeTextField: UITextField!
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var referralTextField: UITextField!
    var radius = 10
    
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tempAvailablityArray = AvailablityArray
        
        selectedDaysArr.removeAll()
        for i in 0..<AvailablityArray.count{
              let index = i
            if AvailablityArray[index].selected == true {
            selectedDaysArr.append(index)
            }
        }
        self.picker.delegate = self
        self.picker.mediaTypes = [kUTTypeImage as String]
        editProfileScrollView.delegate = self
        
        editProfileScrollView.minimumZoomScale = 1.0
        editProfileScrollView.maximumZoomScale = 10.0
        self.editprofile.text = self.theme.setLang("edit_profile")
        lbluserName.text = Language_handler.VJLocalizedString("firstNAme", comment: nil)
        lasetName_Lbl.text = Language_handler.VJLocalizedString("lastName", comment: nil)
        lblRadius.text = Language_handler.VJLocalizedString("radius", comment: nil)
        
        lblEmail.text = Language_handler.VJLocalizedString("email", comment: nil)
        lblMobile.text = Language_handler.VJLocalizedString("mobile", comment: nil)
        lblAddress.text = Language_handler.VJLocalizedString("address", comment: nil)
        
        btnUpdate2.setTitle(Language_handler.VJLocalizedString("update", comment: nil), for: UIControl.State())
        btnUpdate3.setTitle(Language_handler.VJLocalizedString("update", comment: nil), for: UIControl.State())
        btnUpdate4.setTitle(Language_handler.VJLocalizedString("update", comment: nil), for: UIControl.State())
        
        btnUpdate5.setTitle(Language_handler.VJLocalizedString("update", comment: nil), for: UIControl.State())
        btnUpdate6.setTitle(Language_handler.VJLocalizedString("update", comment: nil), for: UIControl.State())
        
        
        btnUpdate7.setTitle(Language_handler.VJLocalizedString("update", comment: nil), for: UIControl.State())

        self.backBtn.tintColor = PlumberThemeColor
        worklbl.text=theme.setLang("working_loc")
        avail.text=theme.setLang("availability")
        
        categorylbl.setTitle(theme.setLang("category"), for: UIControl.State())
        imagePicker.delegate = self
        self.blurBannerImg()
        decorateTxtField()
        GetDatasForBanking()
        editAvailabilitytableview.register(UINib(nibName: "EditAvailabilityTableViewCell", bundle: nil), forCellReuseIdentifier: "availabledayscell")
        category_TblView.register(UINib(nibName: "CategoryListTableViewCell", bundle: nil), forCellReuseIdentifier: "CategoryListTableViewCell")
        category_TblView.delegate = self
        category_TblView.dataSource = self
        editAvailabilitytableview.delegate = self
        editAvailabilitytableview.dataSource = self
        editAvailabilitytableview.reloadData()
        
        Placesearch_tableview.isHidden=true
        Placesearch_tableview.tableFooterView=UIView()
        Placesearch_tableview.layer.borderWidth=1.0
        Placesearch_tableview.layer.borderColor=UIColor.black.cgColor
        Placesearch_tableview.layer.cornerRadius=5.0
        
        Location_tableview.isHidden=true
        Location_tableview.tableFooterView=UIView()
        Location_tableview.layer.borderWidth=1.0
        Location_tableview.layer.borderColor=UIColor.black.cgColor
        Location_tableview.layer.cornerRadius=5.0
        // Do any additional setup after loading the view.
        
        addressTxtField.addTarget(self, action: #selector(TextfieldDidChange(_:)), for: UIControl.Event.editingChanged)
        working_loca.addTarget(self, action: #selector(TextfieldDidChange(_:)), for: UIControl.Event.editingChanged)
        
        Placesearch_tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        Location_tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        radius = Int(sliderradius.value)
        
        self.lblradius.text = "\(radius)"
        
        
        //MARK: - Map setup
        markerView.isUserInteractionEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.theme.MakeAnimation(view: self.map_animation_view, animation_type: CSAnimationTypePop)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.markerView.isHidden = false
               self.theme.MakeAnimation(view: self.markerView, animation_type: CSAnimationTypeBounceDown)
            })
        })
        viewMap1.delegate = self
        
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                
                let alertView = UNAlertView(title: Appname, message: "\(theme.setLang("location_service_disabled"))\n \(theme.setLang("to_reenable_location"))")
                alertView.addButton(theme.setLang("ok"), action: {
                    UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                })
                
                alertView.show()
            case .authorizedAlways, .authorizedWhenInUse:
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startMonitoringSignificantLocationChanges()
                locationManager.startUpdatingLocation()
            }
        } else {
            
            let alertView = UNAlertView(title: Appname, message: "\(theme.setLang("location_service_disabled"))\n \(theme.setLang("to_reenable_location"))")
            alertView.addButton(theme.setLang("ok"), action: {
                UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
                
            })
             alertView.show()
        }
    }
    
    //MARK: - radiusSliderAct
    
    
    @IBAction func radiusSlkiderAct(_ sender: UISlider)
    {
        
        radius = Int(sliderradius.value)

        self.lblradius.text = "\(radius)"
    }
    func set_mapView(_ lat:String,long:String){
        let UpdateLoc = CLLocationCoordinate2DMake(CLLocationDegrees(lat as String)!,CLLocationDegrees(long as String)!)
        let camera = GMSCameraPosition.camera(withTarget: UpdateLoc, zoom:10.0)
        viewMap1.animate(to: camera)
        viewMap1.isMyLocationEnabled = true
        viewMap1.mapType = .normal

        viewMap1.settings.setAllGesturesEnabled(true)
        viewMap1.settings.scrollGestures=true
    }
    
//    @IBAction func onTapVerifyPhoneNum(_ sender: UIButton) {
//        
//        if (phoneTxtField.text?.count)! <= MinimummobileValidation{
//            let phoneNumberKit = PhoneNumberKit()
//            let countryInt = UInt64 (cCodeTxtField.text!)
//            let country =  phoneNumberKit.mainCountry(forCode: countryInt!)
//            
//            let regionCode = self.theme.CheckMobileNoAndCountryCodeIsValid(countryCode: cCodeTxtField.text!, phoneNumber: phoneTxtField.text!)
//            if regionCode == country ?? ""{
////                self.getOtpPhone()
//            }
//            else{
//                self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("Mobile No Doesn't Match With Country Code", comment: nil), ButtonTitle: kOk)
//            }
//        }
//        else{
//            self.theme.AlertView(appNameJJ, Message: Language_handler.VJLocalizedString("valid_Mobile", comment: nil), ButtonTitle: kOk)
//        }
//        isPhoneVerified = true
//    }
    
    @objc func OpenUpCollectionViewController(sender : UIButton){
        let index = sender.tag
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AvailablityVCID") as?  AvailablityViewController{
            if let navigator = self.navigationController
            {
                let backItem = UIBarButtonItem()
                backItem.title = ""
                self.navigationItem.backBarButtonItem = backItem
                viewController.selectedDayRec = AvailablityArray[index]
                viewController.SelectedDateindex = index
                viewController.Delegate = self
                navigator.pushViewController(withFade: viewController, animated: false)
            }
        }
    }
    
    func SelectedStols(SlotRec: AvailableRec, at index: Int, status: String) {
        self.AvailablityArray.remove(at: index)
        self.AvailablityArray.insert(SlotRec, at: index)
        dump(self.AvailablityArray)
        if status == "SAVE"{
            let SlotSelectedArray = AvailablityArray[index].SlotArray.filter{($0.selected == true)}
            if AvailablityArray[index].wholeday == true || SlotSelectedArray.count > 0 {
                if !selectedDaysArr.contains(index){
                    selectedDaysArr.append(index)
                }
            }else{
                if selectedDaysArr.contains(index){
                    if let ObjectIndex =  selectedDaysArr.firstIndex(of: index){
                        selectedDaysArr.remove(at: ObjectIndex)
                    }
                }
            }
        }else if status == "BACK"{
            
        }
        self.editAvailabilitytableview.reloadData()
    }

    
    @objc private func TextfieldDidChange(_ textField:UITextField)
    {
        if(textField == addressTxtField)
        {
            if(addressTxtField.text != "")
            {
                if(places.count == 0)
                {
                    self.Placesearch_tableview.isHidden=true
                }
                    
                else
                {
                    self.Placesearch_tableview.isHidden=false
                }
                getTextfieldtag = "1"
                getPlaces(addressTxtField.text!)
            }
            else
            {
                places.removeAll()
                self.Placesearch_tableview.isHidden=true
            }
        }
            
        else if (textField == working_loca)
        {
            if(working_loca.text != "")
            {
                if(places.count == 0)
                {
                    self.Location_tableview.isHidden=true
                    
                }
                else
                {
                    self.Location_tableview.isHidden=false
                    self.location_leading.constant = self.working_loca.frame.maxY
                }
                getTextfieldtag = "2"
                getPlaces(working_loca.text!)
            }
            else
            {
                places.removeAll()
                self.Location_tableview.isHidden=true
            }
            
        }
    }
    
    func getPlaces(_ searchString: String) {
        
        let request = requestForSearch(searchString)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: { data, response, error in
            
            self.handleResponse(data, response: response as? HTTPURLResponse, error: error)
        })
        task.resume()
    }
    
    func handleResponse(_ data: Data!, response: HTTPURLResponse!, error: Error!) {
        if let error = error {
            print("GooglePlacesAutocomplete Error: \(error.localizedDescription)")
            return
        }
        if response == nil {
            print("GooglePlacesAutocomplete Error: No response from API")
            return
        }
        if response.statusCode != 200 {
            print("GooglePlacesAutocomplete Error: Invalid status code \(response.statusCode) from API")
            return
        }
        do {
            let json: NSDictionary = try JSONSerialization.jsonObject(
                with: data,
                options: JSONSerialization.ReadingOptions.mutableContainers
                ) as! NSDictionary
            DispatchQueue.main.async(execute: {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                if let predictions = json["predictions"] as? Array<AnyObject> {
                    print(predictions)
                    self.places = predictions.map { (prediction: AnyObject) -> Place in
                        return Place(
                            id: prediction["place_id"] as! String,
                            description: prediction["description"] as! String
                        )
                    }
                    self.Placesearch_tableview.reloadData()
                     self.Location_tableview.reloadData()
                }
            })
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
    }
    
    func requestForSearch(_ searchString: String) -> URLRequest {
        let params = [
            "input": searchString,
            "key": "\(GoogleApiURLKey)"
        ]
        
        return NSMutableURLRequest(
            url: URL(string: "https://maps.googleapis.com/maps/api/place/autocomplete/json?\(query(params as [String : AnyObject]))")!
            ) as URLRequest
    }
    
    func query(_ parameters: [String: AnyObject]) -> String {
        var components: [(String, String)] = []
        for key in  (Array(parameters.keys).sorted(by: <)) {
            let value: AnyObject! = parameters[key]
            
            components += [(escape(key), escape("\(value!)"))]
        }
        
        return components.map{"\($0)=\($1)"}.joined(separator: "&")
    }
    
    
    
    func escape(_ string: String) -> String {
        
        let legalURLCharactersToBeEscaped: CFString = ":/?&=;+!@#$()',*" as CFString
        
        return CFURLCreateStringByAddingPercentEscapes(nil, string as CFString, nil, legalURLCharactersToBeEscaped, CFStringBuiltInEncodings.UTF8.rawValue) as String
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        var coun = Int()
        if tableView == Placesearch_tableview{
            coun = places.count
        }else if tableView == Location_tableview
        {
            coun = places.count
            
        }
        else if tableView == editAvailabilitytableview{
            coun = AvailablityArray.count
            //            coun = 0
        }
        else if tableView == category_TblView{
            coun = categoryArray.count
        }
        
        return coun
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if tableView == Placesearch_tableview || tableView == Location_tableview{
            
            return 40.0
            
        }else if tableView == editAvailabilitytableview{
             return 70
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell()
        if tableView == Placesearch_tableview{
            
            let Placecell = (tableView.dequeueReusableCell(withIdentifier: "cell") )!
            let place = self.places[indexPath.row]
            Placecell.textLabel?.textColor = UIColor.black
            Placecell.textLabel?.text=place.description
            return Placecell
            
        }else if tableView == Location_tableview
        {
            let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "cell") )!
            
            let place = self.places[indexPath.row]
            
            cell.textLabel?.text=place.description
            
            return cell
        }
        else if tableView == editAvailabilitytableview{
        
            let availcell = tableView.dequeueReusableCell(withIdentifier: "availabledayscell", for: indexPath) as! EditAvailabilityTableViewCell
            availcell.DaysLbl?.text = AvailablityArray[indexPath.row].day
            availcell.AddorEditBtn.tag = indexPath.row
            availcell.AddorEditBtn.setTitleColor(PlumberThemeColor, for: .normal)
            availcell.DaysLbl?.textColor = PlumberThemeColor
            availcell.AddorEditBtn.addTarget(self, action: #selector(OpenUpCollectionViewController(sender :)), for: .touchUpInside)
//            availcell.AddorEditBtn.addTarget(self, action: #selector(OpenUpCollectionView(sender :)), for: .touchUpInside)
            availcell.TimeLbl.text = self.theme.setLang("Not_Selected")
            availcell.AddorEditBtn.setTitle(self.theme.setLang("Add"), for: .normal)
            //        guard SlotArray.count > indexPath.row else{return cell}
            if AvailablityArray[indexPath.row].wholeday == true{
                availcell.TimeLbl.text = self.theme.setLang("Wholeday")
                availcell.AddorEditBtn.setTitle("Edit", for: .normal)
            }
            else {
                ShowArray = AvailablityArray[indexPath.row].SlotArray.filter {($0.selected == true)}
                let titleArray = ShowArray.map{(self.theme.CheckNullValue($0.TimeInterval))}
                if titleArray.count > 0{
                    availcell.AddorEditBtn.setTitle(self.theme.setLang("Edit"), for: .normal)
                    let combainedString = titleArray.joined(separator: ",")
                    availcell.TimeLbl.text = combainedString
                }else{
                    availcell.AddorEditBtn.setTitle(self.theme.setLang("Add"), for: .normal)
                    availcell.TimeLbl.text = self.theme.setLang("Not_Selected")
                }
            }
            return availcell
        }
        else if tableView == category_TblView{
            let cat_Cell = (tableView.dequeueReusableCell(withIdentifier: "CategoryListTableViewCell")) as! CategoryListTableViewCell
            cat_Cell.selectionStyle = .none
            let currentCat_Dtl = categoryArray[indexPath.row] as! CategoryList
            cat_Cell.categotyName_Lbl.text = currentCat_Dtl.categoryName
            cat_Cell.edit_Btn.tag = indexPath.row
            cat_Cell.delete_Btn.tag = indexPath.row
            cat_Cell.delete_Btn.addTarget(self, action: #selector(EditProfileViewController.category_DltAction), for: .touchUpInside)
            cat_Cell.edit_Btn.addTarget(self, action: #selector(EditProfileViewController.category_EditAction), for: .touchUpInside)
            
            return cat_Cell
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        EditTableViewHeight.constant = editAvailabilitytableview.contentSize.height + self.avail.frame.height + self.btnUpdate4.frame.height + 35
        editAvailabilitytableview.layoutIfNeeded()
        self.view.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if tableView .isEqual(Placesearch_tableview)
        {
            if  getTextfieldtag == "1"
            {
                let place = self.places[indexPath.row]
                self.showProgress()
                Addaddress_Data.YourLocality = "\(place.description)" as NSString
                
                let geocoder: CLGeocoder = CLGeocoder()
                
                geocoder.geocodeAddressString(place.description, completionHandler: {(placemarks: [CLPlacemark]?, error: Error?) in
                    self.DismissProgress()
                    if (error != nil) {
                        print("Error \(error!)")
                    } else if let placemark = placemarks?[0] {
                        
                        print("the responsadsase is .......\(placemark)")
                        
                        //                let CityName:String?=placemark.subAdministrativeArea
                        let _:String?=placemark.subLocality
                        
                        let ZipCode:String?=placemark.postalCode
                        
                        if (placemark.administrativeArea != nil)
                        {
                            self.stateTxtField.text = placemark.administrativeArea!
                        }
                        
                        if(placemark.country != nil){
                            self.countryTxtField.text = placemark.country!
                        }
                        
                        if (placemark.subAdministrativeArea != nil)
                        {
                            self.cityTxtField.text = self.theme.CheckNullValue(placemark.subAdministrativeArea! as AnyObject)
                        }
                        
                        if(ZipCode != nil)
                        {
                            self.postalCodeTxtField.text=""
                            
                            self.postalCodeTxtField.text=ZipCode!
                            
                        }
                        else
                        {
                            self.postalCodeTxtField.text=""
                            
                        }
                    }
                })
                
                
                
                url_handler.makeGetCall("https://maps.google.com/maps/api/geocode/json?sensor=false&key=\(GoogleApiURLKey)&address=\(place.description.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))" as NSString) { (responseObject) -> () in
                    
                    
                    if(responseObject != nil)
                    {
                        let responseObject = responseObject!
                        
                        let results:NSArray=(responseObject.object(forKey: "results"))! as! NSArray
                        if results.count > 0
                        {
                            let firstItem: NSDictionary = results.object(at: 0) as! NSDictionary
                            let geometry: NSDictionary = firstItem.object(forKey: "geometry") as! NSDictionary
                            let locationDict:NSDictionary = geometry.object(forKey: "location") as! NSDictionary
                            let lat:NSNumber = locationDict.object(forKey: "lat") as! NSNumber
                            let lng:NSNumber = locationDict.object(forKey: "lng") as! NSNumber
                            self.Addaddress_Data.Latitude="\(lat)" as NSString
                            self.Addaddress_Data.Longitude="\(lng)" as NSString
                        }
                    }
                    else
                    {
                        self.Addaddress_Data.Latitude="0"
                        self.Addaddress_Data.Longitude="0"
                    }
                }
                addressTxtField.text=Addaddress_Data.YourLocality as String
                Placesearch_tableview.isHidden=true
            }
        }
        else if tableView == Location_tableview{
            
            let place = self.places[indexPath.row]
            working_loca.text="\(place.description)"
            Addaddress_Data.YourLocality = "\(place.description)" as NSString
           getLocation(place.id)
                  Location_tableview.isHidden=true
            }
    }

    func getLocation(_ placeId:String){
        let params = [
            "placeid":"\(placeId)",
            "key": "\(GoogleApiURLKey)"
        ]
        let request:URL = URL(string: "https://maps.googleapis.com/maps/api/place/details/json?\(query(params as [String : AnyObject]))")!
        print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: NSMutableURLRequest(
            url: URL(string: "https://maps.googleapis.com/maps/api/place/details/json?\(query(params as [String : AnyObject]))")!
            ) as URLRequest, completionHandler: { data, response, error in
                self.handleLocationResponse(data, response: response as? HTTPURLResponse, error: error)
        })
        
        task.resume()
    }
    
    func handleLocationResponse(_ data: Data!, response: HTTPURLResponse!, error: Error!) {
        if let error = error {
            print("GooglePlacesAutocomplete Error: \(error.localizedDescription)")
            return
        }
        if response == nil {
            print("GooglePlacesAutocomplete Error: No response from API")
            return
        }
        if response.statusCode != 200 {
            print("GooglePlacesAutocomplete Error: Invalid status code \(response.statusCode) from API")
            return
        }
        do {
            let json: NSDictionary = try JSONSerialization.jsonObject(
                with: data,
                options: JSONSerialization.ReadingOptions.mutableContainers
                ) as! NSDictionary
            DispatchQueue.main.async(execute: {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                
//                print(json)
                if let predictions = json["result"] as? NSDictionary {
                    
//                    print(predictions)
                    let lat = self.theme.CheckNullValue( predictions.value(forKeyPath: "geometry.location.lat"))
                    let lng = self.theme.CheckNullValue( predictions.value(forKeyPath: "geometry.location.lng"))
                    self.Addaddress_Data.working_Latitude = lat as NSString
                    self.Addaddress_Data.working_Longitude = lng as NSString
                    self.Addaddress_Data.Latitude = lat as NSString
                    self.Addaddress_Data.Longitude = lng as NSString
                }
            })
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        if (NSStringFromClass((touch.view?.classForCoder)!)=="UITableViewCellContentView")
        {
            return false
        }
            
        else{
            return true
        }
    }
    
    @objc func category_DltAction(_ sender:UIButton)
    {
        self.showProgress()
        print(sender.tag)
        let getCurrent_Val = categoryArray[sender.tag] as! CategoryList
        let getCat_ID =  getCurrent_Val.category_ID
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["tasker":"\(objUserRecs.providerId)","category":"\(String(describing: getCat_ID))"]
        url_handler.makeCall(deleteCategory, param: Param as NSDictionary) {
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
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    
                    if(status == "1") {
                        self.view.makeToast(message:self.theme.CheckNullValue(responseObject.object(forKey: "response")), duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                        self.categoryArray.removeObject(at: sender.tag)
                        self.category_TblView.reloadData()
                        self.updateViewConstraints()
                        
                    }else{//alertImg
                        self.view.makeToast(message:self.theme.CheckNullValue(responseObject.object(forKey: "message")), duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                    }
                    
                }
            }
        }
    }
    override func updateViewConstraints() {
        super.updateViewConstraints()
        self.category_height.constant = self.category_TblView.contentSize.height
        self.category_View.layoutIfNeeded()
         self.view.layoutIfNeeded()
     
    }
    
    @objc func category_EditAction(_ sender:UIButton){
        print(sender.tag)
        // getSubCategory_Dtl
        let getSelectCat_Dtl = categoryArray[sender.tag] as! CategoryList
        let subCat_ID = getSelectCat_Dtl.category_ID
        getSubcategory_Dtls(subCat_ID)
        //let categoryVC = storyboard?.instantiateViewControllerWithIdentifier("CategoryEditVC") as! CategoryEditVC
        //categoryVC.checkCategory = "Edit Category"
        // self.navigationController?.pushViewController(withFade: categoryVC, animated: false)
        
        
    }
    
    func getSubcategory_Dtls(_ subCat_ID:String){
        self.showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["tasker":"\(objUserRecs.providerId)","category":"\(subCat_ID)"]
        url_handler.makeCall(getEditCategory_Detail, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    
                    if(status == "1")
                    {
                        self.editCatDtls_Array.removeAllObjects()
                        let getReponse = responseObject.object(forKey: "response") as! NSDictionary
                        let subCat_ID = self.theme.CheckNullValue(getReponse.object(forKey: "child_id"))
                        let subCateg_Name = self.theme.CheckNullValue(getReponse.object(forKey: "child_name"))
                        let experience_ID = self.theme.CheckNullValue(getReponse.object(forKey: "experience_id"))
                        let experience_Name = self.theme.CheckNullValue(getReponse.object(forKey: "experience_name"))
                        let hour_Rate = self.theme.CheckNullValue(getReponse.object(forKey: "hour_rate"))
                        let minHour_Rate = self.theme.CheckNullValue(getReponse.object(forKey: "min_hourly_rate"))
                        let mainCat_ID = self.theme.CheckNullValue(getReponse.object(forKey: "parent_id"))
                        let mainCate_Name = self.theme.CheckNullValue(getReponse.object(forKey: "parent_name"))
                        let quick_Pitch = self.theme.CheckNullValue(getReponse.object(forKey: "quick_pitch"))
                        let category_type = self.theme.CheckNullValue(getReponse.object(forKey: "ratetype"))
                        self.editCatDtls_Array.add(EditCategoryDetails.init(experience_Lvl:experience_Name , subCat_ID: subCat_ID, subCat_Name: subCateg_Name, experience_ID: experience_ID, expereince_Name: experience_Name, hour_Rate: hour_Rate, min_Rate: minHour_Rate, mainCat_ID: mainCat_ID, mainCat_Name: mainCate_Name, quickPinch: quick_Pitch, ratetype:category_type))
                        
                        let categoryVC = self.storyboard?.instantiateViewController(withIdentifier: "CategoryEditVC") as! CategoryEditVC
                        categoryVC.checkCategory = "Edit Category"
                        categoryVC.editCatDtl_Array = self.editCatDtls_Array
                        self.navigationController?.pushViewController(withFade: categoryVC, animated: false)
                        
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
                    }
                }
                
            }
            
        }
        
    }
    func GetDatasForBanking(){
        self.showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)"]
        
        url_handler.makeCall(GetEditInfoUrl , param: Param as NSDictionary) {
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
                    
                    self.setDatasToEditView(responseObject)
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
        }
    }
    func setDatasToEditView(_ Dict:NSDictionary){
        let status:NSString=Dict["status"] as! NSString
        
        if(status == "1")
        {
            let resDict: NSDictionary = Dict.object(forKey: "response") as! NSDictionary
            
            self.userImg.sd_setImage(with: URL(string:(resDict.object(forKey: "image")as! NSString as String)), placeholderImage: UIImage(named: "PlaceHolderSmall"))
            
            UserDefaults.standard.set((resDict.object(forKey: "image")as! NSString as String), forKey: "userDP")
            UserDefaults.standard.synchronize()
            self.bannerImg.sd_setImage(with: URL(string:(resDict.object(forKey: "image")as! NSString as String)), placeholderImage: UIImage(named: "PlaceHolderBig"))
            
            //uncomment these below lines
            let phoneNum = theme.CheckNullValue(resDict.object( forKey: "mobile_number" ))
            let code = theme.CheckNullValue(resDict.object( forKey: "dial_code" ))
            if phoneNum.isEmpty && code.isEmpty{
                let userPhoneNum = UserDefaults.standard.string(forKey: "userPhoneNum")
                let countryCode = UserDefaults.standard.string(forKey: "countryCode")
                phoneTxtField.text=userPhoneNum
                phoneTxtField.placeholder = Language_handler.VJLocalizedString("mobile", comment: nil)
                cCodeTxtField.text=countryCode
            }
            
            
//            phoneTxtField.text=theme.CheckNullValue(resDict.object( forKey: "mobile_number" ))
//            phoneTxtField.placeholder = Language_handler.VJLocalizedString("mobile", comment: nil)
//            cCodeTxtField.text=theme.CheckNullValue(resDict.object( forKey: "dial_code" ))
            //comment these three lines below
//            phoneTxtField.text=theme.CheckNullValue(resDict.object( forKey: "mobile_number" ))
//            phoneTxtField.placeholder = Language_handler.VJLocalizedString("mobile", comment: nil)
//            cCodeTxtField.text=theme.CheckNullValue(resDict.object( forKey: "dial_code" ))
            
            emailTxtField.text=theme.CheckNullValue(resDict.object( forKey: "email" ) )
            emailTxtField.placeholder = Language_handler.VJLocalizedString("email", comment: nil)
            
            addressTxtField.text=theme.CheckNullValue(resDict.object( forKey: "address" ))
            addressTxtField.placeholder =  Language_handler.VJLocalizedString("address", comment: nil)
            working_loca.text=theme.CheckNullValue(resDict.object( forKey: "working_location"))
            self.theme.saveworkLocation(working_loca.text!)
            working_loca.placeholder =  Language_handler.VJLocalizedString("working_loc", comment: nil)
            
            stateTxtField.text=theme.CheckNullValue(resDict.object( forKey: "state" ))
            stateTxtField.placeholder = Language_handler.VJLocalizedString("state", comment: nil)
            cityTxtField.text=theme.CheckNullValue(resDict.object( forKey: "city" ))
            cityTxtField.placeholder = Language_handler.VJLocalizedString("city", comment: nil)
            
            countryTxtField.text=theme.CheckNullValue(resDict.object( forKey: "country" ))
            countryTxtField.placeholder = Language_handler.VJLocalizedString("country", comment: nil)
            postalCodeTxtField.text=theme.CheckNullValue(resDict.object( forKey: "postal_code" ))
            postalCodeTxtField.placeholder = Language_handler.VJLocalizedString("pincode", comment: nil)
            usernameTxtfield.text = theme.CheckNullValue(resDict.object( forKey: "firstname" ))
            lastname_txt.text = theme.CheckNullValue(resDict.object( forKey: "lastname" ))
            usernameTxtfield.placeholder =
                Language_handler.VJLocalizedString("firstNAme", comment: nil)
            lastname_txt.placeholder =
                Language_handler.VJLocalizedString("lastName", comment: nil)
            radiusTxtfield.text = theme.CheckNullValue(resDict.object( forKey: "radius" ))
            
            lblRadius.text = "\(Language_handler.VJLocalizedString("radius", comment: nil)) (\(theme.CheckNullValue(resDict.object( forKey: "distane_by" ))))"
            radiusTxtfield.placeholder = Language_handler.VJLocalizedString("radius", comment: nil)
         
           
            let radius = Int(theme.CheckNullValue(resDict.object( forKey: "radius") as? Int ?? 10)) ?? 10
            
            self.sliderradius.value = Float(radius)
            
            lblradius.text = "\(radius)"//"\(radius) (\(theme.CheckNullValue(resDict.object( forKey: "distane_by" ))))"
            
            
        }
        else
        {
            self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: kNetworkFail)
        }
    }
    
     @IBAction func backOption(_ sender: AnyObject) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
    @IBAction func EditProfileClickOption(_ sender: AnyObject) {
        
        let ImagePicker_Sheet = UIAlertController(title: nil, message: theme.setLang("select_image"), preferredStyle: .actionSheet)
        
        let Camera_Picker = UIAlertAction(title: theme.setLang("camera") , style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
           self.checkCamera()
        })
        let Gallery_Picker = UIAlertAction(title:theme.setLang("gallery") , style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.checkGallery()
            //self.Gallery_Pick()
            
        })
        
        let cancelAction = UIAlertAction(title: theme.setLang("cancel_small"), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
        })
        
        
        ImagePicker_Sheet.addAction(Camera_Picker)
        ImagePicker_Sheet.addAction(Gallery_Picker)
        ImagePicker_Sheet.addAction(cancelAction)
        
        self.present(ImagePicker_Sheet, animated: true, completion: nil)
    }
    
    func checkGallery(){
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
            self.Gallery_Pick()
        }
            
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            self.alertToEncourageGalleryAccessInitially()
        }
        else if (status == PHAuthorizationStatus.notDetermined) {
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.Gallery_Pick()
                }
                else {
                    
                }
            })
        }
            
        else if (status == PHAuthorizationStatus.restricted) {
            // Restricted access - normally won't happen.
        }
    }
    
    func alertToEncourageGalleryAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Gallery access required for Uploading photos!",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow", style: .default, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }

    
    func checkCamera() {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .authorized: Camera_Pick()
        case .denied: alertPromptToAllowCameraAccessViaSetting()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
                if response {
                    self.Camera_Pick()
                }
            }
        //alertToEncourageCameraAccessInitially()
        default: alertToEncourageCameraAccessInitially()
        }
    }
    
    func alertToEncourageCameraAccessInitially() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .default, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alertPromptToAllowCameraAccessViaSetting() {
        let alert = UIAlertController(
            title: "IMPORTANT",
            message: "Camera access required for capturing photos!",
            preferredStyle: UIAlertController.Style.alert
        )
        alert.addAction(UIAlertAction(title: "Allow Camera", style: .default, handler: { (alert) -> Void in
            UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        }))
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel)
        )
        present(alert, animated: true, completion: nil)
    }
    func Camera_Pick()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            DispatchQueue.main.async
            {
                self.picker.sourceType = .camera
                self.picker.allowsEditing = true
                self.picker.videoMaximumDuration = 60.0;
                self.present(self.picker, animated: true, completion: nil)
            }
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "Sorry, this device has no camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func Gallery_Pick()
    {
        DispatchQueue.main.async
        {
            self.picker.allowsEditing = true
            self.picker.sourceType = .photoLibrary
            self.picker.videoMaximumDuration = 60.0;
            self.present(self.picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var pickimage = UIImage()
        
        
        
        if let img = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage
        {
            pickimage = img
            
        }
        else if let img = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        {
            pickimage = img
        }
        userImg.image = pickimage
        let pickedimage = self.theme.rotateImage(pickimage)
        imagedata = pickedimage.jpegData(compressionQuality: 0.1)!;
        self.uploadImageAndData()
        dismiss(animated:true, completion: nil) //5

    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        dismiss(animated: true, completion: nil)
        
    }
    
    
    func imagePickerDidCancel(imagePicker: WDImagePicker) {
        self.imagePicker.imagePickerController.dismiss(animated: true, completion: nil)
        
        
    }
    
    func imagePicker(imagePicker: WDImagePicker, pickedImage: UIImage) {
        let image = UIImage.init(cgImage: pickedImage.cgImage!, scale: 0.25 , orientation:.up)
        imagedata = image.jpegData(compressionQuality: 0.1)!;
        self.userImg.image = image
        self.hideImagePicker()
        self.uploadImageAndData()
    }
    
    func hideImagePicker() {
        self.imagePicker.imagePickerController.dismiss(animated: true, completion: nil)
    }
    
    
    func blurBannerImg(){
        if !UIAccessibility.isReduceTransparencyEnabled {
            bannerImg.backgroundColor = UIColor.clear
            
            let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = bannerImg.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            bannerImg.addSubview(blurEffectView) //if you have more UIViews, use an insertSubview API to place it where needed
        }
        else {
            bannerImg.backgroundColor = UIColor.black
        }
        userImg.layer.cornerRadius=userImg.frame.size.width/2
        //userImg.layer.borderWidth=0.75
        //userImg.layer.borderColor=PlumberThemeColor.cgColor
        userImg.layer.masksToBounds=true
    }
    
    func decorateTxtField(){
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillShow(_:)), name:UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(EditProfileViewController.keyboardWillHide(_:)), name:UIResponder.keyboardWillHideNotification, object: nil)
        phoneTxtField.roundTheViews()
        emailTxtField.roundTheViews()
        phoneTxtField.roundTheViews()
        usernameTxtfield.roundTheViews()
        lastname_txt.roundTheViews()
        working_loca.roundTheViews()
        radiusTxtfield.roundTheViews()
        cCodeTxtField.roundTheViews()
        addressTxtField.roundTheViews()
        countryTxtField.roundTheViews()
        postalCodeTxtField.roundTheViews()
        stateTxtField.roundTheViews()
        cityTxtField.roundTheViews()
        emailTxtField.isUserInteractionEnabled = false
        radiusTxtfield.isUserInteractionEnabled = true
        
        self.usernameTxtfield.addSubview(theme.SetPaddingView(usernameTxtfield))
        self.lastname_txt.addSubview(theme.SetPaddingView(lastname_txt))
        self.radiusTxtfield.addSubview(theme.SetPaddingView(radiusTxtfield))
        self.working_loca.addSubview(theme.SetPaddingView(working_loca))
        self.emailTxtField.addSubview(theme.SetPaddingView(emailTxtField))
        self.phoneTxtField.addSubview(theme.SetPaddingView(phoneTxtField))
        self.cCodeTxtField.addSubview(theme.SetPaddingView(cCodeTxtField))
        self.addressTxtField.addSubview(theme.SetPaddingView(addressTxtField))
        self.countryTxtField.addSubview(theme.SetPaddingView(countryTxtField))
        self.stateTxtField.addSubview(theme.SetPaddingView(stateTxtField))
        self.cityTxtField.addSubview(theme.SetPaddingView(cityTxtField))
        self.postalCodeTxtField.addSubview(theme.SetPaddingView(postalCodeTxtField))
        
        setMandatoryFields()
        
    }
    
    func setMandatoryFields(){
        for subView:UIView in editProfileScrollView.subviews{
            if(subView.isKind(of: SMIconLabel.self)){
                //                let lbl: SMIconLabel = (subView as? SMIconLabel)!
                //               // if !lbl.isEqual(routingLbl) {
                //                    lbl.icon = UIImage(named: "MandatoryImg")
                //                    lbl.iconPadding = 5
                //                    lbl.iconPosition = SMIconLabelPosition.Right
                //              //  }
            }else if(subView.isKind(of: UITextField.self)){
                let txtField: UITextField = (subView as? UITextField)!
                let arrow: UIView = UILabel()
                arrow.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                txtField.leftView = arrow
                txtField.leftViewMode = UITextField.ViewMode.always
            }
        }
    }
    
    
    @IBAction func didClickEditImage(_ sender: AnyObject) {
        //        let actionSheet = UIActionSheet(title: "Select Image from", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Gallery")
        //        actionSheet.showInView(self.view)
    }
    
    //    @IBAction func didClickBioUpdate(sender: AnyObject) {
    //        if(validateTxtFields("1")){
    //            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
    //            let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
    //                "bio":"\(bioTxtView.text!)"]
    //            updateUserProfile(UpdateBioUrl, withDict: Param)
    //        }
    //    }
    
    @IBAction func didClickEmailUpdate(_ sender: AnyObject) {
        if(validateTxtFields("2")){
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                "email":"\(emailTxtField.text!)"]
            updateUserProfile(UpdateEmailUrl as NSString, withDict: Param as NSDictionary)
        }
    }
    
    @IBAction func didClickMobileUpdate(_ sender: AnyObject) {
        Contact=phoneTxtField.text!
        if(validateTxtFields("3")){
            if self.theme.getTaskerMobileNumber() == Contact{
                self.view.endEditing(true)
            }else{
                let objUserRecs:UserInfoRecord=theme.GetUserDetails()
                let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                    "country_code":"\(cCodeTxtField.text!)",
                    "mobile_number":"\(phoneTxtField.text!)"]
                updateUserProfile(UpdateMobileUrl as NSString, withDict: Param as NSDictionary)
            }
        }
    }
        //MARK: - update radius
    
    @IBAction func didClickRadiusUpdate(_ sender: AnyObject) {
//        Contact=phoneTxtField.text!
//        if(validateTxtFields("3")){
//            if self.theme.getTaskerMobileNumber() == Contact{
//                self.view.endEditing(true)
//            }else{
//                let objUserRecs:UserInfoRecord=theme.GetUserDetails()
//                let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
//                                         "radius":"\(self.radius)"]
//                updateUserProfile(UpdateMobileUrl as NSString, withDict: Param as NSDictionary)
//            }
//        }
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                                 "radius":"\(self.radius)"]
        updateUserProfile(UpdateRadiusUrl as NSString, withDict: Param as NSDictionary)
    }
    
    @IBAction func didClickAddressUpdate(_ sender: AnyObject) {
        if(validateTxtFields("4")){
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId )",
                "address":"\(addressTxtField.text!)",
                "city":"\(cityTxtField.text!)",
                "state":"\(stateTxtField.text!)",
                "country":"\(countryTxtField.text!)",
                "postal_code":"\(postalCodeTxtField.text!)"]
            updateUserProfile(UpdateAddressUrl as NSString, withDict: Param as NSDictionary)
        }
    }
    
    @IBAction func didclickWorkingLocUpdate(_ sender: AnyObject){
        if(validateTxtFields("7")){
            if working_loca.text == self.theme.getworkLocation(){
                self.view.endEditing(true)
            }else{
                let objUserRecs:UserInfoRecord=theme.GetUserDetails()
                let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                    "lat":"\(Addaddress_Data.Latitude)",
                    "long":"\(Addaddress_Data.Longitude)",
                    "availability_address" : "\(Addaddress_Data.YourLocality)"]
                updateUserProfile(UpdateWorkingLocation as NSString, withDict: Param as NSDictionary)
                self.view.endEditing(true)
            }
        }
    }
    
    @IBAction func didClickAvailabilityUpdate(_ sender: AnyObject) {
//        var daysCount:Int = 0
        var availabilityDict: NSMutableDictionary = NSMutableDictionary()
//        let availArray = NSMutableArray()
//        for j in 1...7 {
//            let availObj = Availability()
//            availObj.day = "\(weekFullDay[j])"
//            availObj.isAfternoon = false
//            availObj.isMorning = false
//            availObj.isEvening = false
//            availArray.add(availObj)
//        }
//
//        var count : Int = 0
//        for var i in 1...7 {
//            count += 1
//            let first = count
//            let second = count+1
//            let third = count+2
//            count =  third
//            var arr = [Int]()
//            if(selectedBtn.contains(first)){
//                arr.append(first)
//            }
//            if(selectedBtn.contains(second)){
//                arr.append(second)
//            }
//            if(selectedBtn.contains(third)){
//                arr.append(third)
//            }
//            daysCount += 1
//            for (element,item) in arr.enumerated(){
//                switch (item%3){
//                case 0:
//                    let obj = availArray.object(at: daysCount-1) as! Availability
//                    obj.isEvening = true
//                    break;
//                case 1:
//                    let obj = availArray.object(at: daysCount-1) as! Availability
//                    obj.isMorning = true
//                    break;
//
//                case 2:
//                    let obj = availArray.object(at: daysCount-1) as! Availability
//                    obj.isAfternoon = true
//                    break;
//                default:
//                    break;
//                }
//            }
//        }
//
//        //        for item in selectedBtn
//        //        {
//        //            var quo = (item as! Int) / 3
//        //            let reminder = (item as! Int) % 3
//        //            if(reminder > 0)
//        //            {
//        //                quo += 1
//        //            }
//        //
//        //            switch ((item as! Int) % 3){
//        //            case 0:
//        //                let obj = availArray.object(at: quo-1) as! Availability
//        //                obj.isEvening = true
//        //                break;
//        //            case 1:
//        //                let obj = availArray.object(at: quo-1) as! Availability
//        //                obj.isMorning = true
//        //                break;
//        //
//        //            case 2:
//        //                let obj = availArray.object(at: quo-1) as! Availability
//        //                obj.isAfternoon = true
//        //                break;
//        //            default:
//        //                break;
//        //            }
//        //        }
//        var daysDict : NSDictionary = NSDictionary()
//        var workingdaysarray : NSMutableArray = NSMutableArray()
//
//        var increment = 0
//        for (element,item)  in availArray.enumerated(){
//            var TimingDict : Dictionary = [String : String]()
//            let obj1 = availArray.object(at:element) as! Availability
//
//            if obj1.isMorning == true || obj1.isAfternoon == true || obj1.isEvening == true{
//
//                if obj1.isMorning == true{
//                    TimingDict["morning"] = "1"
//
//                }
//                if obj1.isEvening == true{
//                    TimingDict ["evening"] = "1"
//
//                }
//                if obj1.isAfternoon == true{
//                    TimingDict ["afternoon"] = "1"
//
//                }
//
//                daysDict = ["day":obj1.day,"hour":TimingDict]
//
//
//            }else{
//                 TimingDict["morning"] = "0"
//                  TimingDict ["afternoon"] = "0"
//                 TimingDict ["evening"] = "0"
//                daysDict = ["day":obj1.day,"hour":TimingDict]
//            }
//              workingdaysarray.add(daysDict)
//                  increment += 1
//        }
//
//        availabilityDict.setValue(workingdaysarray, forKey:"working_days")
        
//
//
//        print(availabilityDict)
//        updateWorkingDays(availabilityDict as NSDictionary)
//
        
        var FinalWorkingArray = [Any]()
        for index in selectedDaysArr{
            if AvailablityArray[index].wholeday == true {
                AvailablityArray[index].selected = true
                var Object = [String : Any]()
                let SlotfilteredArray = AvailablityArray[index].SlotArray.map{($0.slotIndex)!}
                Object = ["day":AvailablityArray[index].day,"selected":AvailablityArray[index].selected!,"wholeday":AvailablityArray[index].wholeday!,"slots":SlotfilteredArray]
                print("the Object is \(Object)")
                FinalWorkingArray.append(Object)
            }else{
                AvailablityArray[index].selected = true
                AvailablityArray[index].wholeday = false
                var Object = [String : Any]()
                let SlotfilteredArray = AvailablityArray[index].SlotArray.filter{($0.selected == true)}
                let SlotsIndexArray = SlotfilteredArray.map{($0.slotIndex)!}
                if SlotsIndexArray.count == 0 && AvailablityArray[index].wholeday == false{
                    AvailablityArray[index].selected = false
//                    AvailablityArray.remove(at: index)
                } else {
                    Object = ["day":AvailablityArray[index].day,"selected":AvailablityArray[index].selected!,"wholeday":AvailablityArray[index].wholeday!,"slots":SlotsIndexArray/*SlotfilteredArray*/]
                    print("the Object is \(Object)")
                    FinalWorkingArray.append(Object)
                }
                print("AvailablityArray =>\(AvailablityArray)")
                print("AvailablityArray =>\(AvailablityArray.count)")
                //let SlotfilteredArray = AvailablityArray[index].SlotArray.map{(self.convertSlotToDict($0))}
            }
        }
        
        print("The FinalWorkingArray is as Follows\(FinalWorkingArray)")
        let objUserRecs:UserInfoRecord=self.theme.GetUserDetails()
        availabilityDict = ["provider_id" : objUserRecs.providerId,"working_days" : FinalWorkingArray]
        updateWorkingDays(availabilityDict)
    }
    
    //    func showProgressbar()
    //    {
    //        progressbar.show(message: "", style: BlueIndicatorStyle())
    //    }
    
    func updateWorkingDays(_ param:NSDictionary){
        self.showProgress()
        url_handler.makeCall(UpdateWorkingDays  , param: param as NSDictionary) {
            (responseObject, error) -> () in
            self.DismissProgress()
            if(error != nil) {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
            }
            else {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    
                    if(status == "1") {
                        self.view.makeToast(message:self.theme.CheckNullValue(responseObject.object(forKey: "message")), duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                        
                    }else{//alertImg
                        self.view.makeToast(message:self.theme.CheckNullValue(responseObject.object(forKey: "message")), duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                    }
                    
                }else{
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
                }
            }
            
        }
        
    }
    
    //    func DismissProgressbar()
    //    {
    //        progressbar.dismiss()
    //    }
    
    
    
    func uploadImageAndData(){
        let objUserRecs:UserInfoRecord=self.theme.GetUserDetails()
        
        let param : NSDictionary =  ["provider_id"  :objUserRecs.providerId]
        let imageData = imagedata
        self.showProgress()
        
        let URL = try! URLRequest(url: UpdateImageUrlUrl, method: .post, headers: ["devicetype": "ios", "device":"\(theme.GetDeviceToken())", "user":"\(objUserRecs.providerId)" , "type":"tasker"])
    
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(imageData, withName: "file", fileName: "file.png", mimeType: "")
            
            for (key, value) in param {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key as! String)
            }
            
        }, with: URL, encodingCompletion: { encodingResult in
            switch encodingResult {
                
            case .success(let upload, _, _):
                
                
                upload.responseJSON { response in
                    
                    
                    if let js = response.result.value {
                        let JSON = js as! NSDictionary
                        self.DismissProgress()
                        print("JSON: \(JSON)")
                        
                        let Status = self.theme.CheckNullValue(JSON.object(forKey: "status"))
                        let response = JSON.object(forKey: "response") as! NSDictionary
                        if(Status == "1")
                        {
                            
                            self.theme.AlertView("\(appNameJJ)", Message: self.theme.CheckNullValue(response.object(forKey: "msg")), ButtonTitle: kOk)
                            
//                            let URL = try! URLRequest(url: self.theme.CheckNullValue(response.object(forKey: "image"))!, method: .get, headers: nil)
//
                            UserDefaults.standard.set(response.object(forKey: "image"), forKey: "userDP")
                            UserDefaults.standard.synchronize()
                            self.theme.saveUserImage(self.theme.CheckNullValue(response.object(forKey: "image")) as NSString)
                        }
                        else
                        {
                            
                            self.theme.AlertView("\(appNameJJ)", Message: self.theme.CheckNullValue(response.object(forKey: "msg")), ButtonTitle: kOk)
                            
                            
                            
                        }
                        
                    }
                }
                
            case .failure(let encodingError):
                
                //                      self.themes.AlertView("Image Upload Failed", Message: "Please try again", ButtonTitle: "Ok")
                print(" the encodeing error is \(encodingError)")
            }
        })
    }
    
    //MARK: -  update aan
    
    @IBAction func updateSsnEtcBtnPressed(_ sender: Any) {
        /*
        if (ssnTextFiled.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterSSN", comment: nil), ButtonTitle: kOk)
            return
        } else if (aptTextField.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterATP", comment: nil), ButtonTitle: kOk)
            return
        } else if (cityTextField.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterCity", comment: nil), ButtonTitle: kOk)
            return
        } else if (stateTextFiled.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterState", comment: nil), ButtonTitle: kOk)
            return
        } else if (zipCodeTextField.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterZip", comment: nil), ButtonTitle: kOk)
            return
        } else if (addressTextField.text!.isEmpty){
            self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enterAddress", comment: nil), ButtonTitle: kOk)
            return
        }
        else{
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            
            
           
            self.showProgress()
            
            
            let address = Address(apt: aptTextField.text!, city: cityTextField.text!, state: stateTextFiled.text!, zipcode: zipCodeTextField.text!, line1: addressTextField.text!)
            
            let obj = UpdateSSN(ssn: ssnTextFiled.text!, address: address, providerID: objUserRecs.providerId)
            
            let jsonEncoder = JSONEncoder()
            var jsonData = try! jsonEncoder.encode(obj)
            
//            let params = ["ssn":"\(ssnTextFiled.text!)",
//                         "address[apt]":"\(aptTextField.text!)",
//                         "address[city]":cityTextField.text!,
//                         "address[state]":stateTextFiled.text!,
//                         "address[zipcode]":zipCodeTextField.text!,
//                         "address[line1]":addressTextField.text!,
//                        "provider_id"  :objUserRecs.providerId
//            ]
//
//            let params = ["ssn":"\(ssnTextFiled.text!)",
//                         "apt":"\(aptTextField.text!)",
//                         "city":cityTextField.text!,
//                         "state":stateTextFiled.text!,
//                         "zipcode":zipCodeTextField.text!,
//                         "line1":addressTextField.text!,
//                        "provider_id"  :objUserRecs.providerId
//            ]
            
            
            url_handler.makePostCall(updatePersonalInformation , jsonData: jsonData) {
                (responseObject, error) -> ()  in
                self.DismissProgress()
                if(error != nil)
                {
                    print("error responded with: \(String(describing: error))")
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
                else
                {
                    if(responseObject != nil)
                    {
                        let responseObject = responseObject!
                        
                        
                        let a = responseObject["response"]
                        
//                        let resDict: NSDictionary = responseObject.object(forKey: "response") as? String
                        self.view.makeToast(message:self.theme.CheckNullValue(a), duration: 5, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)")
                        
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                    }
                }
            }
            
            
        }
        
        */
    }
    
    
    
    
    
    
    
    func uploadImg(_ dict: NSDictionary){
        updateUserProfile(UpdateImageUrlUrl as NSString, withDict: dict)
    }
    
    
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewControllerwithFade(animated: false)
        self.delegate?.Refresh()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func validateTxtFields (_ condition:NSString ) -> Bool{
        self.view.endEditing(true)
        var isOK:Bool=true
        if(condition=="1"){
            /*if(bioTxtView.text.count==0){
             ValidationAlert(Language_handler.VJLocalizedString("bio_mand", comment: nil))
             isOK=false
             return isOK
             }*/
        }
        if(condition=="2"){
            if(emailTxtField.text!.count==0){
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("email_mand", comment: nil), ButtonTitle: kOk)
                
                isOK=false
                return isOK
            }else if(theme.isValidEmail(testStr: emailTxtField.text!)){
                
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("valid_email_alert", comment: nil), ButtonTitle: kOk)
                
                isOK=false
                return isOK
            }
        }
        if(condition=="3"){
            if(cCodeTxtField.text!.count==0){
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("country_code_mand", comment: nil), ButtonTitle: kOk)
                
                isOK=false
                return isOK
            }
            else if(phoneTxtField.text!.count==0){
                
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("mobile_number_mand", comment: nil), ButtonTitle: kOk)
                
                
                isOK=false
                return isOK
            }
            
        }
        if(condition=="4"){
            if(addressTxtField.text!.count==0){
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("address_mand", comment: nil), ButtonTitle: kOk)
                isOK=false
                return isOK
            }
            if(cityTxtField.text!.count==0){
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("city_mand", comment: nil), ButtonTitle: kOk)
                
                
                
                isOK=false
                return isOK
            }
            if(stateTxtField.text!.count==0){
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("state_mand", comment: nil), ButtonTitle: kOk)
                
                
                isOK=false
                return isOK
            }
            if(countryTxtField.text!.count==0){
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("country_mand", comment: nil), ButtonTitle: kOk)
                
                isOK=false
                return isOK
            }
            if(postalCodeTxtField.text!.count==0){
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("postal_code_mand", comment: nil), ButtonTitle: kOk)
                isOK=false
                return isOK
            }
        }
        
        if (condition == "5"){
            
            if usernameTxtfield.text == ""{
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enter_first_name", comment: nil), ButtonTitle: kOk)
                isOK=false
                return isOK
            }else if (usernameTxtfield.text!.count <= 4){
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("first_name_above_4", comment: nil), ButtonTitle: kOk)
                isOK=false
                return isOK
            }
            else if lastname_txt.text == ""{
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("enter_lastname", comment: nil), ButtonTitle: kOk)
                isOK=false
                return isOK
            }
            //
//            if(usernameTxtfield.text!.count==0){
//                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("username_mand", comment: nil), ButtonTitle: kOk)
//                isOK=false
//                return isOK
//            }
        }
        if (condition == "6")
        {
            if radiusTxtfield.text == ""
            {
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("radius_mand", comment: nil), ButtonTitle: kOk)
                isOK=false
                return isOK
                
            }else
            {
                guard let doubleval = Double(radiusTxtfield.text!) else {
                     self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("radius_mand", comment: nil), ButtonTitle: kOk)
                    isOK=false
                    return isOK
                    
                }
            
            if(doubleval <= 0)  {
                self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("radius_mand", comment: nil), ButtonTitle: kOk)
                isOK=false
                return isOK
            }
            }
        }
            if(condition=="7"){
                
                if(working_loca.text!.count==0){
                    self.theme.AlertView("\(appNameJJ)", Message:Language_handler.VJLocalizedString("working_mand", comment: nil), ButtonTitle: kOk)
                    isOK=false
                    return isOK
                }
                
                
            }
            
            
            return isOK
            
        }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyboardWillShow(_ notification:Notification){
        
        let userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = editProfileScrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height+150
        editProfileScrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(_ notification:Notification){
        
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        editProfileScrollView.contentInset = contentInset
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if(range.location==0 && string==" "){
            return false
        }
        return true
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(range.location==0 && text==" "){
            return false
        }
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    
    @objc func didClickenable(_ sender: UIButton) {
        
        if (selectedBtn.contains(sender.tag) ){
            selectedBtn.remove(sender.tag)
            sender.setBackgroundImage(UIImage.init(named: "tick_gray"), for: UIControl.State())
        }else{
            selectedBtn.add(sender.tag)
            sender.setBackgroundImage(UIImage.init(named: "tick"), for: UIControl.State())
        }
        print(selectedBtn)
        
    }
    @IBAction func didclickusername(_ sender: AnyObject)
    {
        if(validateTxtFields("5")){
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                "firstname":"\(usernameTxtfield.text!)","lastname":"\(lastname_txt.text!)"]
            updateUserProfile(UpdateUsernameUrl as NSString, withDict: Param as NSDictionary)
        }
    }
    
    @IBAction func didupdateradius(_ sender: AnyObject) {
        if(validateTxtFields("6")){
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
                "radius":"\(radiusTxtfield.text!)"]
            updateUserProfile(UpdateRadiusUrl as NSString, withDict: Param as NSDictionary)
        }
        
    }
    @IBAction func didclickCategoryview(_ sender: AnyObject) {
        
        let categoryVC = storyboard?.instantiateViewController(withIdentifier: "CategoryEditVC") as! CategoryEditVC
        categoryVC.checkCategory = "Add Category"
        self.navigationController?.pushViewController(withFade: categoryVC, animated: false)
        
        
    }
    
    func updateUserProfile(_ statusType:NSString, withDict:NSDictionary){
        
        NSLog("Getsataus type=%@", withDict)
        self.showProgress()
        
        // print(Param)
        
        url_handler.makeCall(statusType as String, param: withDict) {
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
                        if(statusType as String == UpdateImageUrlUrl){
                            
                            let URL = try! URLRequest(url: self.theme.CheckNullValue(responseObject.object(forKey: "response")), method: .get, headers: nil)
                            
                            self.userImg.sd_setImage(with: URL.url , placeholderImage: #imageLiteral(resourceName: "PlaceHolderSmall"))
                            
                            UserDefaults.standard.set(URL.url, forKey: "userDP")
                            UserDefaults.standard.synchronize()
                            let URL1 = try! URLRequest(url: self.theme.CheckNullValue(responseObject.object(forKey: "response")), method: .get, headers: nil)
                            
                            self.bannerImg.sd_setImage(with: URL1.url , placeholderImage: #imageLiteral(resourceName: "PlaceHolderBig"))
                            
                            
                            self.theme.AlertView(Language_handler.VJLocalizedString("success", comment: nil), Message: Language_handler.VJLocalizedString("profile_image_update", comment: nil), ButtonTitle: kOk)
                            
                            
                            self.theme.saveUserImage(responseObject.object( forKey: "response" ) as! NSString)
                            
                        }
                        if(statusType as String == UpdateBioUrl){
                            
                            self.theme.AlertView(Language_handler.VJLocalizedString("success", comment: nil), Message: Language_handler.VJLocalizedString("bio_update", comment: nil), ButtonTitle: kOk)
                            
                            
                        }
                        if(statusType as String == UpdateEmailUrl){
                            
                            self.theme.AlertView(Language_handler.VJLocalizedString("success", comment: nil), Message: Language_handler.VJLocalizedString("email_update", comment: nil), ButtonTitle: kOk)
                            
                        }
                        if(statusType as String == UpdateWorkingLocation){
                            
                            self.theme.AlertView(Language_handler.VJLocalizedString("success", comment: nil), Message: Language_handler.VJLocalizedString("location_update", comment: nil), ButtonTitle: kOk)
                            self.theme.saveworkLocation(self.working_loca.text!)
                        }
                        if(statusType as String == UpdateAddressUrl){
                            
                            self.theme.AlertView(Language_handler.VJLocalizedString("success", comment: nil), Message: Language_handler.VJLocalizedString("address_update", comment: nil), ButtonTitle: kOk)
                            
                        }
                        if(statusType as String == UpdateMobileUrl){
                            self.updateMob(responseObject)
                        }
                        
                        if (statusType as String == UpdateUsernameUrl)
                        {
                            self.theme.AlertView(Language_handler.VJLocalizedString("success", comment: nil), Message: Language_handler.VJLocalizedString("username_update", comment: nil), ButtonTitle: kOk)
                            let FullName = "\(self.usernameTxtfield.text ?? " ")\(" ")\(self.lastname_txt.text ?? " ")"
                            self.theme.saveFullName(UserName: FullName)
                        }
                        if (statusType as String == UpdateRadiusUrl)
                        {
                            self.theme.AlertView(Language_handler.VJLocalizedString("success", comment: nil), Message: Language_handler.VJLocalizedString("radius_update", comment: nil), ButtonTitle: kOk)
                        }
                    }
                    else
                    {//alertImg
                        let response = self.theme.CheckNullValue(responseObject.object(forKey: "response"))
                        
                        if response == "Latitude is Required"
                        {
                            self.theme.AlertView("\(appNameJJ)", Message:self.theme.setLang("Select the Address from Suggestion"), ButtonTitle: kOk)
                        }
                            
                        else{
                            self.theme.AlertView("\(appNameJJ)", Message: self.theme.CheckNullValue(responseObject.object(forKey: "response")), ButtonTitle: kOk)
                        }
                    }
                }
                else
                {
                    self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: appNameJJ)
                }
            }
            
        }
    }
    
    
    
    func  ValidateOTP() {
        self.showProgress()
        
        // print(Param)
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)",
            "country_code":"\(cCodeTxtField.text!)",
            "mobile_number":"\(phoneTxtField.text!)",
            "otp":"\(tField.text!)"]
        
        url_handler.makeCall(UpdateMobileUrl, param: Param as NSDictionary) {
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
                        self.theme.AlertView(Language_handler.VJLocalizedString("success", comment: nil), Message: Language_handler.VJLocalizedString("mobile_number_update", comment: nil), ButtonTitle: kOk)
                    }
                    else{
                    }
                }
            }
        }
    }
    
    func updateMob(_ responseObject:NSDictionary){
        
        otpStr = self.theme.CheckNullValue(responseObject.object( forKey: "otp" ))
        otp_status = self.theme.CheckNullValue(responseObject.object( forKey: "otp_status" ))
        
        //        let alertView = SCLAlertView()
        //        let txt = alertView.addTextField(Language_handler.VJLocalizedString("otp_placeholder")!)
        //        alertView.addButton(Language_handler.VJLocalizedString("ok", comment: nil)) {
        //            if txt.text == ""
        //            {
        //                self.view.makeToast(message:Language_handler.VJLocalizedString("OTP is mandatory", comment: nil), duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)");
        //            }
        //
        //            else if txt.text.text == self.otpStr as String
        //            {
        //                self.ValidateOTP()
        //
        //
        //            }
        //            else{
        //
        //                self.theme.AlertView("\(appNameJJ)", Message: Language_handler.VJLocalizedString("otp_alert", comment: nil), ButtonTitle: kOk)
        //            }
        //        }
        //        alertView.addButton(Language_handler.VJLocalizedString("ok", comment: nil)) {
        //            print("Text value: \(txt.text)")
        //        }
        //
        //        alertView.showEdit(Language_handler.VJLocalizedString("otp_placeholder"), subTitle: Language_handler.VJLocalizedString("otp_mobileupdate_desc")
        
        
        let alert = UIAlertController(title:Language_handler.VJLocalizedString("otp_placeholder", comment: nil), message: Language_handler.VJLocalizedString("otp_mobileupdate_desc", comment: nil), preferredStyle: .alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        alert.addAction(UIAlertAction(title:Language_handler.VJLocalizedString("cancel", comment: nil), style: .cancel, handler:handleCancel))
        alert.addAction(UIAlertAction(title:Language_handler.VJLocalizedString("ok", comment: nil), style: .default, handler:{ (UIAlertAction) in
            if self.tField.text == ""
            {
                self.view.makeToast(message:Language_handler.VJLocalizedString("OTP is mandatory", comment: nil), duration: 3, position: HRToastPositionDefault as AnyObject, title: "\(appNameJJ)");
            }
                
            else if self.tField.text == self.otpStr as String
            {
                self.ValidateOTP()
            }
            else{
                self.theme.AlertView("\(appNameJJ)", Message: Language_handler.VJLocalizedString("otp_alert", comment: nil), ButtonTitle: kOk)
            }
        }))
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    
    func getProviderCategory_Dtl(){
        self.showProgress()
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)"]
        url_handler.makeCall(viewProfile, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            self.DismissProgress()
            if(error != nil)
            {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    
                    let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                    
                    if(status == "1") || (status == "3")
                    {
                        
                        self.categoryArray.removeAllObjects()
                        
                        if (((responseObject.object(forKey: "response") as! NSDictionary).object(forKey: "details") as! NSMutableArray).count > 0){
                            
                        

//                        if(((responseObject.object(forKey: "response") as AnyObject).object(forKey: "details") as AnyObject).count>0){
                            let categoryArr = (responseObject.object(forKey: "response") as AnyObject).object(forKey: "category_Details") as! NSArray
                            
                            for category in categoryArr{
                                let category_Arr = category as! NSDictionary
                                let id = self.theme.CheckNullValue(category_Arr["_id"])
                                let name = self.theme.CheckNullValue(category_Arr["categoryname"])
                                self.categoryArray.add(CategoryList.init(categoryName:name,category_ID:id))
                            
                            }
                            self.category_height.constant = 1500
                            self.category_TblView.reloadData()
                            self.category_height.constant = self.category_TblView.contentSize.height
                            self.updateViewConstraints()
                            self.category_View.layoutIfNeeded()
                            self.view.layoutIfNeeded()
                        }
                        else
                        {
                            self.view.makeToast(message:kErrorMsg, duration: 5, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
                        }
                    }
                    else
                    {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
                    }
                }
            }
        }
    }
    
    func configurationTextField(_ textField: UITextField!)
    {
        
        textField.placeholder = Language_handler.VJLocalizedString("otp_placeholder", comment: nil)
        
        tField = textField
        if otp_status == "development"
        {
            tField.text = self.otpStr as String
            tField.isUserInteractionEnabled = false
        }
        else{
            tField.text = ""
            tField.isUserInteractionEnabled = true
        }
    }
    
    func handleCancel(_ alertView: UIAlertAction!)
    {
        print("Cancelled !!")
    }
    
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getProviderCategory_Dtl()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let yPosision: CGFloat = -scrollView.contentOffset.y
        if yPosision > 0 {
            self.bannerImg.center = CGPoint(x: self.bannerImg.center.x, y: self.bannerImg.center.y)
            UIView.animate(withDuration: 0.2, animations: {
                //   self.userImg.isHidden = true
            })
        }
    }
}




//extension EditProfileViewController : UICollectionViewDelegate , UICollectionViewDataSource {
//
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return SlotArray.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailCell", for: indexPath) as! AvailablityCollectionCell
//        guard SlotArray.count > indexPath.row else{return cell}
//        cell.TimeIntervalLabel.text = SlotArray[indexPath.row].TimeInterval
//        cell.cellSlotData = SlotArray[indexPath.row]
//        print("The isWholeSelected in Cellforrow is \(isWholeSelected)")
//        cell.isUserInteractionEnabled = !isWholeSelected
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
////        let padding: CGFloat =  5
////        let collectionViewSize = AvailCollectionView.AvailablityCOllectionView.frame.size.width - padding
//
//        return CGSize(width: collectionViewSize/3, height: collectionViewSize/3)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
////        AvailCollectionView.CollectionViewHeight.constant = AvailCollectionView.AvailablityCOllectionView.contentSize.height
//    }
    
//}


extension EditProfileViewController:GMSMapViewDelegate,CLLocationManagerDelegate
{
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        getAddressForLatLng("\(mapView.camera.target.latitude)", longitude: "\(mapView.camera.target.longitude)")
    }
    //MARK: - LocationManager Delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        _ = CLGeocoder()
        let current = locations[0]
        if current.coordinate.latitude != 0 {
            let currentLatitide = "\(current.coordinate.latitude)"
            let currentLongitude = "\(current.coordinate.longitude)"
            locationManager.stopUpdatingLocation()
            set_mapView(currentLatitide as String, long: currentLongitude as String)
        }
    }
    
    func getAddressForLatLng(_ latitude: String, longitude: String) {
        /*
        if !didselectCalled
        {
            let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(GoogleApiURLKey)&language=\(theme.getAppLanguage())")
            let data = try? Data(contentsOf: url!)
            if data != nil{
                let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
                if let result = json["results"] as? NSArray {
                    print(result)
                    if(result.count != 0){
                        
                        if let address = (result[0] as AnyObject)["formatted_address"] as? String{
                            txtLocation.text = address
                            self.sampleArray = NSMutableArray()
                            self.sampleArray.add(latitude)
                            self.sampleArray.add(longitude)
                            self.sampleArray.add(address)
                            
                        }
                    }
                }
            }
        }
        didselectCalled = false
        */
    }
}
