//
//  AvailCollectionView.swift
//  PlumberJJ
//
//  Created by CasperonIOS on 6/27/19.
//  Copyright © 2019 Casperon Technologies. All rights reserved.
//

import UIKit

class AvailCollectionView : CSAnimationView {
    
    @IBOutlet weak var HeaderView: UIView!
    @IBOutlet weak var SubHeaderView: UIView!
    @IBOutlet weak var OptionsView: UIView!
    @IBOutlet weak var WholedayView: UIView!
    @IBOutlet weak var OrView: UIView!
    @IBOutlet weak var AvailablityCOllectionView: UICollectionView!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var AvailLbl: UILabel!
    @IBOutlet weak var SubHeaderLbl: UILabel!
    @IBOutlet weak var OrLbl: UILabel!
    @IBOutlet weak var OptiosTitleLbl: UILabel!
    @IBOutlet weak var WholeDayCheckBtn: UIButton!
    @IBOutlet weak var ScrollView: UIScrollView!
    
    @IBOutlet weak var InnerScrollView: UIView!
    @IBOutlet weak var BackButtonView: UIView!
    @IBOutlet weak var HeaderViewHeight: NSLayoutConstraint!
    @IBOutlet weak var SubHeaderHeight: NSLayoutConstraint!
    @IBOutlet weak var OptionsVIewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var CollectionViewHeight: NSLayoutConstraint!

}
