
//
//  Theme.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/17/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit
import NotificationView
import NVActivityIndicatorView
import PhoneNumberKit
enum GradientDirection {
    case ToptoBottom
    case LefttoRight
    case LefttoRightDiagonal
    case RighttoLeftDiagonal
}

@objcMembers  class Theme: NSObject,NotificationViewDelegate {
 
    var url_handler : URLhandler = URLhandler()
    var isLanguageManagement : Int = 0
    
    let Notificationview = NotificationView.default
    let activityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 75, height: 100),
                                                        type: .ballScaleMultiple)
    let  codename:NSArray=["Afghanistan(+93)", "Albania(+355)","Algeria(+213)","American Samoa(+1684)","Andorra(+376)","Angola(+244)","Anguilla(+1264)","Antarctica(+672)","Antigua and Barbuda(+1268)","Argentina(+54)","Armenia(+374)","Aruba(+297)","Australia(+61)","Austria(+43)","Azerbaijan(+994)","Bahamas(+1242)","Bahrain(+973)","Bangladesh(+880)","Barbados(+1246)","Belarus(+375)","Belgium(+32)","Belize(+501)","Benin(+229)","Bermuda(+1441)","Bhutan(+975)","Bolivia(+591)","Bosnia and Herzegovina(+387)","Botswana(+267)","Brazil(+55)","British Virgin Islands(+1284)","Brunei(+673)","Bulgaria(+359)","Burkina Faso(+226)","Burma (Myanmar)(+95)","Burundi(+257)","Cambodia(+855)","Cameroon(+237)","Canada(+1)","Cape Verde(+238)","Cayman Islands(+1345)","Central African Republic(+236)","Chad(+235)","Chile(+56)","China(+86)","Christmas Island(+61)","Cocos (Keeling) Islands(+61)","Colombia(+57)","Comoros(+269)","Cook Islands(+682)","Costa Rica(+506)","Croatia(+385)","Cuba(+53)","Cyprus(+357)","Czech Republic(+420)","Democratic Republic of the Congo(+243)","Denmark(+45)","Djibouti(+253)","Dominica(+1767)","Dominican Republic(+1809)","Ecuador(+593)","Egypt(+20)","El Salvador(+503)","Equatorial Guinea(+240)","Eritrea(+291)","Estonia(+372)","Ethiopia(+251)","Falkland Islands(+500)","Faroe Islands(+298)","Fiji(+679)","Finland(+358)","France (+33)","French Polynesia(+689)","Gabon(+241)","Gambia(+220)","Gaza Strip(+970)","Georgia(+995)","Germany(+49)","Ghana(+233)","Gibraltar(+350)","Greece(+30)","Greenland(+299)","Grenada(+1473)","Guam(+1671)","Guatemala(+502)","Guinea(+224)","Guinea-Bissau(+245)","Guyana(+592)","Haiti(+509)","Holy See (Vatican City)(+39)","Honduras(+504)","Hong Kong(+852)","Hungary(+36)","Iceland(+354)","India(+91)","Indonesia(+62)","Iran(+98)","Iraq(+964)","Ireland(+353)","Isle of Man(+44)","Israel(+972)","Italy(+39)","Ivory Coast(+225)","Jamaica(+1876)","Japan(+81)","Jordan(+962)","Kazakhstan(+7)","Kenya(+254)","Kiribati(+686)","Kosovo(+381)","Kuwait(+965)","Kyrgyzstan(+996)","Laos(+856)","Latvia(+371)","Lebanon(+961)","Lesotho(+266)","Liberia(+231)","Libya(+218)","Liechtenstein(+423)","Lithuania(+370)","Luxembourg(+352)","Macau(+853)","Macedonia(+389)","Madagascar(+261)","Malawi(+265)","Malaysia(+60)","Maldives(+960)","Mali(+223)","Malta(+356)","MarshallIslands(+692)","Mauritania(+222)","Mauritius(+230)","Mayotte(+262)","Mexico(+52)","Micronesia(+691)","Moldova(+373)","Monaco(+377)","Mongolia(+976)","Montenegro(+382)","Montserrat(+1664)","Morocco(+212)","Mozambique(+258)","Namibia(+264)","Nauru(+674)","Nepal(+977)","Netherlands(+31)","Netherlands Antilles(+599)","New Caledonia(+687)","New Zealand(+64)","Nicaragua(+505)","Niger(+227)","Nigeria(+234)","Niue(+683)","Norfolk Island(+672)","North Korea (+850)","Northern Mariana Islands(+1670)","Norway(+47)","Oman(+968)","Pakistan(+92)","Palau(+680)","Panama(+507)","Papua New Guinea(+675)","Paraguay(+595)","Peru(+51)","Philippines(+63)","Pitcairn Islands(+870)","Poland(+48)","Portugal(+351)","Puerto Rico(+1)","Qatar(+974)","Republic of the Congo(+242)","Romania(+40)","Russia(+7)","Rwanda(+250)","Saint Barthelemy(+590)","Saint Helena(+290)","Saint Kitts and Nevis(+1869)","Saint Lucia(+1758)","Saint Martin(+1599)","Saint Pierre and Miquelon(+508)","Saint Vincent and the Grenadines(+1784)","Samoa(+685)","San Marino(+378)","Sao Tome and Principe(+239)","Saudi Arabia(+966)","Senegal(+221)","Serbia(+381)","Seychelles(+248)","Sierra Leone(+232)","Singapore(+65)","Slovakia(+421)","Slovenia(+386)","Solomon Islands(+677)","Somalia(+252)","South Africa(+27)","South Korea(+82)","Spain(+34)","Sri Lanka(+94)","Sudan(+249)","Suriname(+597)","Swaziland(+268)","Sweden(+46)","Switzerland(+41)","Syria(+963)","Taiwan(+886)","Tajikistan(+992)","Tanzania(+255)","Thailand(+66)","Timor-Leste(+670)","Togo(+228)","Tokelau(+690)","Tonga(+676)","Trinidad and Tobago(+1868)","Tunisia(+216)","Turkey(+90)","Turkmenistan(+993)","Turks and Caicos Islands(+1649)","Tuvalu(+688)","Uganda(+256)","Ukraine(+380)","United Arab Emirates(+971)","United Kingdom(+44)","United States(+1)","Uruguay(+598)","US Virgin Islands(+1340)","Uzbekistan(+998)","Vanuatu(+678)","Venezuela(+58)","Vietnam(+84)","Wallis and Futuna(+681)","West Bank(970)","Yemen(+967)","Zambia(+260)","Zimbabwe(+263)"];
    let code:NSArray=["+93", "+355","+213","+1684","+376","+244","+1264","+672","+1268","+54","+374","+297","+61","+43","+994","+1242","+973","+880","+1246","+375","+32","+501","+229","+1441","+975","+591"," +387","+267","+55","+1284","+673","+359","+226","+95","+257","+855","+237","+1","+238","+1345","+236","+235","+56","+86","+61","+61","+57","+269","+682","+506","+385","+53","+357","+420","+243","+45","+253","+1767","+1809","+593","+20","+503","+240","+291","+372","+251"," +500","+298","+679","+358","+33","+689","+241","+220"," +970","+995","+49","+233","+350","+30","+299","+1473","+1671","+502","+224","+245","+592","+509","+39","+504","+852","+36","+354","+91","+62","+98","+964","+353","+44","+972","+39","+225","+1876","+81","+962","+7","+254","+686","+381","+965","+996","+856","+371","+961","+266","+231","+218","+423","+370","+352","+853","+389","+261","+265","+60","+960","+223","+356","+692","+222","+230","+262","+52","+691","+373","+377","+976","+382","+1664","+212","+258","+264","+674","+977","+31","+599","+687","+64","+505","+227","+234","+683","+672","+850","+1670","+47","+968","+92","+680","+507","+675","+595","+51","+63","+870","+48","+351","+1","+974","+242","+40","+7","+250","+590","+290","+1869","+1758","+1599","+508","+1784","+685","+378","+239","+966","+221","+381","+248","+232","+65","+421","+386","+677","+252","+27","+82","+34","+94","+249","+597","+268","+46","+41","+963","+886","+992","+255","+66","+670","+228","+690","+676","+1868","+216","+90","+993","+1649","+688","+256","+380","+971","+44","+1","+598","+1340","+998","+678","+58","+84","+681","+970","+967","+260","+263"];
    
    func Check_userID() -> String {
        if UserDefaults.standard.object(forKey: "userID") != nil{
            return UserDefaults.standard.object(forKey: "userID") as! String
        } else{
            return ""
        }
    }
    func isValidEmailAddressNew(emailAddressString: String) -> Bool {
      
      var returnValue = true
      let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
      
      do {
          let regex = try NSRegularExpression(pattern: emailRegEx)
          let nsString = emailAddressString as NSString
          let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
          
          if results.count == 0
          {
              returnValue = false
          }
          
      } catch let error as NSError {
          print("invalid regex: \(error.localizedDescription)")
          returnValue = false
      }
      
      return  returnValue
  }
    func saveUserName(_ UserName: String) {
        UserDefaults.standard.set(UserName, forKey: "UserName")
        UserDefaults.standard.synchronize()
    }
    
    func getUserName() -> String {
        if UserDefaults.standard.object(forKey: "UserName") != nil{
            return UserDefaults.standard.object(forKey: "UserName") as! String
        } else {
            return ""
        }
    }
    func getUserID() -> String {
        if UserDefaults.standard.object(forKey: "userID") != nil {
            return UserDefaults.standard.object(forKey: "userID") as! String
        }else {
            return ""
        }
    }
    func getCurrencyCode() -> String {
        if UserDefaults.standard.object(forKey: "CurrencyCode") != nil{
            return UserDefaults.standard.object(forKey: "CurrencyCode") as! String
        }else{
            return ""
        }
    }
    
    func saveCurrency(_ Currency: String) {
        UserDefaults.standard.set(Currency, forKey: "Currency")
        UserDefaults.standard.synchronize()
    }
    
    func getCurrency() -> String {
        if UserDefaults.standard.object(forKey: "Currency") != nil{
            return UserDefaults.standard.object(forKey: "Currency") as! String
        } else{
            return ""
        }
    }
    func savefirstName(_ UserName: String) {
        UserDefaults.standard.set(UserName, forKey: "firstName")
        UserDefaults.standard.synchronize()
    }
    
    func getfirstName() -> String {
        if UserDefaults.standard.object(forKey: "firstName") != nil{
            return UserDefaults.standard.object(forKey: "firstName") as! String
        } else {
            return ""
        }
    }
    
    func savelastName(_ UserName: String) {
        UserDefaults.standard.set(UserName, forKey: "lastName")
        UserDefaults.standard.synchronize()
    }
    
    func getlastName() -> String {
        if UserDefaults.standard.object(forKey: "lastName") != nil{
            return UserDefaults.standard.object(forKey: "lastName") as! String
        } else {
            return ""
        }
    }
    func getEmailID() -> String {
        if UserDefaults.standard.object(forKey: "EmailID") != nil{
            return UserDefaults.standard.object(forKey: "EmailID") as! String
        } else{
            return ""
        }
    }
    func version() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        let build = dictionary["CFBundleVersion"] as! String
        return "\(version).\(build)"
    }
    func getMobileNum() -> String {
        if UserDefaults.standard.object(forKey: "MobileNum") != nil{
            return UserDefaults.standard.object(forKey: "MobileNum") as! String
        } else{
            return ""
        }
    }
    
    func saveEmailID(_ EmailID: String) {
        UserDefaults.standard.set(EmailID, forKey: "EmailID")
        UserDefaults.standard.synchronize()
    }
    func getuserDP() -> String {
        if UserDefaults.standard.object(forKey: "userDP") != nil {
            return UserDefaults.standard.object(forKey: "userDP") as! String
        } else{
            return ""
        }
    }
    @objc func getBearingBetweenTwoPoints1( _ A: CLLocation, locationB B: CLLocation) -> Double {
        var dlon: Double = self.toRad((B.coordinate.longitude - A.coordinate.longitude))
        let dPhi: Double = log(tan(self.toRad(B.coordinate.latitude) / 2 + .pi / 4) / tan(self.toRad(A.coordinate.latitude) / 2 + .pi / 4))
        if fabs(dlon) > .pi {
            dlon = (dlon > 0) ? (dlon - 2 * .pi) : (2 * .pi + dlon)
        }
        return self.toBearing(atan2(dlon, dPhi))
    }
    
    @objc func toRad(_ degrees: Double) -> Double {
        return degrees * (.pi / 180)
    }
    
    @objc func toBearing(_ radians: Double) -> Double {
        return self.toDegrees(radians) + 360.truncatingRemainder(dividingBy: 360)
    }
    
    @objc func toDegrees(_ radians: Double) -> Double {
        return radians * 180 / .pi
    }
    
    @objc func CheckNullValue(_ value : Any?) -> String {
        var value = value
        var  pureStr:String=""
        if value is NSNull{
            return pureStr
        }
        else {
            if (value == nil){
                value="" as AnyObject
            }
            pureStr = String(describing: value! )
            return pureStr
        }
    }
    
    @objc func setLang(_ str:String)->String {
        return Language_handler.VJLocalizedString(str, comment: nil)
    }
    @objc func Lightgray()->UIColor{
        return UIColor(red:216.0/255.0, green:216.0/255.0 ,blue:216.0/255.0, alpha:1.0)
    }
    @objc func appName() -> NSString{
        return "\(ProductShortAppName)" as NSString
        
    }
    @objc func ThemeColour()->UIColor
    {
        var Theme_Color:UIColor!=UIColor()
        Theme_Color=nil
        
        Theme_Color = PlumberThemeColor
        
        return Theme_Color
    }
    
    @objc func additionalThemeColour()->UIColor
    {
        var Theme_Color:UIColor!=UIColor()
        Theme_Color=nil
        Theme_Color = UIColor(red:0.14, green:0.12, blue:0.13, alpha:0.8)
        return PlumberThemeColor
    }
    
    @objc func removeRotation( _ image: UIImage) -> UIImage {
        if image.imageOrientation == .up {
            return image
        }
        UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
        //[self drawInRect:(CGRect){0, 0, self.size}];
        image.draw(in: CGRect.init(origin:CGPoint(x: 10, y: 20), size:image.size ))
        
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    @objc  func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @objc func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let validEmail = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        do {
            let emailTextInput = try NSRegularExpression(pattern: validEmail)
            let emailString = emailAddressString as NSString
            let results = emailTextInput.matches(in: emailAddressString, range: NSRange(location: 0, length: emailString.length))
            if results.count == 0 {
                returnValue = false
            }
        } catch {
            returnValue = false
        }
        return  returnValue
    }
    
    @objc func TextfieldMaximum(_ String:String, Textfield: UITextField, Count: Int, range: NSRange) -> Bool{
        
        let currentString: NSString = Textfield.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: String) as NSString
        return newString.length <= Count
    }
    
    @objc func SaveDeviceTokenString(_ dToken:NSString) {
        let userDefaults = UserDefaults.standard
        
        let akey = "deviceTokenKey"
        userDefaults.setValue(dToken, forKey: akey)
        userDefaults.synchronize()
    }
    
    @objc func getAddressForLatLng(_ latitude: String, longitude: String , status : String)->String {
        var fullAddress : NSString = NSString()
        let url = URL(string: "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(latitude),\(longitude)&key=\(GoogleApiURLKey)")
        print(url!)
        let data = try? Data(contentsOf: url!)
        if data != nil{
            let json = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            if let result = json["results"] as? NSArray {
                if(result.count != 0){
                    if let address : NSArray = (result.object(at: 0) as AnyObject).value(forKey: "address_components") as? NSArray {
                        
                        print("get current location \(address)")
                        var street = ""
                        var city = ""
                        var locality = ""
                        var state = ""
                        var country = ""
                        var zipcode = ""
                        
                        let streetNameStr : NSMutableString = NSMutableString()
                        
                        for  item in address {
                            
                            let item1 = (item as AnyObject).value(forKey: "types") as! NSArray
                            
                            if((item1.object(at: 0) as! String == "street_number") || (item1.object(at: 0) as! String == "premise") || (item1.object(at: 0) as! String == "route")) {
                                let number1 = (item as AnyObject).value(forKey:"long_name")
                                streetNameStr.append("\(String(describing: number1))")
                                street = streetNameStr  as String
                                
                            }else if(item1.object(at: 0) as! String == "locality"){
                                let city1 = (item as AnyObject).value(forKey: "long_name")
                                city = city1 as! String
                                locality = ""
                            }else if(item1.object(at: 0) as! String == "administrative_area_level_2" || item1.object(at: 0) as! String == "political") {
                                let city1 = (item as AnyObject).value(forKey:"long_name")
                                locality = city1 as! String
                            }else if(item1.object(at: 0) as! String == "administrative_area_level_1" || item1.object(at: 0) as! String == "political") {
                                let city1 = (item as AnyObject).value(forKey: "long_name")
                                state = city1 as! String
                            }else if(item1.object(at: 0) as! String == "country")  {
                                let city1 = (item as AnyObject).value(forKey: "long_name")
                                country = city1 as! String
                            }else if(item1.object(at: 0) as! String == "postal_code" ) {
                                let city1 = (item as AnyObject).value(forKey: "long_name")
                                zipcode = city1 as! String
                            }
                            
                            if status == "short"
                            {
                                fullAddress = "\(street)$\(locality)" as NSString
                            }
                            else
                            {
                                fullAddress = "\(street)$\(city)$\(locality)$\(state)$\(country)$\(zipcode)" as NSString
                                
                            }
                            
                            if let address = (result.object(at: 0) as AnyObject).value(forKey: "formatted_address") as? String{
                                return address
                            }else{
                                return fullAddress as String
                            }
                        }
                    }
                }
            }
        }
        return ""
    }
    
    @objc func saveLanguage(_ str:NSString) {
        var str = str
        
        //  str = "en"
        if(str.isEqual(to: "ta"))      {
            str="ta"
        }
        if(str.isEqual(to: "en")) {
            str="en"
        }
        UserDefaults.standard.set(str, forKey: "LanguageName")
        UserDefaults.standard.synchronize()
    }
    
    @objc func getAppLanguage() -> String {
        if theme.CheckNullValue(UserDefaults.standard.object(forKey: "LanguageName")) == ""
        {
            UserDefaults.standard.set("en", forKey: "LanguageName")
            return UserDefaults.standard.object(forKey: "LanguageName") as! String
        }
        else
        {
            return UserDefaults.standard.object(forKey: "LanguageName") as! String
        }
    }
    @objc func getAppLang() -> String {
        if UserDefaults.standard.object(forKey: "LanguageName") as! String == "en"{
            
            return "en"
        } else if UserDefaults.standard.object(forKey: "LanguageName") as! String == "ta" {
            return "ta"
        }
        else{
            return "en"
        }
    }
    
    
    @objc func SetLanguageToApp(){
        if let savedLang=UserDefaults.standard.object(forKey: "LanguageName") as? NSString
        {
             if(savedLang == "he"){
                 Language_handler.setApplicationLanguage(Language_handler .HebrewLanguageShortName)
             }
             else if(savedLang == "ar") {
                 Language_handler.setApplicationLanguage(Language_handler.ArebicLanguageShortName)
             }
             else if(savedLang == "en") {
                 Language_handler.setApplicationLanguage(Language_handler.EnglishUSLanguageShortName)
             }
        }
    }
    
    @objc func AlertView(_ title:String,Message:String,ButtonTitle:String){
        if(Message as String == kErrorMsg)
        {
            RKDropdownAlert.title(appNameJJ, message: Message as String, backgroundColor: UIColor.white , textColor: UIColor.red)
            return
        }
        RKDropdownAlert.dismissAllAlert()
        RKDropdownAlert.title(appNameJJ, message: Message as String, backgroundColor: UIColor.white , textColor: PlumberThemeColor)
    }
    
    @objc func SetPaddingView (_ text:UITextField) -> UIView
    {
        let paddingView = UIView(frame:CGRect(x: 0, y: 0, width: 20, height: 20))
        text.leftView=paddingView;
        text.leftViewMode = UITextField.ViewMode.always
        return paddingView
        
    }
    func CheckMobileNoAndCountryCodeIsValid(countryCode:String,phoneNumber:String) -> String
        {
            let CheckMobileNo = "\(countryCode)\(phoneNumber)"
            
            var regionCode:String = ""
            
            let phoneNumberKit = PhoneNumberKit()
            do
            {
               // print(phoneNumberKit.getRegionCode(of: phoneNumber))
                let phoneNumber = try phoneNumberKit.parse(CheckMobileNo)
                
                regionCode = phoneNumberKit.getRegionCode(of: phoneNumber)!
                
                print(regionCode)
            
                return regionCode
                
            }
            catch
            {
                
                return ""
                
            }
        }
    func  getAppinformation()
    {
        
        let URL_Handler:URLhandler=URLhandler()
        URL_Handler.makeCall(Appinfo_url, param: [:]) {
            (responseObject, error) -> () in
            
            if(error != nil)
            {
                
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status=self.CheckNullValue(responseObject["status"])
                    if(status == "1")
                    {
                        GetReceipientMail = self.CheckNullValue(responseObject[ "email_address"])
                        kmval = self.CheckNullValue(responseObject["distance_by"])
                        let GoogleApiDict = responseObject["ios_map_api"] as? [String:Any] ?? [:]
                        GoogleApiURLKey = self.CheckNullValue(GoogleApiDict["tasker"])
                        print("The Google Api Key is --->¡\(GoogleApiURLKey)")
                    }
                    else
                    {
                    }
                }
            }
        }
        
    }
    
    
    @objc func SetPaddingViewwithText (_ text:UITextField) -> UIView
    {
        let width = textWidth(text: getappCurrencycode(), font: PlumberBodyFont)
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: width + 10 , height: text.frame.size.height))
        let curency_lbl: UILabel = UILabel.init(frame: paddingView.bounds)
        
        curency_lbl.text = getappCurrencycode()
        curency_lbl.textColor = UIColor.black
        curency_lbl.backgroundColor = .clear
        curency_lbl.font = PlumberBodyFont
        curency_lbl.textAlignment = .right
        paddingView.addSubview(curency_lbl)
        
        text.leftView = paddingView
        text.leftViewMode = UITextField.ViewMode.always
        print("The paddingView is -->\(paddingView)")
        return paddingView
        
    }
    
    func textWidth(text: String, font: UIFont?) -> CGFloat {
        let attributes = font != nil ? [NSAttributedString.Key.font: font] : [:]
        return text.size(withAttributes: attributes as [NSAttributedString.Key : Any]).width
    }
    
    @objc func GetDeviceToken()->NSString{
        var deviceTokenStr = ""
        let akey = "deviceTokenKey"
        let userDefaults = UserDefaults.standard
        if userDefaults.value(forKey: akey) != nil{
        let data0 = userDefaults.value(forKey: akey)
            deviceTokenStr = data0 as! String
        }else
        {
           deviceTokenStr = "5f5dbfc87b1a6c3b48164507906e69d04cf80735f95a34de0396395dcf206395"
        }
        return CheckNullValue(deviceTokenStr) as NSString
    }
    @objc func saveUserDetail(_ userDict:NSDictionary) {
        let userDefaults = UserDefaults.standard
        
        let akey = "userInfoDictKey"
        userDefaults.set(userDict, forKey: akey)
        userDefaults.synchronize()
        if(userDict.count>0){
            saveUserImage(userDict.object(forKey: "provider_image") as! String as NSString)
        }
    }
    
    @objc func saveCountryCode(_ code: String){
        UserDefaults.standard.set(code, forKey: "CtryCode")
        UserDefaults.standard.synchronize()
    }
    
    @objc func getCountryCode() -> String {
        if UserDefaults.standard.object(forKey: "CtryCode") != nil{
            return UserDefaults.standard.object(forKey: "CtryCode") as! String
        }else{
            return ""
        }
    }
    
    @objc func saveDocumentStatus(_ code: String){
//        UserDefaults.standard.set(code, forKey: "DocumentStatus")
        UserDefaults.standard.setValue(code, forKey: "DocumentStatus")
        UserDefaults.standard.synchronize()
    }
    
    @objc func getDocumentStatus() -> String {
        if UserDefaults.standard.value(forKey: "DocumentStatus") != nil {
            return String(format: "%@", UserDefaults.standard.value(forKey: "DocumentStatus") as! CVarArg)
        }else{
            return "0"
        }
//        if UserDefaults.standard.object(forKey: "DocumentStatus") != nil{
//            return UserDefaults.standard.object(forKey: "DocumentStatus") as! String
//        }else{
//            return "0"
//        }
    }
    
    
    @objc func saveHidestatus(_ status: String) {
        UserDefaults.standard.set(status, forKey: "dismiss")
        UserDefaults.standard.synchronize()
    }
    
    @objc func getHideStatus() -> String {
        if UserDefaults.standard.object(forKey: "dismiss") != nil{
            return UserDefaults.standard.object(forKey: "dismiss") as! String
        }else{
            return ""
        }
    }
    
    @objc func saveworkLocation(_ workLocation: String) {
        UserDefaults.standard.set(workLocation, forKey: "workLocation")
        UserDefaults.standard.synchronize()
    }
    
    @objc func getworkLocation() -> String {
        if UserDefaults.standard.object(forKey: "workLocation") != nil{
            return UserDefaults.standard.object(forKey: "workLocation") as! String
        }else{
            return ""
        }
    }
    
    @objc func theDeviceisHavingNotch(_ isIphoneX : Bool ){
        UserDefaults.standard.set(isIphoneX, forKey: "iPhoneX")
        UserDefaults.standard.synchronize()
    }
    
    @objc func yesTheDeviceisHavingNotch() -> Bool
    {
        if UserDefaults.standard.bool(forKey: "iPhoneX") == true {
            return true
        }else{
            return false
        }
    }
    
    @objc func saveFullName(UserName : String){
        UserDefaults.standard.set(UserName, forKey: "UserName")
        UserDefaults.standard.synchronize()
    }
    
    @objc func getFullName() -> String{
        if (UserDefaults.standard.string(forKey: "UserName") != nil){
            return UserDefaults.standard.object(forKey: "UserName") as! String
        }else{
            return ""
        }
    }
    
    func getColorString(Str: String,Str1: String) -> NSMutableAttributedString {
        let attrs1 = [NSAttributedString.Key.font : PlumberSmallFont, NSAttributedString.Key.foregroundColor : UIColor.black]
        let attrs2 = [NSAttributedString.Key.font : PlumberSmallFont, NSAttributedString.Key.foregroundColor : PlumberThemeColor]
        let attributedString1 = NSMutableAttributedString(string:Str, attributes:attrs1)
        let attributedString2 = NSMutableAttributedString(string:Str1, attributes:attrs2)
        attributedString1.append(attributedString2)
        return attributedString1
    }
    func getCountryList() -> (NSDictionary) {
        let dict = [
            "AF" : ["Afghanistan", "93"],
            "AX" : ["Aland Islands", "358"],
            "AL" : ["Albania", "355"],
            "DZ" : ["Algeria", "213"],
            "AS" : ["American Samoa", "1"],
            "AD" : ["Andorra", "376"],
            "AO" : ["Angola", "244"],
            "AI" : ["Anguilla", "1"],
            "AQ" : ["Antarctica", "672"],
            "AG" : ["Antigua and Barbuda", "1"],
            "AR" : ["Argentina", "54"],
            "AM" : ["Armenia", "374"],
            "AW" : ["Aruba", "297"],
            "AU" : ["Australia", "61"],
            "AT" : ["Austria", "43"],
            "AZ" : ["Azerbaijan", "994"],
            "BS" : ["Bahamas", "1"],
            "BH" : ["Bahrain", "973"],
            "BD" : ["Bangladesh", "880"],
            "BB" : ["Barbados", "1"],
            "BY" : ["Belarus", "375"],
            "BE" : ["Belgium", "32"],
            "BZ" : ["Belize", "501"],
            "BJ" : ["Benin", "229"],
            "BM" : ["Bermuda", "1"],
            "BT" : ["Bhutan", "975"],
            "BO" : ["Bolivia", "591"],
            "BA" : ["Bosnia and Herzegovina", "387"],
            "BW" : ["Botswana", "267"],
            "BV" : ["Bouvet Island", "47"],
            "BQ" : ["BQ", "599"],
            "BR" : ["Brazil", "55"],
            "IO" : ["British Indian Ocean Territory", "246"],
            "VG" : ["British Virgin Islands", "1"],
            "BN" : ["Brunei Darussalam", "673"],
            "BG" : ["Bulgaria", "359"],
            "BF" : ["Burkina Faso", "226"],
            "BI" : ["Burundi", "257"],
            "KH" : ["Cambodia", "855"],
            "CM" : ["Cameroon", "237"],
            "CA" : ["Canada", "1"],
            "CV" : ["Cape Verde", "238"],
            "KY" : ["Cayman Islands", "345"],
            "CF" : ["Central African Republic", "236"],
            "TD" : ["Chad", "235"],
            "CL" : ["Chile", "56"],
            "CN" : ["China", "86"],
            "CX" : ["Christmas Island", "61"],
            "CC" : ["Cocos (Keeling) Islands", "61"],
            "CO" : ["Colombia", "57"],
            "KM" : ["Comoros", "269"],
            "CG" : ["Congo (Brazzaville)", "242"],
            "CD" : ["Congo, Democratic Republic of the", "243"],
            "CK" : ["Cook Islands", "682"],
            "CR" : ["Costa Rica", "506"],
            "CI" : ["Côte d'Ivoire", "225"],
            "HR" : ["Croatia", "385"],
            "CU" : ["Cuba", "53"],
            "CW" : ["Curacao", "599"],
            "CY" : ["Cyprus", "537"],
            "CZ" : ["Czech Republic", "420"],
            "DK" : ["Denmark", "45"],
            "DJ" : ["Djibouti", "253"],
            "DM" : ["Dominica", "1"],
            "DO" : ["Dominican Republic", "1"],
            "EC" : ["Ecuador", "593"],
            "EG" : ["Egypt", "20"],
            "SV" : ["El Salvador", "503"],
            "GQ" : ["Equatorial Guinea", "240"],
            "ER" : ["Eritrea", "291"],
            "EE" : ["Estonia", "372"],
            "ET" : ["Ethiopia", "251"],
            "FK" : ["Falkland Islands (Malvinas)", "500"],
            "FO" : ["Faroe Islands", "298"],
            "FJ" : ["Fiji", "679"],
            "FI" : ["Finland", "358"],
            "FR" : ["France", "33"],
            "GF" : ["French Guiana", "594"],
            "PF" : ["French Polynesia", "689"],
            "TF" : ["French Southern Territories", "689"],
            "GA" : ["Gabon", "241"],
            "GM" : ["Gambia", "220"],
            "GE" : ["Georgia", "995"],
            "DE" : ["Germany", "49"],
            "GH" : ["Ghana", "233"],
            "GI" : ["Gibraltar", "350"],
            "GR" : ["Greece", "30"],
            "GL" : ["Greenland", "299"],
            "GD" : ["Grenada", "1"],
            "GP" : ["Guadeloupe", "590"],
            "GU" : ["Guam", "1"],
            "GT" : ["Guatemala", "502"],
            "GG" : ["Guernsey", "44"],
            "GN" : ["Guinea", "224"],
            "GW" : ["Guinea-Bissau", "245"],
            "GY" : ["Guyana", "595"],
            "HT" : ["Haiti", "509"],
            "VA" : ["Holy See (Vatican City State)", "379"],
            "HN" : ["Honduras", "504"],
            "HK" : ["Hong Kong, Special Administrative Region of China", "852"],
            "HU" : ["Hungary", "36"],
            "IS" : ["Iceland", "354"],
            "IN" : ["India", "91"],
            "ID" : ["Indonesia", "62"],
            "IR" : ["Iran, Islamic Republic of", "98"],
            "IQ" : ["Iraq", "964"],
            "IE" : ["Ireland", "353"],
            "IM" : ["Isle of Man", "44"],
            "IL" : ["Israel", "972"],
            "IT" : ["Italy", "39"],
            "JM" : ["Jamaica", "1"],
            "JP" : ["Japan", "81"],
            "JE" : ["Jersey", "44"],
            "JO" : ["Jordan", "962"],
            "KZ" : ["Kazakhstan", "77"],
            "KE" : ["Kenya", "254"],
            "KI" : ["Kiribati", "686"],
            "KP" : ["Korea, Democratic People's Republic of", "850"],
            "KR" : ["Korea, Republic of", "82"],
            "KW" : ["Kuwait", "965"],
            "KG" : ["Kyrgyzstan", "996"],
            "LA" : ["Lao PDR", "856"],
            "LV" : ["Latvia", "371"],
            "LB" : ["Lebanon", "961"],
            "LS" : ["Lesotho", "266"],
            "LR" : ["Liberia", "231"],
            "LY" : ["Libya", "218"],
            "LI" : ["Liechtenstein", "423"],
            "LT" : ["Lithuania", "370"],
            "LU" : ["Luxembourg", "352"],
            "MO" : ["Macao, Special Administrative Region of China", "853"],
            "MK" : ["Macedonia, Republic of", "389"],
            "MG" : ["Madagascar", "261"],
            "MW" : ["Malawi", "265"],
            "MY" : ["Malaysia", "60"],
            "MV" : ["Maldives", "960"],
            "ML" : ["Mali", "223"],
            "MT" : ["Malta", "356"],
            "MH" : ["Marshall Islands", "692"],
            "MQ" : ["Martinique", "596"],
            "MR" : ["Mauritania", "222"],
            "MU" : ["Mauritius", "230"],
            "YT" : ["Mayotte", "262"],
            "MX" : ["Mexico", "52"],
            "FM" : ["Micronesia, Federated States of", "691"],
            "MD" : ["Moldova", "373"],
            "MC" : ["Monaco", "377"],
            "MN" : ["Mongolia", "976"],
            "ME" : ["Montenegro", "382"],
            "MS" : ["Montserrat", "1"],
            "MA" : ["Morocco", "212"],
            "MZ" : ["Mozambique", "258"],
            "MM" : ["Myanmar", "95"],
            "NA" : ["Namibia", "264"],
            "NR" : ["Nauru", "674"],
            "NP" : ["Nepal", "977"],
            "NL" : ["Netherlands", "31"],
            "AN" : ["Netherlands Antilles", "599"],
            "NC" : ["New Caledonia", "687"],
            "NZ" : ["New Zealand", "64"],
            "NI" : ["Nicaragua", "505"],
            "NE" : ["Niger", "227"],
            "NG" : ["Nigeria", "234"],
            "NU" : ["Niue", "683"],
            "NF" : ["Norfolk Island", "672"],
            "MP" : ["Northern Mariana Islands", "1"],
            "NO" : ["Norway", "47"],
            "OM" : ["Oman", "968"],
            "PK" : ["Pakistan", "92"],
            "PW" : ["Palau", "680"],
            "PS" : ["Palestinian Territory, Occupied", "970"],
            "PA" : ["Panama", "507"],
            "PG" : ["Papua New Guinea", "675"],
            "PY" : ["Paraguay", "595"],
            "PE" : ["Peru", "51"],
            "PH" : ["Philippines", "63"],
            "PN" : ["Pitcairn", "872"],
            "PL" : ["Poland", "48"],
            "PT" : ["Portugal", "351"],
            "PR" : ["Puerto Rico", "1"],
            "QA" : ["Qatar", "974"],
            "RE" : ["Réunion", "262"],
            "RO" : ["Romania", "40"],
            "RU" : ["Russian Federation", "7"],
            "RW" : ["Rwanda", "250"],
            "SH" : ["Saint Helena", "290"],
            "KN" : ["Saint Kitts and Nevis", "1"],
            "LC" : ["Saint Lucia", "1"],
            "PM" : ["Saint Pierre and Miquelon", "508"],
            "VC" : ["Saint Vincent and Grenadines", "1"],
            "BL" : ["Saint-Barthélemy", "590"],
            "MF" : ["Saint-Martin (French part)", "590"],
            "WS" : ["Samoa", "685"],
            "SM" : ["San Marino", "378"],
            "ST" : ["Sao Tome and Principe", "239"],
            "SA" : ["Saudi Arabia", "966"],
            "SN" : ["Senegal", "221"],
            "RS" : ["Serbia", "381"],
            "SC" : ["Seychelles", "248"],
            "SL" : ["Sierra Leone", "232"],
            "SG" : ["Singapore", "65"],
            "SX" : ["Sint Maarten", "1"],
            "SK" : ["Slovakia", "421"],
            "SI" : ["Slovenia", "386"],
            "SB" : ["Solomon Islands", "677"],
            "SO" : ["Somalia", "252"],
            "ZA" : ["South Africa", "27"],
            "GS" : ["South Georgia and the South Sandwich Islands", "500"],
            "SS​" : ["South Sudan", "211"],
            "ES" : ["Spain", "34"],
            "LK" : ["Sri Lanka", "94"],
            "SD" : ["Sudan", "249"],
            "SR" : ["Suriname", "597"],
            "SJ" : ["Svalbard and Jan Mayen Islands", "47"],
            "SZ" : ["Swaziland", "268"],
            "SE" : ["Sweden", "46"],
            "CH" : ["Switzerland", "41"],
            "SY" : ["Syrian Arab Republic (Syria)", "963"],
            "TW" : ["Taiwan, Republic of China", "886"],
            "TJ" : ["Tajikistan", "992"],
            "TZ" : ["Tanzania, United Republic of", "255"],
            "TH" : ["Thailand", "66"],
            "TL" : ["Timor-Leste", "670"],
            "TG" : ["Togo", "228"],
            "TK" : ["Tokelau", "690"],
            "TO" : ["Tonga", "676"],
            "TT" : ["Trinidad and Tobago", "1"],
            "TN" : ["Tunisia", "216"],
            "TR" : ["Turkey", "90"],
            "TM" : ["Turkmenistan", "993"],
            "TC" : ["Turks and Caicos Islands", "1"],
            "TV" : ["Tuvalu", "688"],
            "UG" : ["Uganda", "256"],
            "UA" : ["Ukraine", "380"],
            "AE" : ["United Arab Emirates", "971"],
            "GB" : ["United Kingdom", "44"],
            "US" : ["United States of America", "1"],
            "UY" : ["Uruguay", "598"],
            "UZ" : ["Uzbekistan", "998"],
            "VU" : ["Vanuatu", "678"],
            "VE" : ["Venezuela (Bolivarian Republic of)", "58"],
            "VN" : ["Viet Nam", "84"],
            "VI" : ["Virgin Islands, US", "1"],
            "WF" : ["Wallis and Futuna Islands", "681"],
            "EH" : ["Western Sahara", "212"],
            "YE" : ["Yemen", "967"],
            "ZM" : ["Zambia", "260"],
            "ZW" : ["Zimbabwe", "263"]
        ]
        
        return dict as (NSDictionary)
    }
    
    
    @objc func saveUserImage(_ imgStr:NSString){
        var imgStr = imgStr
        if(imgStr.length==0){
            imgStr=""
        }
        let userDefaults = UserDefaults.standard
        
        let akey = "userInfoImgDictKey"
        userDefaults.set(imgStr, forKey: akey)
        userDefaults.synchronize()
    }
    
    @objc func GetUserImage()->NSString{
        
        let akey = "userInfoImgDictKey"
        let userDefaults = UserDefaults.standard
        var data0 = userDefaults.string(forKey: akey)
        if(data0==nil){
            data0=""
        }
        let userDict:String = data0!
        return userDict as NSString
    }
    
    @objc func isUserLigin()->Bool{
        let akey = "userInfoDictKey"
        let userDefaults = UserDefaults.standard
        let data0 = userDefaults.dictionary(forKey: akey)
        if(data0==nil || data0?.count==0){
            return false
        }else{
            return true
        }
    }
    @objc func GetUserDetails()->UserInfoRecord{
        
        let akey = "userInfoDictKey"
        let userDefaults = UserDefaults.standard
        let data0 = userDefaults.dictionary(forKey: akey)
        let responseObject = data0 as NSDictionary?
        
        let objUserRec : UserInfoRecord = UserInfoRecord(prov_name: self.CheckNullValue(responseObject?["provider_name"]),prov_ID: self.CheckNullValue(responseObject?["provider_id"]), prov_Image: self.CheckNullValue(responseObject?["provider_image"]),prov_Email: self.CheckNullValue(responseObject?["email"]),prov_mob: self.CheckNullValue(responseObject?["email"]))
        return objUserRec
    }
    @objc func rotateImage(_ image: UIImage) -> UIImage {
        if (image.imageOrientation == UIImage.Orientation.up ) {
            return image
        }
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        let copy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return copy!
    }
    @objc func UpdateAvailability (_ availblesta:String){
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["tasker":"\(objUserRecs.providerId)","availability" :"\(availblesta)"]
        
        url_handler.makeCall(EnableAvailabilty, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            
            if(error != nil)
            {
            }
            else
            {
                if(responseObject != nil && (responseObject?.count)!>0)
                {
                    let responseObject = responseObject!
                    let status:NSString = theme.CheckNullValue(responseObject.object(forKey: "status") as AnyObject) as NSString
                    if(status == "1")
                    {
                        let resDict: NSDictionary = responseObject.object(forKey: "response") as! NSDictionary
                        let tasker_status : String = theme.CheckNullValue(resDict.object(forKey: "tasker_status") as AnyObject)
                        
                        if (tasker_status == "1")
                        {
                        }
                        else
                        {
                        }
                    }
                    else
                    {
                    }
                }
            }
        }
    }
    @objc func getCurrencyCode(_ code:String)->String{
        let currencyCode = code
        
        let currencySymbols  = Locale.availableIdentifiers
            .map { Locale(identifier: $0) }
            .filter {
                if let localeCurrencyCode = ($0 as NSLocale).object(forKey: NSLocale.Key.currencyCode) as? String {
                    return localeCurrencyCode == currencyCode
                } else {
                    return false
                }
            }
            .map {
                ($0.identifier, ($0 as NSLocale).object(forKey: NSLocale.Key.currencySymbol)!)
        }
        return CheckNullValue((currencySymbols.first?.1 as AnyObject))
    }
    @objc func saveJaberPassword(_ JaberPassword: String) {
        UserDefaults.standard.set(JaberPassword, forKey: "JaberPassword")
        UserDefaults.standard.synchronize()
    }
    
    @objc func getJaberPassword() -> String? {
        return (UserDefaults.standard.object(forKey: "JaberPassword") as? String)
        
    }
    
    @objc func getAppName() -> String {
        return Bundle.main.infoDictionary!["CFBundleName"] as! String
        
        
    }
    @objc func convertIntToString(_ integer : Int) -> NSString {
        var str:NSString = NSString()
        str = "\(integer)" as NSString
        return str
    }
    
    @objc func saveAvailable_satus(_ Available : String) {
        UserDefaults.standard.set(Available, forKey: "Availability")
        UserDefaults.standard.synchronize()
        
    }
    
    @objc func getAvailable_satus() -> String {
        
        if UserDefaults.standard.object(forKey: "Availability") != nil
        {
            return (UserDefaults.standard.object(forKey: "Availability") as? String)!
        }
        else
        {
            return ""
        }
    }
    
    @objc func saveTaskerMobileNumber(_ MobileNumber : String) {
        UserDefaults.standard.set(MobileNumber, forKey: "TaskerMobileNumber")
        UserDefaults.standard.synchronize()
        
    }
    
    @objc func getTaskerMobileNumber() -> String {
        
        if UserDefaults.standard.object(forKey: "TaskerMobileNumber") != nil
        {
            return (UserDefaults.standard.object(forKey: "TaskerMobileNumber") as? String)!
        }
        else
        {
            return ""
        }
    }
    
    
    @objc func saveVerifiedStatus(VerifiedStatus : Int) {
        UserDefaults.standard.set(VerifiedStatus, forKey: "Verified_Status")
        UserDefaults.standard.synchronize()
        
    }
    
    @objc func getVerifiedStatus() -> Int {
        
        if UserDefaults.standard.object(forKey: "Verified_Status") != nil
        {
            return (UserDefaults.standard.object(forKey: "Verified_Status") as? Int)!
        }
        else
        {
            return 0
        }
    }
    
    @objc func Set(CountryCode : UILabel , WithFlag : UIImageView){
        let CallingCodes = { () -> [[String: String]] in
            let resourceBundle = Bundle(for: MICountryPicker.classForCoder())
            guard let path = resourceBundle.path(forResource: "CallingCodes", ofType: "plist") else { return [] }
            return NSArray(contentsOfFile: path) as! [[String: String]]
        }()
        let CtryCode:String = self.getCountryCode()
        let bundle = "assets.bundle/"
       
        let countryData = CallingCodes.filter { $0["code"] == CtryCode }
      
        if countryData.count > 0
        {
            let dict = countryData[0]
            CountryCode.text = dict["dial_code"]
            WithFlag.image = UIImage(named: "\(bundle)\(CtryCode.uppercased())\(".png")", in:Bundle (for: type(of: self)), compatibleWith: nil)!
        }
        else
        {
            let countryDataNew = CallingCodes.filter { $0["dial_code"] == CtryCode }
         
            if countryDataNew.count > 0
            {
                if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String
                {
                    let countryDataNew1 = CallingCodes.filter { $0["code"] == countryCode }
                    if countryDataNew1.count > 0
                    {
                        let dict = countryDataNew1[0]
                      
                        CountryCode.text = dict["dial_code"]
                        if let code = dict["code"]
                        {
                            
                            WithFlag.image = UIImage(named: "\(bundle)\(code.uppercased())\(".png")", in:Bundle (for: type(of: self)), compatibleWith: nil)!
                        }
                        else
                        {
                            CountryCode.text = "+91"
                            WithFlag.image = UIImage(named: "\(bundle)\("IN")\(".png")", in:Bundle (for: type(of: self)), compatibleWith: nil)!
                        }
                    }
                    else
                    {
                        if countryDataNew.count > 0
                        {
                            let dict = countryDataNew[0]
                          
                            CountryCode.text = dict["dial_code"]
                            if let code = dict["code"]
                            {
                                
                                WithFlag.image = UIImage(named: "\(bundle)\(code.uppercased())\(".png")", in:Bundle (for: type(of: self)), compatibleWith: nil)!
                            }
                            else
                            {
                                CountryCode.text = "+91"
                                WithFlag.image = UIImage(named: "\(bundle)\("IN")\(".png")", in:Bundle (for: type(of: self)), compatibleWith: nil)!
                            }
                        }
                    }
                    
                }
                else
                {
                    let countryDataNew = CallingCodes.filter { $0["dial_code"] == CtryCode }
                    if countryDataNew.count > 0
                    {
                        let dict = countryDataNew[0]
                      
                        CountryCode.text = dict["dial_code"]
                        if let code = dict["code"]
                        {
                            
                            WithFlag.image = UIImage(named: "\(bundle)\(code.uppercased())\(".png")", in:Bundle (for: type(of: self)), compatibleWith: nil)!
                        }
                        else
                        {
                            CountryCode.text = "+91"
                            WithFlag.image = UIImage(named: "\(bundle)\("IN")\(".png")", in:Bundle (for: type(of: self)), compatibleWith: nil)!
                        }
                    }
                    
                    
                }
                
                
            }
            else
            {
                CountryCode.text = "+91"
                WithFlag.image = UIImage(named: "\(bundle)\("IN")\(".png")", in:Bundle (for: type(of: self)), compatibleWith: nil)!
            }
            
        }
    }
    
    @objc func PulsateAnimation(_ view : UIView){
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 1
        pulseAnimation.fromValue = 0
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = Float.greatestFiniteMagnitude
        view.layer.add(pulseAnimation, forKey: nil)
    }
    
    //MARK: - Gradient
    func addGradient(_ gradVIew: UIView , colo1 color1: UIColor, colo2 color2: UIColor, colo3 color3: UIColor = .clear, direction pathdir: GradientDirection , Frame : CGRect , CornerRadius cornerRadius : Bool , Radius : CGFloat) {
        
        if cornerRadius == true {
        gradVIew.layer.cornerRadius = Radius
        gradVIew.layer.masksToBounds = true
        }
        let theViewGradient = CAGradientLayer()
        theViewGradient.colors = [color1.cgColor, color2.cgColor]
        theViewGradient.frame = gradVIew.bounds
        theViewGradient.frame = Frame
        theViewGradient.name = "Gradient"
        
        if pathdir == .LefttoRight {// left to Right
            theViewGradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            theViewGradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        }else if pathdir == .LefttoRightDiagonal{// left to Right Diagonal
            theViewGradient.startPoint = CGPoint(x: 0.0, y: 1.0)
            theViewGradient.endPoint = CGPoint(x: 1.0, y: 0.0)
        }else if pathdir == .ToptoBottom { // top to bottom
            theViewGradient.startPoint = CGPoint(x: 0.5, y: 0.0)
            theViewGradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        }else if pathdir == .RighttoLeftDiagonal { // Right to left Diagonal
            theViewGradient.startPoint = CGPoint(x: 0.0, y: 0.0)
            theViewGradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        }
        
        //Add gradient to view
        gradVIew.layer.insertSublayer(theViewGradient, at: 0)
        gradVIew.layoutIfNeeded()
        gradVIew.setNeedsLayout()
        
    }
    
    @objc func ConvertDate(Date:String , FromDateStr: String , ToDateStr:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = FromDateStr
        
        let ToDateFormatter = dateFormatter.date(from: Date)
        dateFormatter.dateFormat = ToDateStr
        
        let FinalDate = dateFormatter.string(from: ToDateFormatter!)
        return FinalDate
    }
    
    @objc func showProgress(View:UIView)
    {
        self.activityIndicatorView.color = PlumberThemeColor
        self.activityIndicatorView.center=CGPoint(x: View.frame.size.width/2,y: View.frame.size.height/2);
        self.activityIndicatorView.startAnimating()
        View.addSubview(activityIndicatorView)
    }
    
   @objc func DismissProgress()
    {
        self.activityIndicatorView.stopAnimating()
        self.activityIndicatorView.removeFromSuperview()
    }
    
    @objc func ShowNotification(Title:String , message:String, _ ShowDuration:TimeInterval = 3.0, Indentifier:String){
        let title = ""
        let subtitle = Title
        let Message = message
        let image =  #imageLiteral(resourceName: "handyexpertslogo")
        Notificationview.title = title
        Notificationview.subtitle = subtitle
        Notificationview.body = Message
        Notificationview.iconImageView.image = image
        Notificationview.image = image
        Notificationview.hideDuration = ShowDuration
        Notificationview.theme = .default
        Notificationview.identifier = Indentifier
        Notificationview.delegate = self
        Notificationview.show()
    }
    
    @objc func setfontForPrice(with currency:String, _ amount:String, using baseColor:UIColor, currencyColor:UIColor? = nil) -> NSAttributedString{
        
        let localAmounts = amount.components(separatedBy: ".")
        var currencyAttribute = [NSAttributedString.Key.baselineOffset: 5,
                                 NSAttributedString.Key.font: UIFont(name: plumberMediumFontStr, size: 12) ?? UIFont.systemFont(ofSize: 12)] as [NSAttributedString.Key : Any]
        if let color = currencyColor{
            currencyAttribute[NSAttributedString.Key.foregroundColor] = color
        }else{
            currencyAttribute[NSAttributedString.Key.foregroundColor] = baseColor
        }
        let decimalAttribute = [NSAttributedString.Key.font: UIFont(name: plumberMediumFontStr, size: 15) ?? UIFont.systemFont(ofSize: 15),
                                NSAttributedString.Key.foregroundColor : baseColor] as [NSAttributedString.Key : Any]
        let normalAttribute = [NSAttributedString.Key.font: UIFont(name: plumberMediumFontStr, size: 20) ?? UIFont.systemFont(ofSize: 20),
                               NSAttributedString.Key.foregroundColor : baseColor] as [NSAttributedString.Key : Any]
        let mutableAttributedString = NSMutableAttributedString()
        let currencyAttributedStr = NSAttributedString(string: currency, attributes: currencyAttribute)
        mutableAttributedString.append(currencyAttributedStr)
        guard localAmounts.count > 0 else{return mutableAttributedString}
        let amountAttributedStr = NSAttributedString(string: localAmounts[0], attributes: normalAttribute)
        mutableAttributedString.append(amountAttributedStr)
        guard localAmounts.count > 1 else{return mutableAttributedString}
        let CombinedStr = ".\(localAmounts[1])"
        let decimalAttributedStr = NSAttributedString(string: CombinedStr, attributes: decimalAttribute)
        mutableAttributedString.append(decimalAttributedStr)
        return  mutableAttributedString
    }
    
    @objc func saveappCurrencycode(_ code: String) {
        UserDefaults.standard.set(code, forKey: "currencyCode")
        UserDefaults.standard.synchronize()
    }
    @objc func getappCurrencycode() -> String {
        
        if UserDefaults.standard.object(forKey: "currencyCode") != nil
        {
            return UserDefaults.standard.object(forKey: "currencyCode") as! String
        }
        else
        {
            return ""
        }
    }
    
    @objc func MakeAnimation(view : CSAnimationView, animation_type : String)
    {
        view.type = animation_type
        view.duration = 0.5
        view.delay = 0
        view.startCanvasAnimation()
    }
    
}

