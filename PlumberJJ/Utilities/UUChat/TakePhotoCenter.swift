//
//  TakePhotoCenter.swift
//  UUChatTableViewSwift
//
//  Created by XcodeYang on 8/21/15.
//  Copyright © 2015 XcodeYang. All rights reserved.
//

import UIKit

typealias PickImageBlock = (_ image: UIImage) -> Void

class TakePhotoCenter: NSObject ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    var viewController:UIViewController!
    var successBlock:PickImageBlock?
    
    func takePhoto (viewController vc: UIViewController!, didSelected: PickImageBlock?) {
        
        viewController = vc
        successBlock = didSelected
        
        let sheet = UIAlertController()
        // is the device support camera?（iPod & Simulator）
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            sheet.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { _ in
                self.showPhotoes(sourceType: .camera)
            }))
        }
        sheet.addAction(UIAlertAction.init(title: "PhotoLibrary", style: .default, handler: { _ in
            self.showPhotoes(sourceType: .photoLibrary)
        }))
        sheet.addAction(UIAlertAction.init(title: "SavedPhotosAlbum", style: .default, handler: { _ in
            self.showPhotoes(sourceType: .savedPhotosAlbum)
        }))
        sheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        viewController.present(sheet, animated: true, completion: nil)
    }
    
    func showPhotoes(sourceType type: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.sourceType = type
            self.viewController.present(controller, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        viewController.dismiss(animated: true) { () -> Void in
            if (self.successBlock != nil) {
                let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.originalImage.rawValue)] as? UIImage
                self.successBlock!(image!)
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        viewController.dismiss(animated: true, completion: nil)
    }
}
