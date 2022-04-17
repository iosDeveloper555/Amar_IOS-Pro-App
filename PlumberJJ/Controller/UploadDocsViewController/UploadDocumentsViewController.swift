//
//  UploadDocumentsViewController.swift
//  PlumberJJ
//
//  Created by Gokul's Mac Mini on 28/11/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit
//import WDImagePicker
import Photos
import MobileCoreServices
import Alamofire
import SDWebImage

//MARK: UploadDocDelgate
protocol UploadDocDelgate {
func UploadDocFuctionDelegate(_ uploadDocArray: [Any])
}


class documentList: NSObject {
    var name = String()
    var image = String()
    var fileType = String()
    var expdate = String()
    var expdateTimeStamp = String()

    var _id = String()
    var status = String()
}

class UploadDocumentsViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WDImagePickerDelegate,UIDocumentPickerDelegate, UIDocumentMenuDelegate {
    
    //MARK:- Outlet's
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var BottomView: UIView!
    @IBOutlet weak var UploadDocTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var TableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet var OutsiderView: [CSAnimationView]!

    @IBOutlet var DatePickerView: DatePickerView!
    
    
    
    //    MARK:- Variable's
    let theme = Theme()
    var TableViewArray = [documentList]()
    let imgpicker = UIImagePickerController()
    var imagedata : Data = Data()
    var imagePicker = WDImagePicker()

    var UserImage = UIImageView()
    var SelectedIndex = Int()
    let url_handler = URLhandler()
    var isDisplay = false
    var expiryDate = String()
    var indexPath1 = Int()
    var subCatId = "5d3069abf7fdfb13e0045679"
    var delgate:UploadDocDelgate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let TableViewCell = UINib.init(nibName: "UploadDocCell", bundle: nil)
        self.UploadDocTableView.register(TableViewCell, forCellReuseIdentifier: "UploadDocCell")
        
        self.submitButton.setTitle(self.theme.setLang("continue"), for: .normal)
        self.submitButton.backgroundColor = PlumberThemeColor
        self.submitButton.setTitleColor(.white, for: .normal)
        self.submitButton.layer.cornerRadius = self.submitButton.frame.height/2
        
        imagePicker.delegate=self
        imgpicker.delegate = self
        self.SetDatePicker()
        //self.getDocumentsList()
        
