//
//  LocationViewController.swift
//  PlumberJJ
//
//  Created by Casperon Technologies on 11/12/15.
//  Copyright © 2015 Casperon Technologies. All rights reserved.
//

import UIKit
import CoreLocation


class LocationViewController: RootBaseViewController {
    var jobStatus: String!
    var isShowArriveBtn:Bool!
    var addressStr:String = ""
    var phoneStr:String = ""
    var mapLaat:Double!
    var isPolyLineDrawn:Bool!
    var getUsername : String!
    var mapLong:Double!
    var jobId : String!
    var userId:String = ""
    let partnerMarker = GMSMarker()
    let userMarker = GMSMarker()
    var providerId = String()
    
    var getCurrentLocation : CLLocation = CLLocation()
    var model : MapRequestModel!
    @IBOutlet weak var lbldest: UILabel!
    @IBOutlet weak var lblstartfrom: UILabel!


    @IBOutlet weak var titleHeader: UILabel!
    @IBOutlet weak var lblStartLoc: UILabel!

    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet var distancelabl: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var mapView: GMSMapView!
    

    let URL_Handler:URLhandler=URLhandler()
    let marker1 = GMSMarker()
    var lastDriving = CLLocationDirection()
       var bearing = Double()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showProgress()
        titleHeader.text = Language_handler.VJLocalizedString("location", comment: nil)
        
   
        lbldest.text =  Language_handler.VJLocalizedString("destination", comment: nil)
        lblstartfrom.text =  Language_handler.VJLocalizedString("started_from", comment: nil)
        self.Updatedlocation_Call()
         NotificationCenter.default.removeObserver(self)
        
 NotificationCenter.default.addObserver(self, selector: #selector(LocationViewController.Updatedlocation_Call), name:NSNotification.Name(rawValue: kLocationNotification), object: nil)
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        providerId = objUserRecs.providerId as String
        // For use in foreground
    }
    
    @objc func Updatedlocation_Call()
    {
       // self.theme.AlertView("location", Message:"location update", ButtonTitle: kOk)
        let currLocation = CLLocation.init(latitude: Double(Currentlat)!, longitude: Double(Currentlng)!)
        if((isPolyLineDrawn) == nil){
            drawRoadRouteBetweenTwoPoints(currLocation.coordinate)
            
        }else{
            setAnimatedMapView(currLocation.coordinate)
        }
        
        getCurrentLocation =  currLocation
        
        let kilometer : Double = self.kilometersfromPlace(currLocation.coordinate)
        print ("get distance \(kmval)")
        
        var speed: Double = currLocation.speed
        speed =  (speed * 3600 )/100
        //converting speed from m/s to knots(unit)
        print("Speed \(speed)")
        distancelabl.text = "\(Double(kilometer))KM"
    }
   
    @IBAction func didclickgooglemap(_ sender: AnyObject) {
        
            let  startSelLocation :CLLocation = CLLocation.init(latitude:  getCurrentLocation.coordinate.latitude, longitude:  getCurrentLocation.coordinate.longitude)
            let dropSelLocation : CLLocation = CLLocation.init(latitude:trackingDetail.userLat, longitude: trackingDetail.userLong)
            if self.model == nil {
                self.model = MapRequestModel()
                // And let's set our callback URL right away!
                OpenInGoogleMapsController.sharedInstance().callbackURL = URL(string:kOpenGoogleMapScheme)
                OpenInGoogleMapsController.sharedInstance().fallbackStrategy = GoogleMapsFallback.chromeThenAppleMaps
            }
            
        if OpenInGoogleMapsController.sharedInstance().isGoogleMapsInstalled == false {
                print("Google Maps not installed, but using our fallback strategy")
            }
            if mapLaat != 0 {
                // [self.model useCurrentLocationForGroup:kLocationGroupStart];
                self.model.setQueryString(nil, center:startSelLocation.coordinate, for: LocationGroup.start)
                self.model.setQueryString(nil, center: dropSelLocation.coordinate, for: LocationGroup.end)
                self.openDirectionsInGoogleMaps()
            }
            else {
                self.view.makeToast(message: "There is no destination selected")
            }
            
        
    }
    
