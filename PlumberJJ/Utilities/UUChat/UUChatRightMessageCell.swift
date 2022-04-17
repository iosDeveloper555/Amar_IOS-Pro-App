//
//  UUChatRightMessageCell.swift
//  UUChatTableViewSwift
//
//  Created by XcodeYang on 8/13/15.
//  Copyright © 2015 XcodeYang. All rights reserved.
//

import UIKit

class UUChatRightMessageCell: UITableViewCell {

    internal var dateLabel: UILabel!
    internal var headImageView: UIButton!
    internal var nameLabel: UILabel!
    internal var contentButton: UIButton!
    
    internal var contentLabel: UILabel!
    
    var imageHeightConstraint: NSLayoutConstraint!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        // 日期
        dateLabel = UILabel()
        contentView.addSubview(dateLabel)
        dateLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.footnote)
        dateLabel.textColor = UIColor.gray
        dateLabel.snp_makeConstraints { (make) -> Void in
            make.top.equalTo(contentView)
            make.centerX.equalTo(contentView)
        }
        
        // 头像
        headImageView = UIButton()
        contentView.addSubview(headImageView)
        headImageView.layer.borderWidth = 4
        headImageView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        headImageView.layer.cornerRadius = 25
        headImageView.clipsToBounds = true
        headImageView.setImage(UIImage(named: "headImage"), for: UIControl.State())
        headImageView.snp_makeConstraints { (make) -> Void in
            make.width.equalTo(50)
            make.height.equalTo(50)
            make.trailing.equalTo(-10)
            make.top.equalTo(dateLabel).offset(20)
        }
        
        // 内容frame辅助
        contentLabel = UILabel()
        contentView.addSubview(contentLabel)
        contentLabel.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        contentLabel.numberOfLines = 0
        contentLabel.textColor = UIColor.white
        contentLabel.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(-90)
            make.width.lessThanOrEqualTo(contentView).multipliedBy(0.6)
            make.top.equalTo(headImageView).offset(10)
            make.bottom.equalTo(-20).priorityLow()
        }
        
        // 内容视图
        contentButton = UIButton()
        contentView.insertSubview(contentButton, belowSubview: contentLabel)
        contentButton.imageView?.contentMode = .scaleAspectFill
        contentButton.setBackgroundImage(UIImage(named: "right_message_back"), for: UIControl.State())
        contentButton.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(contentView).offset(-70)
            make.left.equalTo(contentLabel.snp_left).offset(-10)
            make.top.equalTo(headImageView)
            make.bottom.equalTo(contentLabel.snp_bottom).offset(10)
        }
        
        // temporary method
        imageHeightConstraint = NSLayoutConstraint(
            item: contentButton,
            attribute: NSLayoutConstraint.Attribute.height,
            relatedBy: NSLayoutConstraint.Relation.lessThanOrEqual,
            toItem: nil,
            attribute: NSLayoutConstraint.Attribute.notAnAttribute,
            multiplier: 1,
            constant: 1000
        )
//        imageHeightConstraint.priority = UILayoutPriority.required
        contentButton.addConstraint(imageHeightConstraint)

    }
    
    func configUIWithModel(_ model: UUChatModel){
        dateLabel.text = model.time
        switch model.messageType {
        case UUChatMessageType.text:
            self.contentLabel.text = model.text
            break
        case .image:
            self.contentLabel.text = ""
            self.contentButton.setImage(model.image, for: UIControl.State())
            self.imageHeightConstraint.constant = UIScreen.main.bounds.size.width*0.6
            break
        case .voice:
            
            break
        default:
            break
        }
    }
}
