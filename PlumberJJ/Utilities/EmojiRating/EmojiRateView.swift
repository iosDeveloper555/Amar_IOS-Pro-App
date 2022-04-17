//
//  EmojiRateView.swift
//  EmojiRating
//
//  Created by Admin on 10/16/18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol RateDelegate {
    func RateData(selectedEmoji: UIImage , selectedRate : Int)
}

class EmojiRateView: UIView {
    
    private var inActiveEmojies = [#imageLiteral(resourceName: "EterribleNotActive"),#imageLiteral(resourceName: "EbadNotActive"),#imageLiteral(resourceName: "EokNotActive"),#imageLiteral(resourceName: "EgoodNotActive"),#imageLiteral(resourceName: "EgreatNotActive")]
    private var ActiveEmojies = [#imageLiteral(resourceName: "EterribletActive"),#imageLiteral(resourceName: "EbadActive"),#imageLiteral(resourceName: "EokActive"),#imageLiteral(resourceName: "EgoodActive"),#imageLiteral(resourceName: "EgreatActive")]
    
    @IBOutlet var emojiButtons: [UIButton]!
    @IBOutlet var emojiImageView: [UIImageView]!
    
    var Delegate:RateDelegate? = nil
    private var value:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        value = 0
        //chooseEmojiAt(index: emojiImageView.count)
    }
    
    func chooseEmojiAt(index:Int){
        value = index + 1
        for i in 0...emojiImageView.count - 1 {
            if i < index  {
                emojiImageView[i].image = ActiveEmojies[i]
                //setImage(ActiveEmojies[i], for: .normal)
            }
            if i > index  {
                emojiImageView[i].image = inActiveEmojies[i]
                //setImage(inActiveEmojies[i], for: .normal)
            }
        }
        self.emojiImageView[index].image = ActiveEmojies[index]
        //setImage(ActiveEmojies[index], for: .normal)
        self.Delegate?.RateData(selectedEmoji: ActiveEmojies[index], selectedRate: value)
    }
    
    @IBAction func rateTapped(_ sender: UIButton) {
        chooseEmojiAt(index: sender.tag)
    }
}