        self.theme.DismissProgress()

    }
    func SetDatePicker(){
        let calendar = Calendar(identifier: .gregorian)
        
        let currentDate = Date()
        var components = DateComponents()
        components.calendar = calendar
        
        components.year = -19
        components.month = 12
        let maxDate = calendar.date(byAdding: components, to: currentDate)!
        
        components.year = -150
        let minDate = calendar.date(byAdding: components, to: currentDate)!
        
        DatePicker.minimumDate = minDate
        DatePicker.maximumDate = maxDate
    }
    @IBAction func didclcikDoeBtn(_ sender: UIButton) {
        
//        let readMore: UIButton? = (sender)
//        let buttonPosition = readMore?.convert(CGPoint.zero, to: UploadDocTableView)
//        var indexPath: IndexPath? = nil
//        indexPath = UploadDocTableView.indexPathForRow(at: buttonPosition!)
        let indexNew = IndexPath(row: indexPath1, section:  0)
        let cell: UploadDocCell = self.UploadDocTableView.cellForRow(at: indexNew) as! UploadDocCell

        DatePicker.datePickerMode = UIDatePicker.Mode.date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let selectedDate = dateFormatter.string(from: DatePicker.date)
        print("selectedDate",selectedDate)
        self.expiryDate = selectedDate
        cell.txtExpiryDate.text = selectedDate
        self.theme.MakeAnimation(view: self.DatePickerView , animation_type: CSAnimationTypeSlideDown)
        self.DatePickerView.removeFromSuperview()
        self.view.removeBlurEffect()
    }
    @IBAction func btnExpiryDate(_ sender : UIButton)
    {
        let readMore: UIButton? = (sender)
        let buttonPosition = readMore?.convert(CGPoint.zero, to: UploadDocTableView)
        var indexPath: IndexPath? = nil
        indexPath = UploadDocTableView.indexPathForRow(at: buttonPosition!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        if indexPath != nil
        {
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            
            let datePickerCommanVC = storyboard.instantiateViewController(withIdentifier:"DatePickerPopupVC") as! DatePickerPopupVC
            datePickerCommanVC.modalPresentationStyle = .overCurrentContext
            datePickerCommanVC.modalTransitionStyle = .crossDissolve
          
           
            datePickerCommanVC.onDoneBlock = { result in
               // self.txtDate.text = dateFormatter.string(from: result)
                let documentsData = self.TableViewArray[indexPath?.row ?? 0]
                documentsData.expdate = dateFormatter.string(from: result)
                documentsData.expdateTimeStamp = "\(result.currentTimeMillis())"//dateFormatter.string(from: result)

                self.UploadDocTableView.reloadData()
            }
            self.present(datePickerCommanVC, animated: false, completion: nil)
        }
        
        
//        indexPath1 = indexPath?.row ?? 0
//
//        self.view.AddBlurEffect()
//        self.theme.MakeAnimation(view: self.DatePickerView, animation_type: CSAnimationTypeSlideUp)
//        self.view.addSubview(DatePickerView)
//        DatePickerView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint(item: DatePickerView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: DatePickerView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
//        NSLayoutConstraint(item: DatePickerView!, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute:.bottom, multiplier: 1, constant: 0).isActive = true
    }
    //MARK: - Picker Camera Actions
    @objc func openCamera(sender : UIButton)
    {
        self.SelectedIndex = sender.tag
        
        let documentsData = self.TableViewArray[self.SelectedIndex]
        if documentsData.expdate == ""
        {
            self.theme.AlertView(ProductAppName, Message: self.theme.setLang("Please Select Expiry Date First"), ButtonTitle: kOk)
        }
        else
        {
            print("SelectedIndex is \(self.SelectedIndex)")
            let ImagePicker_Sheet = UIAlertController(title: nil, message: self.theme.setLang("select_image")
                , preferredStyle: .actionSheet)
            let Camera_Picker = UIAlertAction(title: self.theme.setLang("camera")
                , style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
    //                self.checkCamera()
                    self.openCamera()
            })
            
            let Gallery_Picker = UIAlertAction(title: self.theme.setLang("gallery")
                , style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
    //                self.checkGallery()
                    self.openPhotoLibrary()
            })
            /*
            let Document_Picker = UIAlertAction(title: self.theme.setLang("document")
                , style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    self.checkDocument()
            })
            */
            let cancelAction = UIAlertAction(title: self.theme.setLang("cancel"), style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                
            })
            ImagePicker_Sheet.addAction(Camera_Picker)
            ImagePicker_Sheet.addAction(Gallery_Picker)
            //ImagePicker_Sheet.addAction(Document_Picker)
            ImagePicker_Sheet.addAction(cancelAction)
            
            self.present(ImagePicker_Sheet, animated: true, completion: nil)
        }
        
        
    }
    func MoveToApp(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setInitialViewcontroller()
        let socStr:NSString = ""//dict.objectForKey("soc_key") as! NSString
        if(socStr.length>0){
            self.theme.saveJaberPassword(socStr as String)
        }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01 , execute: {
//        self.submitButton.returnToOriginalState()
        self.submitButton.isUserInteractionEnabled = true
        })
}
    func checkDocument() {
        let types = [kUTTypePDF, kUTTypeText, kUTTypeRTF, kUTTypeSpreadsheet]
        let importMenu = UIDocumentMenuViewController(documentTypes: types as [String], in: .import)
        importMenu.delegate = self
        importMenu.modalPresentationStyle = .formSheet
        self.present(importMenu, animated: true, completion: nil)
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
        default: alertToEncourageCameraAccessInitially()
        }
    }
    func openPhotoLibrary(){
        DispatchQueue.main.async {
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true) {
            }
        }
    }
    func openCamera()
    {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.sourceType = .camera
                imagePicker.delegate = self
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true) {
                }
            }
            else
            {
                print("No camera available")
            }
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
    func Camera_Pick() {
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
            DispatchQueue.main.async {
                self.imgpicker.sourceType = .camera
                self.imgpicker.allowsEditing = true
                self.present(self.imgpicker, animated: true, completion: nil)
            }
        } else {
            let alert  = UIAlertController(title: "Warning", message: "Sorry, this device has no camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func checkGallery() {
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            self.Gallery_Pick()
        }
        else if (status == PHAuthorizationStatus.denied) {
            // Access has been denied.
            self.alertToEncourageGalleryAccessInitially()
        } else if (status == PHAuthorizationStatus.notDetermined) {
            // Access has not been determined.
            PHPhotoLibrary.requestAuthorization({ (newStatus) in
                if (newStatus == PHAuthorizationStatus.authorized) {
                    self.Gallery_Pick()
                } else { }
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
    func Gallery_Pick() {
        self.imagePicker = WDImagePicker()
//        self.imagePicker.sourceType = .photoLibrary
        self.imagePicker.cropSize = CGSize(width: 280, height: 280)
        self.imagePicker.delegate = self
        self.imagePicker.resizableCropArea = true
        self.present(self.imagePicker.imagePickerController, animated: true, completion: nil)
    }
    
    //UIImagePicker Delegate Functions
    func imagePickerDidCancel(imagePicker: WDImagePicker) {
        self.imagePicker.imagePickerController.dismiss(animated: true, completion: nil)
    }
    func imagePicker(imagePicker: WDImagePicker, pickedImage: UIImage) {
        _ = pickedImage
        let pickimage = self.theme.rotateImage(pickedImage)
        let  image = UIImage.init(cgImage: pickimage.cgImage!)
        imagedata = pickimage.jpegData(compressionQuality: 0.1)!;
        self.UserImage.image = image
        print("The Picked image is ------>!\(image)")
        self.hideImagePicker()
        self.UploadImages()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        UserImage.image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        let pickimage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        var pickedimage = self.theme.rotateImage(pickimage!)
        pickedimage = pickedimage.ResizeImage(image: pickedimage, targetSize: CGSize(width: 500, height: 500))
        imagedata = pickedimage.jpegData(compressionQuality: 0.1)!;
        print("The Picked imagedata is ------>!\(pickedimage)")
        self.UploadImages()
        dismiss(animated:true, completion: nil) //5
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func hideImagePicker() {
        self.imagePicker.imagePickerController.dismiss(animated: true, completion: nil)
    }
    //UIDocumentPickerDelegate Functions
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let myURL = urls.first else {
            return
        }
        print(myURL)
        self.imagedata = try! Data.init(contentsOf: myURL)
        do {
            let resources = try myURL.resourceValues(forKeys:[.fileSizeKey])
            let fileSize = resources.fileSize!
            print ("fileSize is ==> \(fileSize)")
            if fileSize <= 100000 {
                self.uploadDocuments()
            } else {
                self.theme.AlertView(ProductAppName, Message: self.theme.setLang("Allowed File Size Should Be Lesser Than 1 MB."), ButtonTitle: kOk)
            }
        } catch {
            print("Error: \(error)")
        }
    }
    public func documentMenu(_ documentMenu:UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }
    //Convert PDF Document into Image
    func thumbnailFromPdf(withUrl url:URL, pageNumber:Int, width: CGFloat = 240) -> UIImage? {
        guard let pdf = CGPDFDocument(url as CFURL),
            let page = pdf.page(at: pageNumber)
            else {
                return nil
        }
        var pageRect = page.getBoxRect(.mediaBox)
        let pdfScale = width / pageRect.size.width
        pageRect.size = CGSize(width: pageRect.size.width*pdfScale, height: pageRect.size.height*pdfScale)
        pageRect.origin = .zero
        
        UIGraphicsBeginImageContext(pageRect.size)
        let context = UIGraphicsGetCurrentContext()!
        
        // White BG
        context.setFillColor(UIColor.white.cgColor)
        context.fill(pageRect)
        context.saveGState()
        
        // Next 3 lines makes the rotations so that the page look in the right direction
        context.translateBy(x: 0.0, y: pageRect.size.height)
        context.scaleBy(x: 1.0, y: -1.0)
        context.concatenate(page.getDrawingTransform(.mediaBox, rect: pageRect, rotate: 0, preserveAspectRatio: true))
        
        context.drawPDFPage(page)
        context.restoreGState()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        print("Image is \(String(describing: image))")
        //        if isDisplay == true {
        //        let indexPath = IndexPath(row: self.SelectedIndex, section: 0)
        //        let cell = UploadDocTableView.cellForRow(at: indexPath) as? UploadDocCell
        //        cell?.uploadDocImg.image = image
        //        }
        
        UIGraphicsEndImageContext()
        return image
    }
    //UPLoadDocument API Function
    func uploadDocuments() {
        self.theme.showProgress(View: self.view)
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let URL = try! URLRequest(url: uploadDocument, method: .post, headers: ["apptype": "ios", "apptoken":"\(theme.GetDeviceToken())", "providerid":"\(objUserRecs.providerId)"])
        
       
        let documentsData = self.TableViewArray[self.SelectedIndex]
        
        let FullDate = documentsData.expdate.split(separator: "-")
        print(FullDate)
        let Month = FullDate[0]
        let Date = FullDate[1]
        let year = FullDate[2]
        
        let param = ["expiry_date[year]":year,"expiry_date[month]":Month,"expiry_date[date]":Date] as [String : Any]
       
        
    
        print(["apptype": "ios", "apptoken":"\(theme.GetDeviceToken())", "providerid":"\(objUserRecs.providerId)"])
        print(param)
        print(URL)
        
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(self.imagedata, withName: "proof_doc", fileName: "file.pdf", mimeType: "application/pdf")
            for (key, value) in param {
                
                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
            }
            
            
        }, with: URL, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let js = response.result.value {
                        self.theme.DismissProgress()
                        let JSON = js as! NSDictionary
                        print("JSON: \(JSON)")
                        let Status = self.theme.CheckNullValue(JSON.object(forKey: "status"))
                        if (Status == "1") {
                            let documentsData = JSON.object(forKey: "documents") as! NSArray
                            print("documentsData is  \(documentsData)")
                            for document in documentsData {
                                self.TableViewArray[self.SelectedIndex].image = self.theme.CheckNullValue((document as AnyObject).object(forKey: "path"))
                                self.TableViewArray[self.SelectedIndex].fileType = self.theme.CheckNullValue((document as AnyObject).object(forKey: "file_type"))
                            }
                            dump(self.TableViewArray)
                            self.isDisplay = true
                            self.UploadDocTableView.reloadData()
                        } else { }
                    } else {
                        self.theme.AlertView(ProductAppName, Message: self.theme.setLang("try_Again"), ButtonTitle: kOk)
                        self.theme.DismissProgress()
                    }
                }
            case .failure(let encodingError):
                print(" the encodeing error is \(encodingError)")
            }
        })
    }
    //MARK: - UPloadImage API Function
    
    func UploadImages() {
        
      //  let documentsData = self.TableViewArray[self.SelectedIndex]
        
//        let FullDate = documentsData.expdate.split(separator: "-")
//        print(FullDate)
//        let Month = FullDate[0]
//        let Date = FullDate[1]
//        let year = FullDate[2]
//
//        let param = ["expiry_date[year]":year,"expiry_date[month]":Month,"expiry_date[date]":Date] as [String : Any]
        
        
        self.theme.showProgress(View: self.view)
        //let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let URL = try! URLRequest(url: UploadDocReqById, method: .post, headers: nil)
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(self.imagedata, withName: "file", fileName: "file.jpeg", mimeType: "image/jpg")
//            for (key, value) in param {
//
//                multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key )
//            }
            
            
        }, with: URL, encodingCompletion: { encodingResult in
            switch encodingResult {
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    if let js = response.result.value {
                        self.theme.DismissProgress()
                        let JSON = js as! NSDictionary
                        print("JSON: \(JSON)")
                        let Status = self.theme.CheckNullValue(JSON.object(forKey: "status"))
                        if (Status == "success") {
                           // let documentsData = JSON.object(forKey: "documents") as! NSArray
                            //print("documentsData is  \(documentsData)")
                            //for document in documentsData {
                                self.TableViewArray[self.SelectedIndex].image = self.theme.CheckNullValue((JSON as AnyObject).object(forKey: "file"))
                                self.TableViewArray[self.SelectedIndex].fileType = self.theme.CheckNullValue((JSON as AnyObject).object(forKey: "filetype"))
                            //}
                            dump(self.TableViewArray)
                            self.isDisplay = true
                            self.UploadDocTableView.reloadData()
                        } else { }
                    } else {
                        self.theme.AlertView(ProductAppName, Message: self.theme.setLang("try_Again"), ButtonTitle: kOk)
                        self.theme.DismissProgress()
                    }
                }
            case .failure(let encodingError):
                print(" the encodeing error is \(encodingError)")
            }
        })
    }
    
    //MARK: - GetDocumentsList API
    func getDocumentsList() {
        self.theme.showProgress(View: self.view)

        
        let Parameter : NSDictionary = ["id":self.subCatId]
        url_handler.makeNewApiCall(GetDocReqById , param: Parameter as NSDictionary) {
            (responseObject, error) -> () in
            if(error != nil)
            {
                self.view.makeToast(message:error?.localizedDescription ??  "", duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                self.theme.DismissProgress()

            }
            else
            {
                self.theme.DismissProgress()
               debugPrint("responseObject = \(responseObject)")
                if (responseObject != nil) {
                    self.theme.DismissProgress()
                    let responseObject = responseObject!
                    print("DocumentsList is  \(responseObject)")
                    let documentsData = responseObject.object(forKey: "documentlist") as! NSArray
                    print("DocumentsArray is  \(documentsData)")
                    for documentDetails in documentsData {
                        
                        let status = self.theme.CheckNullValue((documentDetails as AnyObject).object(forKey: "status"))
                        if status == "1"
                        {
                        let documents = documentList()
                        documents.name = self.theme.CheckNullValue((documentDetails as AnyObject).object(forKey: "name"))
                        //self.theme.CheckNullValue((documentDetails as AnyObject).object(forKey: "status"))
                        documents._id = self.theme.CheckNullValue((documentDetails as AnyObject).object(forKey: "_id"))
                        documents.status = status
                        documents.image = ""
                        documents.fileType = ""
                        documents.expdate = ""
                        self.TableViewArray.append(documents)
                        }
                    }
                    self.UploadDocTableView.reloadData()
                }
                else {
                    self.theme.DismissProgress()
                    self.view.makeToast(message:Language_handler.VJLocalizedString("no_document", comment: nil), duration: 3, position: HRToastPositionDefault as AnyObject, title: Language_handler.VJLocalizedString("sorry", comment: nil))
                }
            }}
        
        
        /*
        
      //  debugPrint("getDocumentsList \(GetDocumentsList)")
        url_handler.makeGetCall(GetDocumentsList as NSString) { (responseObject) in
            if (responseObject != nil) {
                self.theme.DismissProgress()
                let responseObject = responseObject!
                print("DocumentsList is  \(responseObject)")
                let documentsData = responseObject.object(forKey: "documents") as! NSArray
                print("DocumentsArray is  \(documentsData)")
                for documentDetails in documentsData {
                    let documents = documentList()
                    documents.name = self.theme.CheckNullValue((documentDetails as AnyObject).object(forKey: "name"))
                    documents.image = ""
                    documents.fileType = ""
                    documents.expdate = ""
                    self.TableViewArray.append(documents)
                }
                self.UploadDocTableView.reloadData()
            } else {
                self.theme.DismissProgress()
                self.view.makeToast(message:Language_handler.VJLocalizedString("no_document", comment: nil), duration: 3, position: HRToastPositionDefault as AnyObject, title: Language_handler.VJLocalizedString("sorry", comment: nil))
            }
        }
        */
    }
    
    //-------------------------------------
    //#MARK : UIButton Actions
    //---------------------------------------------
    @IBAction func didclickbackBtn(_ sender: Any) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    //MARK: - Upload doc
    
    @IBAction func didclickSubmitBtn(_ sender: Any) {
        
        self.theme.showProgress(View: self.view)

        print("TableViewArray Count is \(self.TableViewArray.count)")
        let validationArray = self.TableViewArray.filter{($0.image != "")}
        print("validationArray Count is \(validationArray.count)")
        if validationArray.count == self.TableViewArray.count{
            var FinalDocumentArray = [Any]()
            var fileType = String()
            var Object = NSDictionary()

            for data in TableViewArray {
                fileType = data.fileType
                let FullDate = data.expdateTimeStamp//.split(separator: "-")

                Object = ["name":data.name,
                          "file_type":data.fileType,
                          "path":data.image,
                          "expiry_date":FullDate,
                          ]
                FinalDocumentArray.append(Object)
            }
           // Registerrec["documents"] = FinalDocumentArray
            
            print("The FinalDocumentArray is as Follows\(Registerrec)")
            self.delgate?.UploadDocFuctionDelegate(FinalDocumentArray)

            self.navigationController?.popViewController(animated: true)
/*
            url_handler.makeNewApiCall(UploadMyAllDocReqById , param: Registerrec as NSDictionary) {
                (responseObject, error) -> () in
                if(error != nil)
                {
                    print("error in upload \(error)")

                    self.view.makeToast(message:error?.localizedDescription ??  "", duration: 3, position: HRToastPositionTop as AnyObject, title: appNameJJ)
                    self.theme.DismissProgress()

                }
                else
                {
                    print("response in upload \(responseObject)")

                    self.theme.DismissProgress()
                    self.MoveToApp()
                }
            }
            
           */
            
            
            
            
            //        if fileType == "" {
            //            self.theme.AlertView(ProductAppName, Message: Language_handler.VJLocalizedString("please_upload_your_documents", comment: nil), ButtonTitle: kOk)
            //        } else {
            //            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFourthPageViewController") as?  RegFourthPageViewController {
            //                if let navigator = self.navigationController {
            //                    let backItem = UIBarButtonItem()
            //                    backItem.title = ""
            //                    self.navigationItem.backBarButtonItem = backItem
            //                    navigator.pushViewController(withFade: viewController, animated: false)
            //                }
            //            }
            //        }
            //* Move To New Customization ViewController
            
//            if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RegFourthPageViewController") as?  RegFourthPageViewController{
//                if let navigator = self.navigationController
//                {
//                    let backItem = UIBarButtonItem()
//                    backItem.title = ""
//                    self.navigationItem.backBarButtonItem = backItem
//                    navigator.pushViewController(withFade: viewController, animated: false)
//                }
//            }
            //self.MoveToApp()
        }else{
            self.theme.AlertView(ProductAppName, Message: self.theme.setLang("Please_update_your_documents"), ButtonTitle: kOk)
        }
       
    }
    
    
    func okAlert(msg: String){
        self.theme.AlertView(ProductAppName, Message: self.theme.setLang(msg), ButtonTitle: kOk)
    }
}

