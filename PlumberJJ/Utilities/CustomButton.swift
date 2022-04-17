//
//  CustomButton.swift
//  Plumbal
//
//  Created by Casperon Tech on 07/11/15.
//  Copyright © 2015 Casperon Tech. All rights reserved.
//

import UIKit

//MARK: - Custom Button
class CustomvalidLabel: UILabel {
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        self.font = PlumberMediumBoldFont
        self.adjustsFontSizeToFitWidth = false
    }
}

class CustomButton: UIButton {
    var themes:Theme=Theme()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = PlumberThemeColor
        self.setTitleColor(UIColor.white, for: UIControl.State())
        self.titleLabel?.font = PlumberLargeFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
}


class CustomButtonSmall: UIButton {
    var themes:Theme=Theme()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = PlumberThemeColor
        self.setTitleColor(UIColor.white, for: UIControl.State())
        self.titleLabel?.font = PlumberMediumFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
}

class CustomButtonThemeColor: UIButton {
    var themes:Theme=Theme()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setTitleColor(UIColor.blue, for: UIControl.State())
        self.titleLabel?.font = PlumberLargeBoldFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
}
class CustomButtonTitle: UIButton {
    var themes:Theme=Theme()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.backgroundColor = PlumberLightGrayColor
        self.setTitleColor(UIColor.black, for: UIControl.State())
        self.titleLabel?.font = PlumberLargeFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
}

class TextColorButton: UIButton {
    var themes:Theme=Theme()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setTitleColor(themes.ThemeColour(), for: UIControl.State())
        self.titleLabel?.font = PlumberSmallFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
}

class TextColorButtonTheme: UIButton {
    var themes:Theme=Theme()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setTitleColor(PlumberThemeColor, for: UIControl.State())
        self.titleLabel?.font = PlumberMediumFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
}

class TextColorButtonWhite: UIButton {
    var themes:Theme=Theme()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setTitleColor(UIColor.white, for: UIControl.State())
        self.titleLabel?.font = PlumberMediumFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
}

class CustomButtonBold: UIButton {
    var themes:Theme=Theme()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setTitleColor(UIColor.black, for: UIControl.State())
        self.titleLabel?.font = PlumberMediumBoldFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
}

class CustomButtonHeader:UIButton{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setTitleColor(UIColor.white, for: UIControl.State())
        self.titleLabel?.font = PlumberLargeFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
}

class CustomButtonHeaderBold:UIButton{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setTitleColor(UIColor.white, for: UIControl.State())
        self.titleLabel?.font = PlumberLargeBoldFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
}

class CustomButtonRed: UIButton {
    var themes:Theme=Theme()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setTitleColor(UIColor.red, for: UIControl.State())
        self.titleLabel?.font = PlumberMediumBoldFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
    }
}

class CustomButtonGray: UIButton {
    var themes:Theme=Theme()
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.setTitleColor(UIColor.darkGray, for: UIControl.State())
        self.titleLabel?.font = PlumberLargeBoldFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
        
        
    }
}

//MARK:- Custom font Handler
class HeaderLabelStyle: UILabel {
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        self.textColor = .black
        self.font = PlumberHeaderFont
        self.adjustsFontSizeToFitWidth = true
        self.adjustsFontForContentSizeCategory = true
    }
}

class SubHeaderLabelStyle: UILabel {
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        self.textColor = .black
        self.font = PlumberSubHeaderFont
        self.adjustsFontSizeToFitWidth = true
        self.adjustsFontForContentSizeCategory = true
    }
}

class BodyLabelStyle: UILabel {
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        self.textColor = .black
        self.font = PlumberBodyFont
        self.adjustsFontSizeToFitWidth = true
        self.adjustsFontForContentSizeCategory = true
    }
}

class HeaderbuttonStyle: UIButton {
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = PlumberHeaderFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

class SubHeaderbuttonStyle: UIButton {
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = PlumberSubHeaderFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

class BodybuttonStyle: UIButton {
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        self.setTitleColor(.black, for: .normal)
        self.titleLabel?.font = PlumberBodyFont
        self.titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

class HeaderTextFieldStyle: UITextField {
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        self.textColor = .black
        self.font = PlumberHeaderFont
    }
}

class SubHeaderTextFieldStyle: UITextField {
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        self.textColor = .black
        self.font = PlumberSubHeaderFont
    }
}

class BodyTextFieldStyle: UITextField {
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
//        self.textColor = .black
        self.font = PlumberBodyFont
    }
}



//MARK: - Custom TextField

class CustomTextField:UITextField{
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor = themes.ThemeColour()
        self.font = PlumberMediumFont
        
    }
}

class CustomTextFieldBlack:UITextField{
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor = themes.ThemeColour()
        self.layer.borderColor=themes.Lightgray().cgColor
        self.layer.borderWidth=0.8
        self.font = PlumberMediumFont
        
    }
}

class CustomTextBlack:UITextField{
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor = themes.ThemeColour()
        self.font = PlumberMediumFont
        
    }
}

class CustomTextgray:UITextField{
    var themes:Theme=Theme()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor = UIColor.darkGray
        self.font = PlumberMediumFont
        
    }
}
//MARK: - Custom Label

class CustomLabellight: UILabel {
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        var themes:Theme=Theme()
        print(self.text)
        self.font = PlumberLargelightFont
        self.adjustsFontSizeToFitWidth = true
        self.textColor = UIColor.darkGray
     }
}
class CustomLabel: UILabel {
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        var themes:Theme=Theme()
        print(self.text)
        self.font = PlumberMediumBoldFont
        self.adjustsFontSizeToFitWidth = true
    }
}

class CustomLabelLarge: UILabel {
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        var themes:Theme=Theme()
        self.font = PlumberLargeBoldFont
        self.adjustsFontSizeToFitWidth = true
    }
}
class CustomLabelThemeColor: UILabel {
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.textColor=PlumberThemeColor
        self.font = PlumberMediumBoldFont
       self.adjustsFontSizeToFitWidth = true
    }
}

class CustomLabelGray: UILabel {
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.textColor=UIColor.darkGray
        self.font = PlumberMediumFont
        self.adjustsFontSizeToFitWidth = true
    }
}

class CustomLabelGraySmall: UILabel {
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.textColor=UIColor.darkGray
        self.font = PlumberSmallFont
        self.adjustsFontSizeToFitWidth = true
    }
}

class CustomLabelLightGray: UILabel {
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        self.textColor=UIColor.lightGray
        self.font = PlumberMediumFont
        self.adjustsFontSizeToFitWidth = true
    }
}

class CustomLabelWhite:UILabel{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor=UIColor.white
        self.font = PlumberMediumFont
        self.adjustsFontSizeToFitWidth = true
    }
}

class CustomLabelHeader:UILabel{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor = HeaderLblColor
        self.font = PlumberHeaderLargeFont
        self.adjustsFontSizeToFitWidth = true
    }
}
class CustomLabelHeaderblack:UILabel{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor=UIColor.black
        self.font = PlumberMediumBoldFont
        self.adjustsFontSizeToFitWidth = true
    }
}

class CustomLabelRed:UILabel{
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.textColor=UIColor.red
        self.font = PlumberMediumFont
        self.adjustsFontSizeToFitWidth = true
    }
}

class SetHeaderView: UIView {
    required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)!
        self.backgroundColor = .white
}
}
