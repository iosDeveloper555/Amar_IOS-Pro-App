//
//  ChangeLanguageViewController.swift
//  PlumberJJ
//
//  Created by Casperon iOS on 16/10/2017.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class ChangeLanguageViewController: UIViewController {
    
    @IBOutlet weak var ChangeLanguagelable: UILabel!
    
    @IBOutlet var Tamil: UIButton!
    
    @IBOutlet weak var English: UIButton!
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.Tamil.setTitle("Tamil", for: UIControl.State())
        ChangeLanguagelable.text = theme.setLang("Language Change")
        
        self.Tamil.layer.cornerRadius = 25
        self.Tamil.clipsToBounds = true
        self.English.layer.cornerRadius = 25
        self.English.clipsToBounds = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func Tamil(_ sender: UIButton) {
        
        if sender.titleLabel!.text == "English"{
            UIView.transition(with: sender as UIView, duration: 1, options: .transitionFlipFromRight, animations: {() -> Void in
                
                sender.setTitle("Tamil", for: .normal)
                
                theme.saveLanguage("ta")
            },
                              completion: { _ in
            })
        }
        else
        {
            UIView.transition(with: sender as UIView, duration: 1, options: .transitionFlipFromRight, animations: {() -> Void in
                
                
                sender.setTitle("English", for: .normal)
                theme.saveLanguage("en")
                
            },
                              completion: { _ in
            })
            
            
        }
        //        kLanguage = "ta"
        
    }
    
    
    @IBAction func English(_ sender: AnyObject)
    {
      
            
            theme.SetLanguageToApp()
            SwapLanguage(language: theme.getAppLanguage())
      
        
        
        
       
        
    }
    @IBAction func back_btn(_ sender: AnyObject) {
        self.view.endEditing(true)
        self.frostedViewController.view.endEditing(true)
        self.frostedViewController.presentMenuViewController()
    }
    
    
    
    
    
}
