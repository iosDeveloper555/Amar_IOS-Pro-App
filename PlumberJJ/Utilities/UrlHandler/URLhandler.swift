
//
//  URLhandler.swift
//  Plumbal
//
//  Created by Casperon Tech on 07/10/15.
//  Copyright © 2015 Casperon Tech. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Alamofire

import Foundation
import Alamofire
import SwiftyJSON


var Dictionay:NSDictionary!=NSDictionary()


class URLhandler: NSObject
{
    
    
     func isConnectedToNetwork() -> Bool {
        
        return (UIApplication.shared.delegate as! AppDelegate).IsInternetconnected
    }
    
    func makeCall(_ url: String,param:NSDictionary, completionHandler: @escaping (_ responseObject: NSDictionary?,_ error:NSError?  ) -> ())
    {
        var user_id:String=""
       
        if(theme.isUserLigin()){
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            print("the objUserRecs is \(objUserRecs)")
            print("the objUserRecs.providerId is \(objUserRecs.providerId)")
            user_id=objUserRecs.providerId
        }
        if isConnectedToNetwork() == true {
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 120
            Alamofire.request("\(url)", method: .post, parameters: param as? Parameters, encoding: JSONEncoding.default, headers: ["devicetype": "ios", "device":"\(theme.GetDeviceToken())", "user":"\(user_id)" , "type":"tasker"])
                .responseJSON { response in
                    do {
                        Dictionay = try JSONSerialization.jsonObject(
                            with: response.data!,
                            
                            options: JSONSerialization.ReadingOptions.mutableContainers
                            
                            ) as? NSDictionary
                        let status:NSString?=Dictionay.object(forKey: "status") as? NSString
                        if(status == "5")
                        {
                            let alertView = UNAlertView(title: ProductAppName, message: "\(Language_handler.VJLocalizedString("log_out1", comment: nil))\n \(Language_handler.VJLocalizedString("log_out2", comment: nil))")
                            alertView.addButton(kOk, action: {
                                let dict: [AnyHashable: Any] = [NSObject : AnyObject]()
                                theme.saveUserDetail(dict as NSDictionary)
//                                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.setInitailLogOut()
//                                NotificationCenter.default.post(name: NSNotification.Name("logout"), object: nil)
                                let Appdel=UIApplication.shared.delegate as! AppDelegate
                                let objUserRecs:UserInfoRecord = theme.GetUserDetails()
                                let providerid = objUserRecs.providerId
                                SocketIOManager.sharedInstance.RemoveAllListener()
                                SocketIOManager.sharedInstance.LeaveRoom(providerid as String)
                                SocketIOManager.sharedInstance.LeaveChatRoom(providerid as String)
                                let dic: NSDictionary = NSDictionary()
                                theme.saveUserDetail(dic)
                                let loginController = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitialVCSID") as! InitialViewController
                                //or the homeController
                                let navController = UINavigationController(rootViewController: loginController)
                                Appdel.window!.rootViewController! = navController
                                loginController.navigationController!.setNavigationBarHidden(true, animated: true)
                            })
                            alertView.show()
                        } else {
                            print("the dictionary is \(param)....\(url)...\(Dictionay ?? [:])")
                            completionHandler(Dictionay as NSDictionary?, response.result.error as NSError? )
                        }
                    }
                        
                    catch let error as NSError {
                        print("the dictionary is \(param)....\(url)...\(Dictionay ?? [:])")
                        Dictionay=nil
                        completionHandler(Dictionay as NSDictionary?, error )
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    Dictionay=nil
            }
                    
            
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kNoNetwork), object: nil)
        }
    }
    
    func makePostCall(_ url: String, jsonData: Data, completionHandler: @escaping (_ responseObject: NSDictionary?,_ error:NSError?  ) -> ())
    {
        var user_id:String=""
       
        if(theme.isUserLigin()){
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            print("the objUserRecs is \(objUserRecs)")
            print("the objUserRecs.providerId is \(objUserRecs.providerId)")
            user_id=objUserRecs.providerId
        }
        if isConnectedToNetwork() == true {
            
            var request = URLRequest(url: URL(string: url)!)
                request.httpMethod = HTTPMethod.post.rawValue
                request.setValue("application/json; charset=UTF-8", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
            
            
            Alamofire.request(request).responseJSON { response in
                do {
                    Dictionay = try JSONSerialization.jsonObject(
                        with: response.data!,
                        
                        options: JSONSerialization.ReadingOptions.mutableContainers
                        
                        ) as? NSDictionary
                    let status:NSString?=Dictionay.object(forKey: "status") as? NSString
                    if(status == "5")
                    {
                        let alertView = UNAlertView(title: ProductAppName, message: "\(Language_handler.VJLocalizedString("log_out1", comment: nil))\n \(Language_handler.VJLocalizedString("log_out2", comment: nil))")
                        alertView.addButton(kOk, action: {
                            let dict: [AnyHashable: Any] = [NSObject : AnyObject]()
                            theme.saveUserDetail(dict as NSDictionary)
//                                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.setInitailLogOut()
//                                NotificationCenter.default.post(name: NSNotification.Name("logout"), object: nil)
                            let Appdel=UIApplication.shared.delegate as! AppDelegate
                            let objUserRecs:UserInfoRecord = theme.GetUserDetails()
                            let providerid = objUserRecs.providerId
                            SocketIOManager.sharedInstance.RemoveAllListener()
                            SocketIOManager.sharedInstance.LeaveRoom(providerid as String)
                            SocketIOManager.sharedInstance.LeaveChatRoom(providerid as String)
                            let dic: NSDictionary = NSDictionary()
                            theme.saveUserDetail(dic)
                            let loginController = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitialVCSID") as! InitialViewController
                            //or the homeController
                            let navController = UINavigationController(rootViewController: loginController)
                            Appdel.window!.rootViewController! = navController
                            loginController.navigationController!.setNavigationBarHidden(true, animated: true)
                        })
                        alertView.show()
                    } else {
                        print("the dictionary is ...\(url)...\(Dictionay ?? [:])")
                        completionHandler(Dictionay as NSDictionary?, response.result.error as NSError? )
                    }
                }
                    
                catch let error as NSError {
                    print("the dictionary is ....\(url)...\(Dictionay ?? [:])")
                    Dictionay=nil
                    completionHandler(Dictionay as NSDictionary?, error )
                    print("A JSON parsing error occurred, here are the details:\n \(error)")
                }
                Dictionay=nil
                }
            
            
//            let manager = Alamofire.SessionManager.default
//            manager.session.configuration.timeoutIntervalForRequest = 120
//            Alamofire.request("\(url)", method: .post, parameters: param as? Parameters, encoding: JSONEncoding.default, headers: ["devicetype": "ios", "device":"\(theme.GetDeviceToken())", "user":"\(user_id)" , "type":"tasker"])
//                .responseJSON { response in
//                    do {
//                        Dictionay = try JSONSerialization.jsonObject(
//                            with: response.data!,
//
//                            options: JSONSerialization.ReadingOptions.mutableContainers
//
//                            ) as? NSDictionary
//                        let status:NSString?=Dictionay.object(forKey: "status") as? NSString
//                        if(status == "5")
//                        {
//                            let alertView = UNAlertView(title: ProductAppName, message: "\(Language_handler.VJLocalizedString("log_out1", comment: nil))\n \(Language_handler.VJLocalizedString("log_out2", comment: nil))")
//                            alertView.addButton(kOk, action: {
//                                let dict: [AnyHashable: Any] = [NSObject : AnyObject]()
//                                theme.saveUserDetail(dict as NSDictionary)
////                                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
////                                appDelegate.setInitailLogOut()
////                                NotificationCenter.default.post(name: NSNotification.Name("logout"), object: nil)
//                                let Appdel=UIApplication.shared.delegate as! AppDelegate
//                                let objUserRecs:UserInfoRecord = theme.GetUserDetails()
//                                let providerid = objUserRecs.providerId
//                                SocketIOManager.sharedInstance.RemoveAllListener()
//                                SocketIOManager.sharedInstance.LeaveRoom(providerid as String)
//                                SocketIOManager.sharedInstance.LeaveChatRoom(providerid as String)
//                                let dic: NSDictionary = NSDictionary()
//                                theme.saveUserDetail(dic)
//                                let loginController = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitialVCSID") as! InitialViewController
//                                //or the homeController
//                                let navController = UINavigationController(rootViewController: loginController)
//                                Appdel.window!.rootViewController! = navController
//                                loginController.navigationController!.setNavigationBarHidden(true, animated: true)
//                            })
//                            alertView.show()
//                        } else {
//                            print("the dictionary is \(param)....\(url)...\(Dictionay ?? [:])")
//                            completionHandler(Dictionay as NSDictionary?, response.result.error as NSError? )
//                        }
//                    }
//
//                    catch let error as NSError {
//                        print("the dictionary is \(param)....\(url)...\(Dictionay ?? [:])")
//                        Dictionay=nil
//                        completionHandler(Dictionay as NSDictionary?, error )
//                        print("A JSON parsing error occurred, here are the details:\n \(error)")
//                    }
//                    Dictionay=nil
//            }
                    
            
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kNoNetwork), object: nil)
        }
    }
    
    
    
    func makeGetCall(_ url: NSString, completionHandler: @escaping (_ responseObject: NSDictionary? ) -> ())
    {
        Alamofire.request("\(url)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            if(response.result.error == nil)
            {
                
                do {
                    
                    let Dictionary = try JSONSerialization.jsonObject(
                        with: response.data!,
                        
                        options: JSONSerialization.ReadingOptions.mutableContainers
                        
                        ) as? NSDictionary
                    
                    completionHandler(Dictionary as NSDictionary?)

                    
                }
                catch let error as NSError {
                    
                    // Catch fires here, with an NSErrro being thrown from the JSONObjectWithData method
                    print("A JSON parsing error occurred, here are the details:\n \(error)")
                    completionHandler(nil)
                }
            }
        }
    }
    
    
    //MARK: -  New Api Call Method
    
    func makeNewApiCall(_ url: String,param:NSDictionary, completionHandler: @escaping (_ responseObject: NSDictionary?,_ error:NSError?  ) -> ())
    {
        var user_id:String=""
       
        if(theme.isUserLigin()){
            let objUserRecs:UserInfoRecord=theme.GetUserDetails()
            print("the objUserRecs is \(objUserRecs)")
            print("the objUserRecs.providerId is \(objUserRecs.providerId)")
            user_id=objUserRecs.providerId
        }
        if isConnectedToNetwork() == true {
            let manager = Alamofire.SessionManager.default
            manager.session.configuration.timeoutIntervalForRequest = 120
            Alamofire.request("\(url)", method: .post, parameters: param as? Parameters, encoding: JSONEncoding.default, headers: ["devicetype": "ios", "device":"\(theme.GetDeviceToken())", "user":"\(user_id)" , "type":"tasker"])
                .responseJSON { response in
                    do {
                        Dictionay = try JSONSerialization.jsonObject(
                            with: response.data!,
                            
                            options: JSONSerialization.ReadingOptions.mutableContainers
                            
                            ) as? NSDictionary
                        let status:NSString?=Dictionay.object(forKey: "status") as? NSString
                        if(status == "5")
                        {
                            let alertView = UNAlertView(title: ProductAppName, message: "\(Language_handler.VJLocalizedString("log_out1", comment: nil))\n \(Language_handler.VJLocalizedString("log_out2", comment: nil))")
                            alertView.addButton(kOk, action: {
                                let dict: [AnyHashable: Any] = [NSObject : AnyObject]()
                                theme.saveUserDetail(dict as NSDictionary)
//                                let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
//                                appDelegate.setInitailLogOut()
//                                NotificationCenter.default.post(name: NSNotification.Name("logout"), object: nil)
                                let Appdel=UIApplication.shared.delegate as! AppDelegate
                                let objUserRecs:UserInfoRecord = theme.GetUserDetails()
                                let providerid = objUserRecs.providerId
                                SocketIOManager.sharedInstance.RemoveAllListener()
                                SocketIOManager.sharedInstance.LeaveRoom(providerid as String)
                                SocketIOManager.sharedInstance.LeaveChatRoom(providerid as String)
                                let dic: NSDictionary = NSDictionary()
                                theme.saveUserDetail(dic)
                                let loginController = UIStoryboard.init(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "InitialVCSID") as! InitialViewController
                                //or the homeController
                                let navController = UINavigationController(rootViewController: loginController)
                                Appdel.window!.rootViewController! = navController
                                loginController.navigationController!.setNavigationBarHidden(true, animated: true)
                            })
                            alertView.show()
                        } else {
                            print("the dictionary is \(param)....\(url)...\(Dictionay ?? [:])")
                            completionHandler(Dictionay as NSDictionary?, response.result.error as NSError? )
                        }
                    }
                        
                    catch let error as NSError {
                        print("the dictionary is \(param)....\(url)...\(Dictionay ?? [:])")
                        Dictionay=nil
                        completionHandler(Dictionay as NSDictionary?, error )
                        print("A JSON parsing error occurred, here are the details:\n \(error)")
                    }
                    Dictionay=nil
            }
                    
            
        } else {
            NotificationCenter.default.post(name: Notification.Name(rawValue: kNoNetwork), object: nil)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
