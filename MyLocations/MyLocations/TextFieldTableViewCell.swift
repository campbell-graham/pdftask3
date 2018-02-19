//
//  TextFieldTableViewCell.swift
//  MyLocations
//
//  Created by Campbell Graham on 13/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    
    var textField: UITextField
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        textField = UITextField()
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    
        textField.textColor = AppColors.textColor
        textField.attributedPlaceholder = NSAttributedString(string: "Enter a description...",
                                                             attributes: [NSAttributedStringKey.foregroundColor: AppColors.placeholderTextColor])
        
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            textField.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            textField.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            textField.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