//    extension UINavigationController
//    {
//        @objc func pushViewController(withFlip controller: UIViewController, animated : Bool) {
//            UIView.animate(withDuration: 0.50, animations: {() -> Void in
//                if(animated)
//                {
//                    UIView.setAnimationCurve(.easeInOut)
//                    self.pushViewController(controller, animated: false)
//                    UIView.setAnimationTransition(.flipFromRight, for: self.view, cache: false)
//                }
//                else
//                {
//                    self.pushViewController(controller, animated: false)
//                }
//
//            })
//        }
//        @objc func popViewControllerWithFlip(animated : Bool) {
//            UIView.animate(withDuration: 0.50, animations: {() -> Void in
//                if(animated)
//                {
//                    UIView.setAnimationCurve(.easeInOut)
//                    self.popViewController(animated: false)
//                    UIView.setAnimationTransition(.flipFromLeft, for: self.view, cache: false)
//                }
//                else
//                {
//                    self.popViewController(animated: false)
//                }
//            })
//        }
//    }

extension UINavigationController
{
    @objc func pushViewController(withFlip controller: UIViewController, animated : Bool) {
        self.addPushAnimation(controller: controller, animated: animated)
    }
    @objc func popViewControllerWithFlip(animated : Bool) {
        self.addPopAnimation(animated: animated)
    }
    
