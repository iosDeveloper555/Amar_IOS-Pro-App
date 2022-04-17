//
//  FinalRegisterViewController.swift
//  PlumberJJ
//
//  Created by GokulMacMini on 18/09/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

protocol PassTheSelectedDatadelegate{
    func PassMainCategory(MainCat : CategoryRecord)
    func PassSubCategory(SubCat : subCategoryRecord)
}

class CatSubCatViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var HeaderLbl: UILabel!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var searchImg: UIImageView!
    @IBOutlet weak var searchTxtFld: UITextField!
    @IBOutlet weak var catTableView: UITableView!
    
    var MainCategoryArray = [CategoryRecord]()
    var SubCategoryArry = [subCategoryRecord]()
    var isfromMainCat : Bool = false
    var Delegate : PassTheSelectedDatadelegate?
    var CAtSearchArray = [CategoryRecord]()
    var SubCatSearchArray = [subCategoryRecord]()
    var isSearchAvtive = false
    let theme = Theme()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.isfromMainCat == true {
            self.HeaderLbl.text = theme.setLang("Main_Category")
        }else{
            self.HeaderLbl.text = theme.setLang("Sub_Category")
        }
     self.searchTxtFld.addTarget(self, action:#selector(searchaction(sender:)) , for:.editingChanged)
        dump(self.SubCategoryArry)
        // Do any additional setup after loading the view.
    }
    
    @objc func searchaction(sender:UITextField)
    {
        if !((sender.text?.isEmpty)!){
            if isfromMainCat == true{
//                self.CAtSearchArray = self.MainCategoryArray.filter {
//                    $0.name.range(of: sender.text!, options: .caseInsensitive) != nil
//                }
                
                self.CAtSearchArray.removeAll()
                for dict in self.MainCategoryArray
                {
                    //let dict1 = dict as! NSDictionary

                    let name =  dict.name as? String ?? ""//dict1.value(forKey: "cat_name") as? String ?? ""
                    if name.lowercased().starts(with: (sender.text ?? "").lowercased())
                    {
                        self.CAtSearchArray.append(dict)
                    }
                }
                
                
            }else{
//                self.SubCatSearchArray = self.SubCategoryArry.filter {
//                    $0.name.range(of: sender.text!, options: .caseInsensitive) != nil
//                }
                
                self.SubCatSearchArray.removeAll()
                for dict in self.SubCategoryArry
                {
                  //  let dict1 = dict as! NSDictionary

                    let name = dict.name as? String ?? ""//.value(forKey: "cat_name") as? String ?? ""
                    if name.lowercased().starts(with: (sender.text ?? "").lowercased())
                    {
                        self.SubCatSearchArray.append(dict)
                    }
                }
                
            }
            isSearchAvtive = true
        }else{
            isSearchAvtive = false
        }
        
        self.catTableView.reloadData()
    }
    
    @IBAction func didclickBackBtn(_ sender: Any) {
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    
}

extension CatSubCatViewController : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isSearchAvtive == true{
            if self.isfromMainCat == true{
                return CAtSearchArray.count
            }else{
                return SubCatSearchArray.count
            }
        }else{
            if self.isfromMainCat == true{
                return MainCategoryArray.count
            }else{
                return SubCategoryArry.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let Cell = tableView.dequeueReusableCell(withIdentifier: "CatCell", for: indexPath) as! RegPageAddCatTableViewCell
        Cell.selectionStyle = .none
        if isSearchAvtive == true{
            if isfromMainCat == true{
                let MainCategory = self.CAtSearchArray[indexPath.row]
                Cell.CatLbl.text = MainCategory.name
                Cell.catImg.sd_setImage(with: URL(string:MainCategory.image), placeholderImage: UIImage(named: "PlaceHolderSmall"))
                Cell.catImg.layer.cornerRadius = Cell.catImg.frame.height/2
                Cell.catImg.backgroundColor = PlumberThemeColor
            }else{
                let SubCategory = self.SubCatSearchArray[indexPath.row]
                dump(self.SubCategoryArry)
                Cell.CatLbl.text = SubCategory.name
                Cell.catImg.sd_setImage(with: URL(string:SubCategory.image), placeholderImage: UIImage(named: "PlaceHolderSmall"))
                Cell.catImg.layer.cornerRadius = Cell.catImg.frame.height/2
                Cell.catImg.backgroundColor = PlumberThemeColor
            }
        }else{
            if isfromMainCat == true{
                let MainCategory = self.MainCategoryArray[indexPath.row]
                dump(self.MainCategoryArray)
                Cell.CatLbl.text = MainCategory.name
                Cell.catImg.sd_setImage(with: URL(string:MainCategory.image), placeholderImage: UIImage(named: "PlaceHolderSmall"))
                Cell.catImg.layer.cornerRadius = Cell.catImg.frame.height/2
                Cell.catImg.backgroundColor = PlumberThemeColor
            }else{
                let SubCategory = self.SubCategoryArry[indexPath.row]
                dump(self.SubCategoryArry)
                Cell.CatLbl.text = SubCategory.name
                Cell.catImg.sd_setImage(with: URL(string:SubCategory.image), placeholderImage: UIImage(named: "PlaceHolderSmall"))
                Cell.catImg.layer.cornerRadius = Cell.catImg.frame.height/2
                Cell.catImg.backgroundColor = PlumberThemeColor
            }
        }
        return Cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: false)
        if isSearchAvtive == true{
            if isfromMainCat == true{
                let MainCatData = self.CAtSearchArray[indexPath.row]
                self.Delegate?.PassMainCategory(MainCat: MainCatData)
            }else{
                let SubCatData = self.SubCatSearchArray[indexPath.row]
                self.Delegate?.PassSubCategory(SubCat: SubCatData)
            }
        }else{
            if isfromMainCat == true{
                let MainCatData = self.MainCategoryArray[indexPath.row]
                self.Delegate?.PassMainCategory(MainCat: MainCatData)
            }else{
                let SubCatData = self.SubCategoryArry[indexPath.row]
                self.Delegate?.PassSubCategory(SubCat: SubCatData)
            }
        }
    }
}

