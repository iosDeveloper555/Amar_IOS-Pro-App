//
//  AvailablityViewController.swift
//  PlumberJJ
//
//  Created by GokulMacMini on 18/09/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

protocol SelectedSlotDetailsDelegate {
    func SelectedStols(SlotRec:AvailableRec , at index:Int , status:String)
}

class AvailablityViewController: UIViewController {
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var doneBtn: UIButton!
    @IBOutlet weak var HeaderLbl: UILabel!
    @IBOutlet weak var SubHeaderLbl: UILabel!
    @IBOutlet weak var SelectLbl: UILabel!
    @IBOutlet weak var checkBtn: UIButton!
    @IBOutlet weak var orLbl: UILabel!
    @IBOutlet weak var availablityCollectionView: UICollectionView!
    @IBOutlet weak var CollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var OrView : UIView!
    
    @IBOutlet weak var WholeDayView: UIView!
    let theme = Theme()
    var selectedDayRec = AvailableRec()
    var Delegate : SelectedSlotDetailsDelegate?
    var SelectedDateindex = Int()
    var isWholeSelected = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
      self.HeaderLbl.text = selectedDayRec.day
      SubHeaderLbl.text = self.theme.setLang("Select_Hrs")
      doneBtn.setTitle(self.theme.setLang("save"), for: .normal)
      WholeDayView.layer.cornerRadius = 5
      checkBtn.layer.cornerRadius = checkBtn.frame.width/2
      WholeDayView.dropShadow(shadowRadius: 5)
      SelectLbl.text = self.theme.setLang("Whole_day")
      self.isWholeSelected = selectedDayRec.wholeday!
      let SlotSelectedArray = selectedDayRec.SlotArray.filter{($0.selected == true)}
        if selectedDayRec.wholeday == true{
            checkBtn.backgroundColor = PlumberThemeColor
            checkBtn.isSelected = true
            selectedDayRec.SlotArray.forEach{($0.selected = true)}
            availablityCollectionView.isHidden = true
            self.OrView.isHidden = true
        }else if selectedDayRec.wholeday == false , SlotSelectedArray.count == 0{
            checkBtn.backgroundColor = .gray
            checkBtn.isSelected = false
            selectedDayRec.SlotArray.forEach{($0.selected = false)}
            availablityCollectionView.isHidden = false
            self.OrView.isHidden = false
        }
        let layout = availablityCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 5
    }
    @IBAction func didclickBackBtn(_ sender: Any) {
        selectedDayRec.SlotArray.forEach{($0.selected = false)}
        selectedDayRec.selected = false
        selectedDayRec.wholeday = false
        self.Delegate?.SelectedStols(SlotRec: selectedDayRec, at: SelectedDateindex, status: "BACK")
        availablityCollectionView.reloadData()
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    @IBAction func didclickDoneBtn(_ sender: Any){
        selectedDayRec.wholeday = isWholeSelected
        let SlotSelectedArray = selectedDayRec.SlotArray.filter{($0.selected == true)}
        if selectedDayRec.wholeday == true || SlotSelectedArray.count > 0 {
            selectedDayRec.selected = true
        }else{
            selectedDayRec.selected = false
        }
        self.Delegate?.SelectedStols(SlotRec: selectedDayRec, at: SelectedDateindex, status: "SAVE")
        self.navigationController?.popViewControllerwithFade(animated: false)
    }
    @IBAction func didclickWholeDayBtn(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        isWholeSelected = sender.isSelected
        if isWholeSelected == true{
            selectedDayRec.SlotArray.forEach{($0.selected = true)}
            availablityCollectionView.isHidden = true
            self.OrView.isHidden = true
        }else{
            selectedDayRec.SlotArray.forEach{($0.selected = false)}
            availablityCollectionView.isHidden = false
            self.OrView.isHidden = false
        }
        checkBtn.backgroundColor = isWholeSelected ? PlumberThemeColor : .gray
        availablityCollectionView.reloadData()
    }
}

extension AvailablityViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedDayRec.SlotArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let Cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvailCell", for: indexPath) as! AvailablityCollectionCell
        guard selectedDayRec.SlotArray.count > indexPath.row else{return Cell}
        Cell.TimeIntervalLabel.text = selectedDayRec.SlotArray[indexPath.row].TimeInterval
        Cell.cellSlotData = selectedDayRec.SlotArray[indexPath.row]
        return Cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        CollectionViewHeight.constant = availablityCollectionView.contentSize.height
        availablityCollectionView.layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let padding: CGFloat =  5
        let collectionViewSize = availablityCollectionView.frame.size.width - padding
        return CGSize(width: collectionViewSize/3,height: collectionViewSize/3)
    }
}