extension UploadDocumentsViewController : UITableViewDelegate , UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TableViewArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.TableViewHeight.constant = CGFloat(TableViewArray.count * 250)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UploadDocCell") as! UploadDocCell
        cell.selectionStyle = .none
        let documentsData = self.TableViewArray[indexPath.row]
        cell.DocumentTitle.text = documentsData.name
        cell.txtExpiryDate.text = documentsData.expdate
        cell.uploadPictureLbl.text = "Upload Your \(documentsData.name)"
        let url: URL! = URL(string: "\(MainUrl)/\(documentsData.image)")
        let theFileName = url?.pathExtension
        print("theFileName is \(String(describing: theFileName))")
        cell.UploadImgBtn.tag = indexPath.row
        cell.btnSelectDate.tag = indexPath.row
        
        if documentsData.image != "" {
            cell.uploadPictureLbl.isHidden = true
            if theFileName == "pdf" {
                //                thumbnailFromPdf(withUrl: URL(string:"\(MainUrl)/\(documentsData.image)")!, pageNumber: 1)
                cell.uploadDocImg.sd_setImage(with: URL(string:"\(MainUrl)\(documentsData.image)"), placeholderImage: UIImage(named: "PdfTemplate"))
            } else {
                cell.uploadDocImg.sd_setImage(with: URL(string:"\(MainUrl)\(documentsData.image)"), placeholderImage: UIImage(named: "uploadDocPlaceHolder"))
            }
        } else {
            cell.uploadPictureLbl.isHidden = false
            cell.uploadDocImg.sd_setImage(with: URL(string:""), placeholderImage: UIImage(named: "uploadDocPlaceHolder"))
        }
        cell.UploadImgBtn.addTarget(self, action: #selector(openCamera(sender :)), for: .touchUpInside)
        cell.btnSelectDate.addTarget(self, action: #selector(btnExpiryDate(_:)), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
}
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
