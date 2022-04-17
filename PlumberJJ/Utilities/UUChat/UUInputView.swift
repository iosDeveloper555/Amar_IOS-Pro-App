//
//  UUInputView.swift
//  UUChatTableViewSwift
//
//  Created by XcodeYang on 8/13/15.
//  Copyright © 2015 XcodeYang. All rights reserved.
//

import UIKit

typealias TextBlock  = (_ text:String,    _ textView:UITextView)->Void
typealias ImageBlock = (_ image:UIImage,  _ textView:UITextView)->Void
typealias VoiceBlock = (_ voice:Data,   _ textView:UITextView)->Void

class UUInputView: UIToolbar, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    var leftButton: UIButton!
    var rightButton: UIButton!
    var contentTextView: UITextView!
    var placeHolderLabel: UILabel!
    var contentViewHeightConstraint: NSLayoutConstraint!
    
    var sendTextBlock:TextBlock!
    var sendImageBlock:ImageBlock!
    var sendVoiceBlock:VoiceBlock!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        leftButton = UIButton()
        self.addSubview(leftButton)
        leftButton.setImage(UIImage(named: "chat_voice_record"), for: UIControl.State())
        leftButton.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-8)
            make.width.height.equalTo(30)
        }

        rightButton = UIButton()
        self.addSubview(rightButton)
        rightButton.setImage(UIImage(named: "chat_take_picture"), for: UIControl.State())
        rightButton.addTarget(self, action: #selector(UUInputView.sendImage), for: .touchUpInside)
        rightButton.snp_makeConstraints { (make) -> Void in
            make.trailing.bottom.equalTo(self).offset(-8)
            make.height.width.equalTo(30)
        }
        
        contentTextView = UITextView()
        self.addSubview(contentTextView)
        contentTextView.layer.cornerRadius = 4
        contentTextView.layer.borderWidth = 0.5
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.delegate = self
        contentTextView.returnKeyType = .send
        contentTextView.enablesReturnKeyAutomatically = true
        contentTextView.snp_makeConstraints { (make) -> Void in
            make.leading.equalTo(self).offset(45)
            make.trailing.equalTo(self).offset(-45)
            make.top.equalTo(self).offset(8)
            make.bottom.equalTo(self).offset(-8)
            make.height.greaterThanOrEqualTo(30)
        }
        // temporary method
        contentViewHeightConstraint = NSLayoutConstraint(
            item: contentTextView,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.equal,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: 30
        )
//        contentViewHeightConstraint.priority = UILayoutPriority.defaultHigh
        contentTextView.addConstraint(contentViewHeightConstraint)
        
        placeHolderLabel = UILabel()
        placeHolderLabel.text = "请在这里输入文本内容"
        placeHolderLabel.textColor = UIColor.lightGray
        placeHolderLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        contentTextView.addSubview(placeHolderLabel)
        placeHolderLabel.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(contentTextView)
        }
}
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func sendMessage(imageBlock:@escaping ImageBlock, textBlock:@escaping TextBlock, voiceBlock:@escaping VoiceBlock){
        self.sendImageBlock = imageBlock
        self.sendTextBlock = textBlock
        self.sendVoiceBlock = voiceBlock
    }
    
    //MARK: textViewDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        placeHolderLabel.isHidden = !textView.text.isEmpty
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text != "\n" {
            return true
        } else {
            // send text
            self.sendTextBlock!(contentTextView.text, contentTextView)
            textView.text = ""
            self.textViewDidChange(textView)
            return false
        }
    }
    
    // adjust content's height from 30 t0 100
    func textViewDidChange(_ textView: UITextView) {
        let textContentH = textView.contentSize.height
        print("output：\(textContentH)")
        let textHeight = textContentH>30 ? (textContentH<100 ? textContentH:100):30
        UIView.animate(withDuration: 0.2, animations: { () -> Void in
            self.contentViewHeightConstraint.constant = textHeight
            self.layoutIfNeeded()
            self.superview?.layoutIfNeeded()
//            let vc = self.responderViewController() as! ChatTableViewController
//            vc.view.layoutIfNeeded()
//            vc.chatTableView.scrollToBottom(animation: true)
        })
    }
    
    @objc func sendImage() {
        self.contentTextView.resignFirstResponder()
        
        let sheet = UIAlertController()
        // is the device support camera?（iPod & Simulator）
        if (UIImagePickerController.isSourceTypeAvailable(.camera)) {
            sheet.addAction(UIAlertAction.init(title: "Camera", style: .default, handler: { _ in
                self.showPhotoes(.camera)
            }))
        }
        sheet.addAction(UIAlertAction.init(title: "PhotoLibrary", style: .default, handler: { _ in
            self.showPhotoes(.photoLibrary)
        }))
        sheet.addAction(UIAlertAction.init(title: "SavedPhotosAlbum", style: .default, handler: { _ in
            self.showPhotoes(.savedPhotosAlbum)
        }))
        sheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        
//        if let resppp = self.responderViewController() {
//            resppp.present(sheet, animated: true, completion: nil)
//        }
    }
    
    func showPhotoes(_ source: UIImagePickerController.SourceType) {
//        if let resppp = self.responderViewController() {
//            let controller = UIImagePickerController()
//            controller.delegate = self
//            controller.sourceType = source
//            controller.allowsEditing = true
//            resppp.present(controller, animated: true, completion: nil)
//        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        responderViewController().dismiss(animated: true) { [weak self]() -> Void in
            let image = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.editedImage.rawValue)] as? UIImage
            self!.sendImageBlock!(image!, self!.contentTextView)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.responderViewController().dismiss(animated: true, completion: nil)
    }
    
}

