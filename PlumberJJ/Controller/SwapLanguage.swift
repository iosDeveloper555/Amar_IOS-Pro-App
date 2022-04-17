//
//  SwapLanguage.swift
//  PlumberJJ
//
//  Created by Casperon iOS on 16/10/2017.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class SwapLanguage: NSObject {
    
    var storyboard : UIStoryboard{
        
        get{
            if theme.getAppLanguage() == "en"{
                return UIStoryboard(name: "Main", bundle: nil)
            }
            else {
                return UIStoryboard(name: "Main", bundle: nil)
            }
        }
        set{
            
        }
    }
    
    override init() {
        super.init()
        if theme.getAppLanguage() == "en"{
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
        else{
            storyboard = UIStoryboard(name: "Main", bundle: nil)
        }
    }
    
    convenience init(language : String) {
        self.init()
        let appdelegate = UIApplication.shared.delegate as! AppDelegate
        appdelegate.setInitialViewcontroller()
    }
    
}