    @objc func poptoViewControllerWithFlip(controller : UIViewController, animated : Bool) {
        self.addPopToViewAnimation(controller: controller, animated: animated)
    }
    
    @objc func perfromSegueWithFlip(controller : UIViewController, animated : Bool)
    {
        self.addPushAnimation(controller: controller, animated: animated)
    }
    
    @objc func pushToTheViewController(controller : UIViewController , animated : Bool){
        self.addNormalPushFunction(controller : controller, animates : animated)
    }
    
    @objc func popToTheViewController(animated : Bool){
        self.addnormalpopFunction(animates: animated)
    }
    
    @objc func pushViewController(withFade controller : UIViewController, animated : Bool){
        self.pushAnimationFade(controller : controller, animated : animated)
    }
    
    @objc func popViewControllerwithFade (animated : Bool){
        self.popAnimationFade(animated: animated)
    }
        
    @objc func pushAnimationFade(controller : UIViewController, animated : Bool){
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromTop
        self.view.layer.add(transition, forKey: kCATransition)
        self.pushViewController(controller, animated: animated)
    }
    
    @objc func popAnimationFade(animated : Bool){
        let transition = CATransition()
        transition.duration = 0.2
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.layer.add(transition, forKey: kCATransition)
        self.popViewController( animated: animated)
    }
    