    func  openDirectionsInGoogleMaps()  {
        
        let directionsDefinition = GoogleDirectionsDefinition()
        if self.model.isStartCurrentLocation {
            directionsDefinition.startingPoint = nil
        }
        else {
            let startingPoint = GoogleDirectionsWaypoint()
            startingPoint.queryString = self.model.startQueryString
            startingPoint.location = self.model.startLocation
            directionsDefinition.startingPoint = startingPoint
        }
        if self.model.isDestinationCurrentLocation {
            directionsDefinition.destinationPoint = nil
        }
        else {
            let destination = GoogleDirectionsWaypoint()
            destination.queryString = self.model.destinationQueryString
            destination.location = self.model.desstinationLocation
            directionsDefinition.destinationPoint = destination
        }
        directionsDefinition.travelMode = self.travelMode(asGoogleMapsEnum: self.model.travelMode)
        OpenInGoogleMapsController.sharedInstance().openDirections(directionsDefinition)
    }
    
    func travelMode(asGoogleMapsEnum appTravelMode: TravelMode) -> GoogleMapsTravelMode {
        switch appTravelMode {
        case TravelMode.bicycling:
            return GoogleMapsTravelMode.biking
        case TravelMode.driving:
            return GoogleMapsTravelMode.driving
        case TravelMode.publicTransit:
            return GoogleMapsTravelMode.transit
        case TravelMode.walking:
            return GoogleMapsTravelMode.walking
        case TravelMode.notSpecified:
            return GoogleMapsTravelMode.init(rawValue: 0)!
        }
        
    }
    

    
    override func viewWillAppear(_ animated: Bool) {
        setDataToLocationView()
    }
    
  
    func set_mapView(_ loc:CLLocationCoordinate2D){
        
        let camera = GMSCameraPosition.camera(withLatitude: loc.latitude,
                                                          longitude:loc.longitude, zoom:15)
        print("Current location lattitude  =\(loc.latitude) Longtitude =\(loc.longitude) ")
        
        mapView.camera=camera
        mapView.frame=mapView.frame
        let marker = GMSMarker()
        marker.position = camera.target
        marker.appearAnimation = GMSMarkerAnimation.pop
        marker.icon = UIImage(named: "StartPin")
        
        
        
        partnerMarker.position = camera.target
        partnerMarker.appearAnimation = GMSMarkerAnimation.pop
        partnerMarker.icon = UIImage(named: "CarIcon")
        partnerMarker.title = getUsername as String
        partnerMarker.map = mapView
        marker.map = mapView
        
        marker1.position = CLLocationCoordinate2DMake(trackingDetail.userLat, trackingDetail.userLong)
        marker1.appearAnimation = GMSMarkerAnimation.pop
        marker1.icon = UIImage(named: "FinishPin")
        marker1.title = getUsername as String
        marker1.map = mapView
        mapView.settings.setAllGesturesEnabled(true)
        
        //Partner Location Moving
       
        
        //User Location Moving
        //        userMarker.position = CLLocationCoordinate2DMake(trackingDetail.userLat, trackingDetail.userLong)
        //        userMarker.appearAnimation = kGMSMarkerAnimationPop
        //        userMarker.icon = UIImage(named: "CarIcon")
        //        userMarker.title = getUsername as String
        //        userMarker.map = mapView
        //        mapView.settings.setAllGesturesEnabled(true)
        
    }
    
