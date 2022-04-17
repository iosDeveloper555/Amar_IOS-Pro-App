//
//  Country_CodeTableViewCell.swift
//  PlumberJJ
//
//  Created by Casperon iOS on 29/09/17.
//  Copyright © 2017 Casperon Technologies. All rights reserved.
//

import UIKit

class Country_CodeTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    func configureCellWith(searchTerm:String, cellText:String){
        var pattern = searchTerm.replacingOccurrences(of: " ", with: "|")
        pattern.insert("(", at: pattern.startIndex)
        pattern.insert(")", at: pattern.endIndex)
        
        do {
            let regEx = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive,
                .allowCommentsAndWhitespace])
            let range = NSRange(location: 0, length: cellText.count)
            let displayString = NSMutableAttributedString(string: cellText)
            let highlightColour = PlumberThemeColor
            
            regEx.enumerateMatches(in: cellText, options: .withTransparentBounds, range: range, using: { (result, flags, stop) in
                if result?.range != nil {
                    // displayString.setAttributes([NSBackgroundColorAttributeName:highlightColour], range: result!.range)
                }
                
            })
            
            self.textLabel?.attributedText = displayString
            
        } catch
        {
            self.textLabel?.text = cellText
        }
    }
    
    
    
    


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
