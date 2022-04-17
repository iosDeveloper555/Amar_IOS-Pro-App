//
//  ChooseLocationViewController.swift
//  Plumbal
//
//  Created by Casperon iOS on 24/11/2016.
//  Copyright © 2016 Casperon Tech. All rights reserved.
//

import UIKit
import GoogleMaps
protocol ChooseLocationViewControllerDelegate {
    
    func passaddressobj(_ addressArray :NSMutableArray,radius:Int)
    
}
class ChooseLocationViewController: RootBaseViewController,CLLocationManagerDelegate,GMSMapViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var sliderradius: UISlider!
    
    @IBOutlet weak var lblradius: UILabel!
    var lat : String = ""
    var long:String = ""
    var didselectCalled : Bool = Bool()
    struct Place {
        let id: String
        let description: String
    }
    @IBOutlet var viewMap1:GMSMapView!
    @IBOutlet var btnPin:UIButton!
    @IBOutlet var viewService:UIView!
    @IBOutlet var btnLocation:UIButton!
    @IBOutlet var txtLocation:UITextField!
    
    
      var delegate:ChooseLocationViewControllerDelegate?
    var locationManager = CLLocationManager()
    var sampleArray = NSMutableArray()
    @IBOutlet weak var lblPickLoc: UILabel!
    @IBOutlet weak var donebtn: UIButton!
    @IBOutlet weak var lblPickdrag: UILabel!
    
    
    var places = [Place]()
    var selectedAddress = String()
    var isFromRegister : Bool = false
    
    @IBOutlet weak var countryTable: UITableView!
    var searchArray = [String]()
    
    @IBOutlet var map_animation_view : CSAnimationView!
    var viewmapend = CGRect.zero
    @IBOutlet weak var markerView: CSAnimationView!
    var radius = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideView()
        didselectCalled = false
        markerView.isUserInteractionEnabled = false
        viewService.layer.cornerRadius = 12
        if isFromRegister == true {
            lblPickLoc.text = theme.setLang("workLoc")
        }else{
            lblPickLoc.text = theme.setLang("pick_location")
        }
        donebtn.titleLabel?.adjustsFontSizeToFitWidth = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
            self.lblPickdrag.text = self.theme.setLang("drag_pick")
            self.lblPickdrag.textColor = .white
        })
        donebtn.setTitle(theme.setLang("done"), for: UIControl.State())
        txtLocation.delegate = self
        txtLocation.addTarget(self, action: #selector(ChooseLocationViewController.TextfieldDidChange(_:)), for: UIControl.Event.editingChanged)
        txtLocation.textColor = UIColor.black
        
        countryTable.delegate = self
        countryTable.dataSource = self
        countryTable.register(UINib(nibName: "LocationSearchTCell", bundle: nil), forCellReuseIdentifier: "LocationSearchTCell")
        viewMap1.delegate = self
        self.definesPresentationContext = true
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
//        }
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        radius = Int(sliderradius.value)
        
        self.lblradius.text = "\(radius)"
        

    }
    //MARK: - radiusSliderAct
    
    
    @IBAction func radiusSlkiderAct(_ sender: UISlider)
    {
        
        radius = Int(sliderradius.value)

        self.lblradius.text = "\(radius)"
    }
    func updateViews(){
        viewmapend = viewMap1.frame
        
        let viewMapstart = CGRect(x: viewmapend.x, y: viewmapend.y, width: viewmapend.width, height: self.view.frame.height - viewmapend.y)
        
        viewMap1.frame = viewMapstart
        
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
            self.viewMap1.frame = self.viewmapend
        }) { (finished) in
            
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.theme.MakeAnimation(view: self.map_animation_view, animation_type: CSAnimationTypePop)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                self.markerView.isHidden = false
               self.theme.MakeAnimation(view: self.markerView, animation_type: CSAnimationTypeBounceDown)
            })
        })
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func hideView(){
        countryTable.isHidden = true
        
    }
    
    func showView(){
        countryTable.isHidden = false
        
    }
    func numberOfSections(in tableView: UITableView) -> Int {
          return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
         return places.count
    }
    
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LocationSearchTCell") as! LocationSearchTCell
        //cell.textLabel?.text = ""
        //cell.textLabel?.attributedText = NSAttributedString(string: "")
        
        //        switch countrySearchController.active {
        //        case true:
        let place = self.places[indexPath.row]
        cell.lblTitle.text = place.description ////.textLabel?.text
        return cell
        //        case false:
        //            return cell
        //        }
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        // check_Selection = "Select From List"
        hideView()
        tableView.deselectRow(at: indexPath, animated: true)
        let place = self.places[indexPath.row]
        txtLocation.text = place.description
        self.view.endEditing(true)
        txtLocation.resignFirstResponder()
        didselectCalled = true
        getLocation(place.id)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        showView()
        textField.text = ""
        
    }
    
    @objc func TextfieldDidChange(_ textField:UITextField)
    {
        if(textField == txtLocation)
        {
            if(txtLocation.text != "")
            {
                showView()
                searchArray.removeAll(keepingCapacity: false)
                self.getPlaces(textField.text!)
                countryTable.reloadData()
            }
            else
            {
                //countryTable.isHidden = true
                hideView()
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    func set_mapView(_ lat:String,long:String){
        let UpdateLoc = CLLocationCoordinate2DMake(CLLocationDegrees(lat as String)!,CLLocationDegrees(long as String)!)
        let camera = GMSCameraPosition.camera(withTarget: UpdateLoc, zoom:15.0)
        viewMap1.animate(to: camera)
        viewMap1.isMyLocationEnabled = true
        viewMap1.mapType = .normal
        
        
        
        
        
        viewMap1.settings.setAllGesturesEnabled(true)
        viewMap1.settings.scrollGestures=true
    }
    
    func getAddressForLatLng(_ latitude: String, longitude: String) {
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
    }
    func delay(_ seconds: Double, completion:@escaping ()->()) {
        let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * seconds )) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: popTime) {
            completion()
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
    
    func requestForSearch(_ searchString: String) -> URLRequest {
        //            "components":"country:sg"

        let params = [
            "input": searchString,
            "key": "\(GoogleApiURLKey)",
            "location":"\(lat),\(long)",
            "radius":"1000000"
            
        ]
        
        print("the url is https://maps.googleapis.com/maps/api/place/autocomplete/json?\(query(params as [String : AnyObject]))")
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
                    self.countryTable.reloadData()
                }
            })
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
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
                
                print(json)
                if let predictions = json["result"] as? NSDictionary {
                    
                    print(predictions)
                    self.sampleArray = NSMutableArray()
                    self.sampleArray.add(predictions.value(forKeyPath: "geometry.location.lat")!)
                    self.sampleArray.add(predictions.value(forKeyPath: "geometry.location.lng")!)
                    self.sampleArray.add(self.txtLocation.text!)
                    self.set_mapView("\(self.sampleArray.object(at: 0))" as String, long: "\(self.sampleArray.object(at: 1))" as String)
              
                }
            })
        }
        catch let error as NSError {
            // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
            print("A JSON parsing error occurred, here are the details:\n \(error)")
        }
    }
    
    @IBAction func didClickOptions(_ sender: UIButton) {
        if sampleArray.count != 0{
            DataManager.userRadius="\(self.radius)"
            self.delegate?.passaddressobj(sampleArray, radius: self.radius)
        }
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
    @IBAction func didPickLocation(_ sender: AnyObject) {
        locationManager.startUpdatingLocation()
    }
    
    @IBAction func didClickBack(_ sender: AnyObject) {
        self.navigationController?.popViewControllerwithFade(animated: false)
        
    }
    //MARK: - Loction selected done
    
    @IBAction func didClickDone(_ sender: AnyObject) {
        if sampleArray.count != 0{
            DataManager.userRadius="\(self.radius)"
            self.delegate?.passaddressobj(sampleArray, radius: self.radius)

            self.navigationController?.popViewControllerwithFade(animated: false)
        }
        
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
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        getAddressForLatLng("\(mapView.camera.target.latitude)", longitude: "\(mapView.camera.target.longitude)")
    }
    
}
