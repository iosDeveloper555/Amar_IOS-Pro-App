//
//  Languagehandler.swift
//  Plumbal
//
//  Created by Casperon Tech on 10/12/15.
//  Copyright © 2015 Casperon Tech. All rights reserved.
//

import UIKit
let Language_Notification:NSString="VJLanguageDidChage"

@objcMembers class Languagehandler:NSObject {
    var LocalisedString:Bundle=Bundle()
    
    
    
    let EnglishGBLanguageShortName:NSString="en-GB"
    let EnglishUSLanguageShortName:NSString="en"
    let FrenchLanguageShortName:NSString="fr"
    let SpanishLanguageShortName:NSString="es"
    let ItalianLanguageShortName:NSString="it"
    let HebrewLanguageShortName:NSString="he"
    let ArebicLanguageShortName:NSString="ar"
    let JapaneseLanguageShortName:NSString="ja"

    let KoreanLanguageShortName:NSString="ko"
    let ChineseLanguageShortName:NSString="zh"
    
    let TurkishLanguageShortName:NSString="tr"
    let TamilLanguageShortName : NSString = "ta"
    
    let EnglishGBLanguageLongName:NSString="English(UK)"
    let EnglishUSLanguageLongName:NSString="English(US"
    let FrenchLanguageLongName:NSString="French"
    let SpanishLanguageLongName:NSString="Spanish"
    let ItalianLanguageLongName:NSString="Italian"

    let JapaneseLanguageLongName:NSString="Japenese"
    let KoreanLanguageLongName:NSString="한국어"

    let ChineseLanguageLongName:NSString="中国的"
    let TurkishLanguageLongName:NSString="Turkish"
    
    let TamilLanguageLongName : NSString = "Tamil"

    var  _languagesLong:NSArray!=NSArray()

     var _localizedBundle:Bundle!=Bundle()
    func localizedBundle()->Bundle
    {
        if(_localizedBundle == nil)
        {
        _localizedBundle=Bundle(path: Bundle.main.path(forResource: "\(ApplicationLanguage())", ofType: "lproj")!)!
        }
        return _localizedBundle

    }
    
    func ApplicationLanguage()->String
    {
         let languages:NSArray=UserDefaults.standard.object(forKey: "AppleLanguages") as! NSArray
        return languages.firstObject as! String

    }
    
    
    func setApplicationLanguage(_ language:NSString)
    {
 
    let oldLanguage: NSString = ApplicationLanguage() as NSString
        
        print("\(oldLanguage)....\(ApplicationLanguage())")
//    if (oldLanguage.isEqualToString(language as String) == false)
//    {
    UserDefaults.standard.set([language], forKey: "AppleLanguages")
    UserDefaults.standard.synchronize()
        _localizedBundle=Bundle(path: Bundle.main.path(forResource: "\(ApplicationLanguage())", ofType: "lproj")!)!
    NotificationCenter.default.post(name: Notification.Name(rawValue: Language_Notification as String), object: nil, userInfo: nil)
//    }
    }
    
  func applicationLanguagesLong()->NSArray
  {
    if _languagesLong == nil {
   _languagesLong = [ChineseLanguageLongName, EnglishGBLanguageLongName, EnglishUSLanguageLongName, FrenchLanguageLongName, KoreanLanguageLongName, ItalianLanguageLongName, SpanishLanguageLongName, TurkishLanguageLongName]
    }
    return _languagesLong
    }

    
    func VJLocalizedString(_ key:String!,comment:String!)->String
{
    
    print("\(localizedBundle())")
    _localizedBundle=Bundle(path: Bundle.main.path(forResource: "\(ApplicationLanguage())", ofType: "lproj")!)!

    return _localizedBundle.localizedString(forKey: key, value: "", table: nil)
    }
    
    func shortLanguageToLong(_ shortLanguage:NSString)->NSString
    {
        
        if(shortLanguage.isEqual(to: EnglishGBLanguageLongName as String))
        {
            return EnglishGBLanguageLongName;

        }
        if(shortLanguage.isEqual(to: EnglishUSLanguageShortName as String))
        {
            return EnglishUSLanguageShortName;
            
        }

        if(shortLanguage.isEqual(to: EnglishGBLanguageShortName as String))
        {
            return EnglishGBLanguageLongName;
            
        }

        if(shortLanguage.isEqual(to: ChineseLanguageShortName as String))
        {
            return ChineseLanguageShortName;
            
        }

        if(shortLanguage.isEqual(to: FrenchLanguageShortName as String))
        {
            return FrenchLanguageShortName;
            
        }

        if(shortLanguage.isEqual(to: KoreanLanguageShortName as String))
        {
            return KoreanLanguageShortName;
            
        }

        if(shortLanguage.isEqual(to: ItalianLanguageShortName as String))
        {
            return ItalianLanguageShortName;
            
        }

        if(shortLanguage.isEqual(to: SpanishLanguageShortName as String))
        {
            return SpanishLanguageShortName;
            
        }
        if(shortLanguage.isEqual(to: TamilLanguageShortName as String))
        {
            return TamilLanguageShortName;
            
        }
            
        if(shortLanguage.isEqual(to: TamilLanguageLongName as String))
        {
            return TamilLanguageLongName;
            
        }
        else
        {
            
            return ""
            
        }

        
    }
    
    

}
