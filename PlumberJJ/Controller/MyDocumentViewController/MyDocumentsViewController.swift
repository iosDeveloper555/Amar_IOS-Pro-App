//
//  MyDocumentsViewController.swift
//  PlumberJJ
//
//  Created by Gokul's Mac Mini on 28/11/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit
import SDWebImage
//import WDImagePicker
import Photos
import MobileCoreServices
import Alamofire
import WebKit

class DocumentsList: NSObject {
    var name = String()
    var file_type = String()
    var path = String()
    var expireyDate = String()
    var expdateTimeStamp = String()
    var _id = String()
    var status = String()
    
}

class MyDocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate,WDImagePickerDelegate,UIDocumentPickerDelegate, UIDocumentMenuDelegate {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var documentsTable: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var webViewImage: WKWebView!
    @IBOutlet weak var HeaderLbl: UILabel!
    
    //OnclickView
    @IBOutlet weak var transparentView: UIView!
    @IBOutlet weak var imgBackView: UIView!
    @IBOutlet weak var fullImage: UIImageView!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var TableViewHeight: NSLayoutConstraint!
    
    var documentsArray = [DocumentsList]()
    var theme:Theme=Theme()
    var url_handler : URLhandler = URLhandler()
    var siteUrl = String()
    let imgpicker = UIImagePickerController()
    var imagedata : Data = Data()
    var imagePicker = WDImagePicker()
    var UserImage = UIImageView()
    var SelectedIndex = Int()
    var defaultString = String()
    var isUpdated = false
    var currentimageIndex = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        documentsTable.register(UINib(nibName: "DocumentsListCell", bundle: nil), forCellReuseIdentifier: "DocumentsListCell")
        self.updateBtn.setTitle(theme.setLang("update"), for: .normal)
        self.updateBtn.backgroundColor = PlumberThemeColor
        self.updateBtn.setTitleColor(.white, for: .normal)
        self.updateBtn.layer.cornerRadius = self.updateBtn.frame.height/2
        imagePicker.delegate=self
        imgpicker.delegate = self
        self.transparentView.isHidden = true
        self.imgBackView.isHidden = true
        self.titleLabel.text = Language_handler.VJLocalizedString("documents", comment: nil)
        self.getProviderDocuments()
    }
    
    override func viewWillLayoutSubviews() {
        self.TableViewHeight.constant = self.documentsTable.tableViewHeight
    }
    
    //UITableView Delegate & DataSource Functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.documentsArray.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.TableViewHeight.constant = self.documentsTable.tableViewHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentsListCell") as! DocumentsListCell
        cell.selectionStyle = .none
        let documentsListArray : DocumentsList =  documentsArray[indexPath.row]
        cell.titleLabel.text = documentsListArray.name
        
        let url = URL(string: MainUrl + documentsListArray.path)
        let theFileName = url?.pathExtension
        if self.isUpdated == false {
            if theFileName == "pdf" {
                cell.documentImg.sd_setImage(with: url, placeholderImage: UIImage(named: "PdfTemplate"))
            } else {
               cell.documentImg.sd_setImage(with: url, placeholderImage: UIImage(named: "pdf"))
            }
            
        }
        cell.editBtn.setImage(UIImage(named: "DocEdit"), for: .normal)
        cell.editBtn.tag = indexPath.row
        cell.editBtn.addTarget(self, action: #selector(editBtnAction(sender :)), for: .touchUpInside)
        if let exp = documentsListArray.expireyDate as? String
        {
            cell.lblDate.text = Double(exp ?? "0.0")!.getDateStringFromUTC()

        }
        cell.btnEditDate.tag = indexPath.row
        cell.btnEditDate.addTarget(self, action: #selector(DateeditBtnAction(sender :)), for: .touchUpInside)
        
        cell.btnUpdate.tag = indexPath.row

        cell.btnUpdate.addTarget(self, action: #selector(btnUpdate), for: .touchUpInside)

        let status = documentsListArray.status
        if status == "2"
        {
            cell.btnEditDate.isHidden=false
            cell.editBtn.isHidden=false
            cell.btnUpdate.isHidden=false
            cell.constUpdateBtn.constant = 78
        }
        else
        {
            cell.btnEditDate.isHidden=true
            cell.editBtn.isHidden=true
            cell.btnUpdate.isHidden=true
            cell.constUpdateBtn.constant = 8

        }
       // cell.lblDate.text =
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //UIButton Actions
    @IBAction func didClickMenu(_ sender: AnyObject) {
//        self.view.endEditing(true)
//        self.frostedViewController.view.endEditing(true)
//        // Present the view controller
//        self.frostedViewController.presentMenuViewController()
        self.findHamburguerViewController()?.showMenuViewController()
    }
    @IBAction func didClickUpdate(_ sender: AnyObject) {
//        if self.isUpdated == true {
//            self.UpdateDocuments()
//        } else {
//            self.theme.AlertView(Language_handler.VJLocalizedString("app_name", comment: nil), Message:Language_handler.VJLocalizedString("Please_update_your_documents", comment: nil), ButtonTitle: kOk)
//        }
    }
    
    //MARK: - Update button click
    @objc func btnUpdate(_ sender:UIButton)
    {
        if self.documentsArray.count>sender.tag
        {
        if self.documentsArray[sender.tag].path.count>0
        {
            self.UpdateDocuments(index: sender.tag)
        }
        else
        {
            self.theme.AlertView(Language_handler.VJLocalizedString("app_name", comment: nil), Message:Language_handler.VJLocalizedString("Please_update_your_documents", comment: nil), ButtonTitle: kOk)
        }
        }else {
            self.theme.AlertView(Language_handler.VJLocalizedString("app_name", comment: nil), Message:Language_handler.VJLocalizedString("Please_update_your_documents", comment: nil), ButtonTitle: kOk)
        }
    }
    
    @IBAction func didClickCancel(_ sender: AnyObject) {
        self.transparentView.isHidden = true
        self.imgBackView.isHidden = true
    }
    func StringToDate(strFormate:String,strDate:String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = strFormate
        let date = dateFormatter.date(from: strDate)
        return date ?? Date()
    }
    
    //MARK: -  Edit date
    
    @objc func DateeditBtnAction(sender : UIButton) {
        self.SelectedIndex = sender.tag
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let documentsListArray : DocumentsList =  documentsArray[self.SelectedIndex]
        
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        
        let datePickerCommanVC = storyboard.instantiateViewController(withIdentifier:"DatePickerPopupVC") as! DatePickerPopupVC
        datePickerCommanVC.modalPresentationStyle = .overCurrentContext
        datePickerCommanVC.modalTransitionStyle = .crossDissolve
//        if documentsListArray.expireyDate != ""
//        {
//            datePickerCommanVC.selectedDate = StringToDate(strFormate: "MM-dd-yyyy", strDate: documentsListArray.expireyDate)
//        }
        
        datePickerCommanVC.onDoneBlock = { result in
           
            documentsListArray.expireyDate = dateFormatter.string(from: result)
            documentsListArray.expireyDate = "\(result.currentTimeMillis())"
            self.documentsTable.reloadData()
           // self.UploadImagesExpiryDate()
        }
        self.present(datePickerCommanVC, animated: false, completion: nil)
    }
    
    //MARK: -  Edit image
    
    @objc func editBtnAction(sender : UIButton) {
        self.SelectedIndex = sender.tag
        print("SelectedIndex is \(self.SelectedIndex)")
        let documentsListArray : DocumentsList =  documentsArray[self.SelectedIndex]
        
        if documentsListArray.expireyDate != ""
        {
            let ImagePicker_Sheet = UIAlertController(title: nil, message: self.theme.setLang("select_image")
                , preferredStyle: .actionSheet)
            let Camera_Picker = UIAlertAction(title: self.theme.setLang("view")
                , style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    self.transparentView.isHidden = false
                    self.imgBackView.isHidden = false
                    let indexPath = IndexPath(row: self.SelectedIndex, section: 0)
                    let documentsImagesArray : DocumentsList =  self.documentsArray[indexPath.row] as! DocumentsList
                    let url: URL! = URL(string: MainUrl + documentsImagesArray.path)
                    let theFileName = url?.pathExtension
                    print("theFileName is \(String(describing: theFileName))")
                    if theFileName == "pdf" {
                        self.fullImage.isHidden = true
                        self.webViewImage.isHidden = false
                        self.webViewImage.load(URLRequest(url: url))
                    } else {
                        self.fullImage.isHidden = false
                        self.webViewImage.isHidden = true
                        self.fullImage.sd_setImage(with: url, placeholderImage: UIImage(named: ""))
                    }
            })
            let Gallery_Picker = UIAlertAction(title: self.theme.setLang("upload")
                , style: .default, handler: {
                    (alert: UIAlertAction!) -> Void in
                    self.openCamera()
            })
            let cancelAction = UIAlertAction(title: self.theme.setLang("cancel"), style: .cancel, handler: {
                (alert: UIAlertAction!) -> Void in
                
            })
            ImagePicker_Sheet.addAction(Camera_Picker)
            ImagePicker_Sheet.addAction(Gallery_Picker)
            ImagePicker_Sheet.addAction(cancelAction)
            
            self.present(ImagePicker_Sheet, animated: true, completion: nil)
            
        }
        else
        {
            self.theme.AlertView(ProductAppName, Message: self.theme.setLang("Please Select Expiry Date First"), ButtonTitle: kOk)
        }
        
    }
    func openCamera() {
        let ImagePicker_Sheet = UIAlertController(title: nil, message: self.theme.setLang("select_image")
            , preferredStyle: .actionSheet)
        let Camera_Picker = UIAlertAction(title: self.theme.setLang("camera")
            , style: .default, handler: {
                (alert: UIAlertAction!) -> Void in
                self.openCameraView()
        })
//        let Gallery_Picker = UIAlertAction(title: self.theme.setLang("gallery")
//            , style: .default, handler: {
//                (alert: UIAlertAction!) -> Void in
//                self.openPhotoLibrary()
//        })
//        let Document_Picker = UIAlertAction(title: self.theme.setLang("document")
//            , style: .default, handler: {
//                (alert: UIAlertAction!) -> Void in
//                self.checkDocument()
//        })
        let cancelAction = UIAlertAction(title: self.theme.setLang("cancel"), style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        ImagePicker_Sheet.addAction(Camera_Picker)
       // ImagePicker_Sheet.addAction(Gallery_Picker)
       // ImagePicker_Sheet.addAction(Document_Picker)
        ImagePicker_Sheet.addAction(cancelAction)
        
        self.present(ImagePicker_Sheet, animated: true, completion: nil)
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

    func openCameraView()
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
        if (UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            DispatchQueue.main.async {
                self.imgpicker.sourceType = UIImagePickerController.SourceType.camera
                self.imgpicker.allowsEditing = true
                self.present(self.imgpicker, animated: true, completion: nil)
            }
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "Sorry, this device has no camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func checkGallery() {
        // Get the current authorization state.
        let status = PHPhotoLibrary.authorizationStatus()
        if (status == PHAuthorizationStatus.authorized) {
            // Access has been granted.
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
//        self.imagePicker = .photoLibrary
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
        let image = UIImage.init(cgImage: pickimage.cgImage!)
        imagedata = pickimage.jpegData(compressionQuality: 0.1)!;
        let indexPath = IndexPath(row: self.SelectedIndex, section: 0)
        let cell = documentsTable.cellForRow(at: indexPath) as! DocumentsListCell
        cell.documentImg.image = image
        self.UploadImages()
        print("The Picked image is ------>!\(image)")
        self.hideImagePicker()
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        UserImage.image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        let pickimage = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        let pickedimage = self.theme.rotateImage(pickimage!)
        imagedata = pickedimage.jpegData(compressionQuality: 0.1)!;
        let indexPath = IndexPath(row: self.SelectedIndex, section: 0)
        let cell = documentsTable.cellForRow(at: indexPath) as! DocumentsListCell
        print("The Picked imagedata is ------>!\(pickedimage)")
        cell.documentImg.image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
        self.UploadImagesByIndex(index: self.SelectedIndex)//self.UploadImages()
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
        self.imagedata = try! Data.init(contentsOf: myURL)
        thumbnailFromPdf(withUrl: myURL, pageNumber: 1)
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
        let indexPath = IndexPath(row: self.SelectedIndex, section: 0)
        let cell = documentsTable.cellForRow(at: indexPath) as! DocumentsListCell
        cell.documentImg.image = image
        self.uploadDocuments()
        UIGraphicsEndImageContext()
        return image
    }
    
    //MARK: - On appear GetDocuments API Function
    func getProviderDocuments() {
        
        self.theme.showProgress(View: self.view)
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["id":"\(objUserRecs.providerId)"]
        url_handler.makeCall(getMyDocumentsById, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            self.theme.DismissProgress()
            if (error != nil) {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
            } else {
                if (responseObject != nil && (responseObject?.count)!>0) {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status = self.theme.CheckNullValue(responseObject["status"])
                    
                    if (status == "success") {
                        
                        let documentArray = responseObject["Documents"] as? [Any] ?? []
                        for documentDetails in documentArray {
                            let documents = DocumentsList()
                            let documentDetails = documentDetails as? [String:Any] ?? [:]
                            documents.name = self.theme.CheckNullValue(documentDetails["name"])
                            documents.path = self.theme.CheckNullValue(documentDetails["path"])
                            documents.file_type = self.theme.CheckNullValue(documentDetails["file_type"])
                            documents.status = self.theme.CheckNullValue(documentDetails["status"])
                            documents._id = self.theme.CheckNullValue(documentDetails["_id"])

                            documents.expireyDate = self.theme.CheckNullValue(documentDetails["expiry_date"])

                            
                           // if let dicexpiry_date = documentDetails["expiry_date"] as? NSDictionary
//                            {
//                                if let date = dicexpiry_date["date"] as? NSNumber
//                                {
//                                    if let month = dicexpiry_date["month"] as? NSNumber
//                                    {
//                                        if let year = dicexpiry_date["year"] as? NSNumber
//                                        {
//                                            documents.expireyDate = ("\(month)") + "-" + ("\(date)") + "-" + ("\(year)")
//                                        }
//                                    }
//                                }
//                            }
                            
                            self.documentsArray.append(documents)
                        }
                        self.documentsTable.reloadData()

                    }
                    else {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
                    }
                    /*
                    
                    let Rasponse = responseObject["response"] as? [String:Any] ?? [:]
                    if (status == "1") || (status == "3") {
                        self.siteUrl = "\(MainUrl)/"
                        print("SiteUrl is \(self.siteUrl)")
                    
                        let DocumentStatus = self.theme.CheckNullValue(Rasponse["document_upload_status"])
                        self.theme.saveDocumentStatus(DocumentStatus)
                        if DocumentStatus == "1"{
                            let documentArray = Rasponse["documents"] as? [Any] ?? []
                            
                            for documentDetails in documentArray {
                                let documents = DocumentsList()
                                let documentDetails = documentDetails as? [String:Any] ?? [:]
                                documents.name = self.theme.CheckNullValue(documentDetails["name"])
                                documents.path = self.theme.CheckNullValue(documentDetails["path"])
                                documents.file_type = self.theme.CheckNullValue(documentDetails["file_type"])
                                if let dicexpiry_date = documentDetails["expiry_date"] as? NSDictionary
                                {
                                    if let date = dicexpiry_date["date"] as? NSNumber
                                    {
                                        if let month = dicexpiry_date["month"] as? NSNumber
                                        {
                                            if let year = dicexpiry_date["year"] as? NSNumber
                                            {
                                                documents.expireyDate = ("\(month)") + "-" + ("\(date)") + "-" + ("\(year)")
                                            }
                                        }
                                    }
                                }
                                
                                self.documentsArray.append(documents)
                            }
                            self.documentsTable.reloadData()
                        }else{
                            self.theme.AlertView(ProductAppName, Message: self.theme.setLang("cant_view_doc"), ButtonTitle: kOk)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.setInitialViewcontroller()
                        }
                    } else {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
                    }
                    */
                }
            }
        }
        
        /*
        self.theme.showProgress(View: self.view)
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let Param: Dictionary = ["provider_id":"\(objUserRecs.providerId)"]
        url_handler.makeCall(viewProfile, param: Param as NSDictionary) {
            (responseObject, error) -> () in
            self.theme.DismissProgress()
            if (error != nil) {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
            } else {
                if (responseObject != nil && (responseObject?.count)!>0) {
                    let responseObject = responseObject as? [String:Any] ?? [:]
                    let status = self.theme.CheckNullValue(responseObject["status"])
                    let Rasponse = responseObject["response"] as? [String:Any] ?? [:]
                    if (status == "1") || (status == "3") {
                        self.siteUrl = "\(MainUrl)/"
                        print("SiteUrl is \(self.siteUrl)")
                    
                        let DocumentStatus = self.theme.CheckNullValue(Rasponse["document_upload_status"])
                        self.theme.saveDocumentStatus(DocumentStatus)
                        if DocumentStatus == "1"{
                            let documentArray = Rasponse["documents"] as? [Any] ?? []
                            
                            for documentDetails in documentArray {
                                let documents = DocumentsList()
                                let documentDetails = documentDetails as? [String:Any] ?? [:]
                                documents.name = self.theme.CheckNullValue(documentDetails["name"])
                                documents.path = self.theme.CheckNullValue(documentDetails["path"])
                                documents.file_type = self.theme.CheckNullValue(documentDetails["file_type"])
                                if let dicexpiry_date = documentDetails["expiry_date"] as? NSDictionary
                                {
                                    if let date = dicexpiry_date["date"] as? NSNumber
                                    {
                                        if let month = dicexpiry_date["month"] as? NSNumber
                                        {
                                            if let year = dicexpiry_date["year"] as? NSNumber
                                            {
                                                documents.expireyDate = ("\(month)") + "-" + ("\(date)") + "-" + ("\(year)")
                                            }
                                        }
                                    }
                                }
                                
                                self.documentsArray.append(documents)
                            }
                            self.documentsTable.reloadData()
                        }else{
                            self.theme.AlertView(ProductAppName, Message: self.theme.setLang("cant_view_doc"), ButtonTitle: kOk)
                            let appDelegate = UIApplication.shared.delegate as! AppDelegate
                            appDelegate.setInitialViewcontroller()
                        }
                    } else {
                        self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
                    }
                }
            }
        }
        
        */
    }
    //UPLoadDocument API Function
    func uploadDocuments()
    {
        self.theme.showProgress(View: self.view)
        
        let documentsListArray : DocumentsList =  documentsArray[self.SelectedIndex]
        let FullDate = documentsListArray.expireyDate.split(separator: "-")
        
        let Month = FullDate[0]
        let Date = FullDate[1]
        let year = FullDate[2]
        
        let param = ["expiry_date[year]":year,"expiry_date[month]":Month,"expiry_date[date]":Date] as [String : Any]
        
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let URL = try! URLRequest(url: editDocument, method: .post, headers: ["apptype": "ios", "apptoken":"\(theme.GetDeviceToken())", "providerid":"\(objUserRecs.providerId)","type":"tasker"])
        
        
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
                                self.documentsArray[self.SelectedIndex].path = self.theme.CheckNullValue((document as AnyObject).object(forKey: "path"))
                                self.documentsArray[self.SelectedIndex].file_type = self.theme.CheckNullValue((document as AnyObject).object(forKey: "file_type"))
                                print("documentsArray is  \(self.documentsArray)")
                                dump(self.documentsArray)
                                self.isUpdated = true
                            }
                        } else {
                            
                        }
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
    func UploadImagesExpiryDate()
    {
        self.theme.showProgress(View: self.view)
        let documentsListArray : DocumentsList =  documentsArray[self.SelectedIndex]
        let url1 = URL(string: siteUrl + documentsListArray.path)
       
            if let data = try? Data(contentsOf: url1!)
            {
                if let datenew = data as? Data
                {
                    let image: UIImage = UIImage(data: data)!
                    imagedata = image.jpegData(compressionQuality: 0.1)!;
                }
                
            }
        
        
        let FullDate = documentsListArray.expireyDate.split(separator: "-")
        
        let Month = FullDate[0]
        let Date = FullDate[1]
        let year = FullDate[2]
        
        let param = ["expiry_date[year]":year,"expiry_date[month]":Month,"expiry_date[date]":Date] as [String : Any]
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let URL = try! URLRequest(url: editDocument, method: .post, headers: ["apptype": "ios", "apptoken":"\(theme.GetDeviceToken())", "providerid":"\(objUserRecs.providerId)","type":"tasker"])
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(self.imagedata, withName: "Image", fileName: "image.jpeg", mimeType: "image/jpg")
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
                                self.documentsArray[self.SelectedIndex].path = self.theme.CheckNullValue((document as AnyObject).object(forKey: "path"))
                                self.documentsArray[self.SelectedIndex].file_type = self.theme.CheckNullValue((document as AnyObject).object(forKey: "file_type"))
                                print("documentsArray is  \(self.documentsArray)")
                                dump(self.documentsArray)
                                self.isUpdated = true
                            }
                        } else {
                            
                        }
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
    //UPloadImages API Function
    func UploadImages()
    {
        self.theme.showProgress(View: self.view)
        let documentsListArray : DocumentsList =  documentsArray[self.SelectedIndex]
        let FullDate = documentsListArray.expireyDate.split(separator: "-")
        
        let Month = FullDate[0]
        let Date = FullDate[1]
        let year = FullDate[2]
        
        let param = ["expiry_date[year]":year,"expiry_date[month]":Month,"expiry_date[date]":Date] as [String : Any]
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let URL = try! URLRequest(url: editDocument, method: .post, headers: ["apptype": "ios", "apptoken":"\(theme.GetDeviceToken())", "providerid":"\(objUserRecs.providerId)","type":"tasker"])
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(self.imagedata, withName: "Image", fileName: "image.jpeg", mimeType: "image/jpg")
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
                                self.documentsArray[self.SelectedIndex].path = self.theme.CheckNullValue((document as AnyObject).object(forKey: "path"))
                                self.documentsArray[self.SelectedIndex].file_type = self.theme.CheckNullValue((document as AnyObject).object(forKey: "file_type"))
                                print("documentsArray is  \(self.documentsArray)")
                                dump(self.documentsArray)
                                self.isUpdated = true
                            }
                        } else {
                            
                        }
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
    //UPdateDocuments API Function
    func UpdateDocuments(index:Int) {
        self.theme.showProgress(View: self.view)
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        var documentid = ""
        var path = ""
        var filetype = ""
        var expiry_date = ""

        if  self.documentsArray.count > index
        {
            documentid = self.documentsArray[index]._id
            path = self.documentsArray[index].path

            filetype = self.documentsArray[index].file_type
            expiry_date = self.documentsArray[index].expireyDate

        }
        let param : NSDictionary =  ["id":"\(objUserRecs.providerId)",
                                     "documentid":documentid,
                                     "path":path,
                                     "filetype":filetype,
                                     "expiry_date":expiry_date]
        print("The params is \(param)")
        url_handler.makeCall(UploadMyAllDocReqById, param: param as NSDictionary) {
            (responseObject, error) -> () in
            self.theme.DismissProgress()
            if (error != nil) {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
            } else {
                let responseObject = responseObject!
                print("Response is \(responseObject)")
                let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                if (status == "1") {
                    let message=self.theme.CheckNullValue(responseObject.object(forKey: "message"))
                    self.theme.AlertView(Language_handler.VJLocalizedString("success", comment: nil), Message:message, ButtonTitle: kOk)
                } else {
                    self.theme.AlertView("\(appNameJJ)", Message: self.theme.CheckNullValue(responseObject.object(forKey: "response")), ButtonTitle: kOk)
                }
            }
        }
        
        /*
        
        let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        print("documentsArray is \(self.documentsArray)")
        var FinalDocumentArray = [[String:Any]]()
        for data in documentsArray {
            var Object = [String : Any]()
            
            let FullDate = data.expireyDate.split(separator: "-")
            
            let Month = FullDate[0]
            let Date = FullDate[1]
            let year = FullDate[2]
            let dicDate = ["year":year,"month":Month,"date":Date]
            
            
            Object = ["name":data.name,"file_type":data.file_type,"path":data.path,"expiry_date":dicDate]
            FinalDocumentArray.append(Object)
        }
        print("The FinalDocumentArray is as Follows\(FinalDocumentArray)")
        let param : NSDictionary =  ["provider_id":objUserRecs.providerId,"documents":FinalDocumentArray]
        print("The params is \(param)")
        url_handler.makeCall(updateDocument, param: param as NSDictionary) {
            (responseObject, error) -> () in
            self.theme.DismissProgress()
            if (error != nil) {
                self.view.makeToast(message:kErrorMsg, duration: 3, position: HRToastPositionDefault as AnyObject, title: "Network Failure !!!")
            } else {
                let responseObject = responseObject!
                print("Response is \(responseObject)")
                let status=self.theme.CheckNullValue(responseObject.object(forKey: "status"))
                if (status == "1") {
                    let message=self.theme.CheckNullValue(responseObject.object(forKey: "message"))
                    self.theme.AlertView(Language_handler.VJLocalizedString("success", comment: nil), Message:message, ButtonTitle: kOk)
                } else {
                    self.theme.AlertView("\(appNameJJ)", Message: self.theme.CheckNullValue(responseObject.object(forKey: "response")), ButtonTitle: kOk)
                }
            }
        }
        */
    }
}
extension UITableView {
    
    var tableViewHeight: CGFloat                    //Maulik - 12/03/2019
    {
        self.layoutIfNeeded()
        return self.contentSize.height
    }
    
    var tableViewWidth: CGFloat                    //Maulik - 12/03/2019
    {
        get {
            self.layoutIfNeeded()
            return self.contentSize.width
        }
        set {
            self.layoutIfNeeded()
            self.contentSize.width = newValue
        }
    }
    
    func setEmptyMessage(_ message: String) {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = message
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.font = UIFont(name: "Asap-Regular", size: 16)
        messageLabel.sizeToFit()
        
        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
    
    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .none
    }
    
}

extension MyDocumentsViewController
{
    
    //MARK: - UPloadImage API Function
    
    func UploadImagesByIndex(index:Int) {
            self.theme.showProgress(View: self.view)
        //let objUserRecs:UserInfoRecord=theme.GetUserDetails()
        let URL = try! URLRequest(url: UploadDocReqById, method: .post, headers: nil)
        Alamofire.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(self.imagedata, withName: "file", fileName: "file.jpeg", mimeType: "image/jpg")
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
                            self.documentsArray[index].path = self.theme.CheckNullValue((JSON as AnyObject).object(forKey: "file"))
                            self.documentsArray[index].file_type = self.theme.CheckNullValue((JSON as AnyObject).object(forKey: "filetype"))
                            //self.documentsArray[index]._id = self.theme.CheckNullValue((JSON as AnyObject).object(forKey: "_id"))
                            dump(self.documentsArray)
                            self.documentsTable.reloadData()
                        } else {
                            
                        }
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
}


extension String
{
    
    func getdateFromTimeStamp() -> String
    {
        if let timeResult = Double(self)
        {
            
            let date = Date(timeIntervalSince1970: timeResult)
            
            let dateFormatter = DateFormatter()
            
            dateFormatter.locale = Locale(identifier: "en_US")

            dateFormatter.dateFormat = "yyyy-MM-dd"
            let localDate = dateFormatter.string(from: date)
            return localDate
        }
        return ""

    }
    
    
}
extension Double {
    func getDateStringFromUTC() -> String {
        let date = Date(timeIntervalSince1970: self/1000)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current//(abbreviation: "GMT") //Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "MM-dd-yyyy"//"MMM dd, yyyy" //Specify your format that you want
    
        return dateFormatter.string(from: date ?? Date())
    }
}