    func setAnimatedMapView(_ loc:CLLocationCoordinate2D){
        let camera = GMSCameraPosition.camera(withLatitude: loc.latitude,
                                                          longitude:loc.longitude, zoom:15)
        
        
        let user : CLLocation = CLLocation.init(latitude: trackingDetail.userLat, longitude: trackingDetail.userLong)
        let partner : CLLocation = CLLocation.init(latitude: loc.latitude, longitude: loc.longitude)
        bearing = self.theme.getBearingBetweenTwoPoints1(user,locationB: partner)
        CATransaction.begin()
        CATransaction.setAnimationDuration(2.0)
        partnerMarker.position = camera.target
        // userMarker.position = CLLocationCoordinate2DMake(trackingDetail.userLat, trackingDetail.userLong)
       // partnerMarker.rotation = lastDriving - bearing

        CATransaction.commit()
     
        
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
      func setDataToLocationView(){
        
        addressLbl.text="\(addressStr)"
        lblStartLoc.text = self.theme.CheckNullValue(theme.getAddressForLatLng( "\(Currentlat)", longitude: "\(Currentlng)", status :"") as AnyObject)

        if(isShowArriveBtn==true){
            cancelBtn.isHidden=false
            
            
            //stepProgress.currentIndex=1
        }else{
            
        }
    }
    
    @IBAction func didClickBackBtn(_ sender: AnyObject) {
        self.navigationController?.popViewControllerwithFade(animated: false)
       // self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func kilometersfromPlace(_ from: CLLocationCoordinate2D) -> Double {
        let userloc : CLLocation = CLLocation(latitude: from.latitude, longitude: from.longitude)
        let dest:CLLocation = CLLocation(latitude: trackingDetail.userLat, longitude: trackingDetail.userLong)
        let dist: CLLocationDistance = userloc.distance(from: dest)
        
        let distanceKM = dist / 1000
        let roundedTwoDigit = round(100 * distanceKM) / 100
        //        return roundedTwoDigit
        //        let distance: NSString = "\(dist)"
        return roundedTwoDigit
    }

    
    func drawRoadRouteBetweenTwoPoints(_ loc:CLLocationCoordinate2D) {
        lblStartLoc.text = self.theme.getAddressForLatLng("\(loc.latitude)", longitude: "\(loc.longitude)", status: "")
        print("Current location of lattitude\(loc.latitude) and longtitude \(loc.longitude)")
        let directionURL = "https://maps.googleapis.com/maps/api/directions/json?origin=\(loc.latitude),\(loc.longitude)&destination=\(trackingDetail.userLat),\(trackingDetail.userLong)&sensor=true&key=\(GoogleApiURLKey)"
        URL_Handler.makeGetCall(directionURL as NSString) { (responseObject) -> () in
            if(responseObject != nil)
            {
                let responseObject = responseObject!
                let routes_array = responseObject.object(forKey: "routes") as! NSArray
                
                if(routes_array.count > 0)
                {
                    self.DismissProgress()
                    self.isPolyLineDrawn=true
                    for Dict in routes_array
                    {
                        
                        let overviewPolyline = ((Dict as AnyObject).object(forKey: "overview_polyline")! as AnyObject).object(forKey: "points") as! String
                        let path:GMSPath=GMSPath(fromEncodedPath: overviewPolyline)!
                        let SingleLine:GMSPolyline=GMSPolyline(path: path)
                        SingleLine.strokeWidth=10.0
                        SingleLine.strokeColor=PlumberBlueColor
                        SingleLine.map=self.mapView
                        
                        let bounds: GMSCoordinateBounds = GMSCoordinateBounds(path: path)
                        let update: GMSCameraUpdate = GMSCameraUpdate.fit(bounds, withPadding: 100.0)
                        //bounds = [bounds includingCoordinate:PickUpmarker.position   coordinate:Dropmarker.position];
                        self.mapView.animate(with: update)
                        
                    }
                    
                    self.set_mapView(loc)
                }else{
                    
                }
                
            }else{
                self.DismissProgress()
                self.isPolyLineDrawn=true
                self.view.makeToast(message:Language_handler.VJLocalizedString("no_route", comment: nil), duration: 3, position: HRToastPositionDefault as AnyObject, title: Language_handler.VJLocalizedString("sorry", comment: nil))
            }
        }
    }
 
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didClickPhoneBtn(_ sender: AnyObject) {
        callNumber(phoneStr as String)
    }
    fileprivate func callNumber(_ phoneNumber:String) {
        if let phoneCallURL:URL = URL(string:"tel://"+"\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
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