    @objc func addNormalPushFunction(controller : UIViewController, animates : Bool){
        self.pushViewController(controller, animated: animates)
    }
    
    @objc func addnormalpopFunction(animates : Bool){
        self.popViewController(animated: animates)
    }
    
    @objc func addPushAnimation(controller : UIViewController, animated : Bool)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push;
        transition.subtype = CATransitionSubtype.fromBottom;
        self.view.layer.add(transition, forKey: kCATransition)
        self.pushViewController(controller, animated: animated)
    }
    
    @objc func addPopAnimation(animated : Bool) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.layer.add(transition, forKey:kCATransition)
        self.popViewController(animated: animated)
    }
    
    @objc func addPopToViewAnimation(controller : UIViewController, animated : Bool) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromBottom
        self.view.layer.add(transition, forKey:kCATransition)
        self.popToViewController(controller, animated: animated)
    }
    func getEmailID() -> String {
        if UserDefaults.standard.object(forKey: "EmailID") != nil{
            return UserDefaults.standard.object(forKey: "EmailID") as! String
        } else{
            return ""
        }
    }
    
}



extension UIButton
{
    @objc func buttonBouncing(){
        self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        UIView.animate(withDuration: 2.0,delay: 0,usingSpringWithDamping: 0.2,initialSpringVelocity: 6.0,options: .allowUserInteraction,animations: {
            [weak self] in
            self?.transform = .identity
            },completion: nil)
    }
}

