//
//  CategoryList.swift
//  PlumberJJ
//
//  Created by casperon_macmini on 30/05/17.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class CategoryList: NSObject {
    var categoryName:String = ""
    var category_ID:String = ""
    
    init(categoryName:String,category_ID:String){
        self.categoryName = categoryName
        self.category_ID = category_ID
    }

}
class CategoryExperience: NSObject {
    var experience_Lvl:String = ""
    var experience_ID:String = ""
    
    init(experience_Lvl:String,experience_ID:String){
        self.experience_Lvl = experience_Lvl
        self.experience_ID = experience_ID
    }
    
}
class EditCategoryDetails:NSObject{
    var experience_Lvl:String = ""
    var subCat_ID:String = ""
    var subCat_Name:String = ""
    var rate_Type:String = ""
    var experience_ID:String = ""
    var expereince_Name:String = ""
    var hour_Rate:String = ""
    var min_Rate:String = ""
    var mainCat_ID:String = ""
    var mainCat_Name:String = ""
    var quickPinch:String = ""
    
    init(experience_Lvl:String,subCat_ID:String,subCat_Name:String,experience_ID:String,expereince_Name:String,hour_Rate:String,min_Rate:String,mainCat_ID:String,mainCat_Name:String,quickPinch:String,ratetype:String){
        self.experience_Lvl = experience_Lvl
        self.subCat_ID = subCat_ID
        self.subCat_Name = subCat_Name
        self.experience_ID = experience_ID
        self.expereince_Name = expereince_Name
        self.hour_Rate = hour_Rate
        self.min_Rate = min_Rate
        self.mainCat_ID = mainCat_ID
        self.mainCat_Name = mainCat_Name
        self.quickPinch = quickPinch
        self.rate_Type = ratetype
    }
}
