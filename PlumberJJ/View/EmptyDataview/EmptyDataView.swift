//
//  EmptyDataView.swift
//  PlumberJJ
//
//  Created by Casperonios on 31/12/18.
//  Copyright © 2018 Casperon Technologies. All rights reserved.
//

import UIKit

class EmptyDataView: UIView {

    @IBOutlet weak var msgLbl: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadFromNibNamed("EmptyDataView")
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    
    func loadFromNibNamed(_ nibNamed: String, bundle : Bundle? = nil) -> UIView? {
        
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiate(withOwner: nil, options: nil)[0] as? UIView
    }

}