extension UITableView {
    
    @objc func reload() {
        self.reloadData()
        let cells = self.visibleCells
        let indexPaths = self.indexPathsForVisibleRows
        let size = UIScreen.main.bounds.size
        for i in cells {
            let cell = self.cellForRow(at: indexPaths![cells.firstIndex(of: i)!])
            cell?.transform = CGAffineTransform(translationX: -size.width, y: 0)
        }
        var index = 0
        for a in cells {
            let cell = self.cellForRow(at: indexPaths![cells.firstIndex(of: a)!])
            UIView.animate(withDuration: 1.5, delay: 0.05 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: UIView.AnimationOptions(), animations: {
                cell?.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: nil)
            index += 1
        }
    }
    
    @objc func reloadTable(){
        self.reloadData()
        let cells = self.visibleCells
        let indexPaths = self.indexPathsForVisibleRows
        let size = UIScreen.main.bounds.size
        for i in cells
        {
            let cell = self.cellForRow(at: indexPaths![cells.firstIndex(of: i)!])
            cell?.transform = CGAffineTransform(translationX: -size.width, y: 0)
        }
        var index = 0
        for a in cells
        {
            let cell = self.cellForRow(at: indexPaths![cells.firstIndex(of: a)!])
            cell?.layer.transform = CATransform3DMakeScale(0.1,0.1,1)
            UIView.animate(withDuration: 0.3, animations: {
                cell?.layer.transform = CATransform3DMakeScale(1.05,1.05,1)
            },completion: { finished in
                UIView.animate(withDuration: 0.1, animations: {
                    cell?.layer.transform = CATransform3DMakeScale(1,1,1)
                })
            })
            index += 1
        }
    }
}

extension UIView
{
    @objc func SpringAnimations(){
        self.transform = CGAffineTransform(scaleX: 0, y: 0);
        UIView.animate(withDuration: 1.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1);
        }) { (finished) in
            print("animation completed")
        }
    }
    
    @objc func dropShadow(scale: Bool = true , shadowOpacity : Float = 0.2 , shadowRadius : CGFloat , Color : UIColor = UIColor.black) {
//        layer.masksToBounds = false
        layer.shadowColor = Color.cgColor
        layer.shadowOpacity = shadowOpacity
        layer.shadowOffset = .zero
        layer.shadowRadius = shadowRadius
//        layer.shouldRasterize = true
//        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    @objc func setView(cornerRadius:CGFloat = 0 , Bgcolor:UIColor , titleColor:UIColor) {
        self.layer.cornerRadius = cornerRadius
       self.layer.masksToBounds = true
        
        if self.isKind(of: UIButton.self){
            (self as! UIButton).setTitleColor(titleColor, for: .normal)
             self.backgroundColor = Bgcolor
        }else if self.isKind(of: UILabel.self){
            (self as! UILabel).textColor = titleColor
             self.backgroundColor = Bgcolor
        }
    }
    
    @objc func SetBackButtonShadow(){
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = .zero
        layer.shadowRadius = 8
        layer.shouldRasterize = true
        layer.cornerRadius = self.frame.width/2
        self.backgroundColor = PlumberThemeColor
    }
    
    @objc func AddBlurEffect(){
    
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.alpha = 0.5
    blurEffectView.frame = self.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.addSubview(blurEffectView)
    }
    
    @objc func removeBlurEffect() {
        let blurredEffectViews = self.subviews.filter{$0 is UIVisualEffectView}
        blurredEffectViews.forEach{ blurView in
            blurView.removeFromSuperview()
        }
    }
}
extension UILabel
{
    @objc func Spring(){
        self.transform = CGAffineTransform(scaleX: 0, y: 0);
        UIView.animate(withDuration: 1.5, delay: 0.05, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            self.transform = CGAffineTransform(scaleX: 1, y: 1);
        }) { (finished) in
            print("animation completed")
        }
    }
}

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        return identifier
    }
    
    public var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    // Screen height.
    public var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
} //print(UIDevice.current.modelName)  /*-> (Impliment in which ever Viewcontroller needed)*/

extension Bundle {
    static func appName() -> String {
        guard let dictionary = Bundle.main.infoDictionary else {
            return ""
        }
        if let version : String = dictionary["CFBundleName"] as? String {
            return version
        } else {
            return ""
        }
    }
}

extension Notification.Name {
    static let didReceiveverificationStatus = Notification.Name("verificatiostatusrecieved")
//    static let didCompleteTask = Notification.Name("didCompleteTask")
//    static let completedLengthyDownload = Notification.Name("completedLengthyDownload")
}

extension String {
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + self.lowercased().dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

extension UIViewController{
    
    func add(_ child: UIViewController, frame: CGRect? = nil) {
        addChild(child)
        
        if let frame = frame {
            child.view.frame = frame
        }
        
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    func remove() {
        willMove(toParent: nil)
        view.removeFromSuperview()
        removeFromParent()
    }
    
}

extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }
    
    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return self.jpegData(compressionQuality: jpegQuality.rawValue)
    }
    
    func ResizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / image.size.width
        let heightRatio = targetSize.height / image.size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y:0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
