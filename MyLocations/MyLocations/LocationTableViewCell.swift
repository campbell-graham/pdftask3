//
//  LocationTableViewCell.swift
//  MyLocations
//
//  Created by Campbell Graham on 16/2/18.
//  Copyright © 2018 someIndustry. All rights reserved.
//

import UIKit

class LocationTableViewCell: UITableViewCell {
    
    var locationImageView = UIImageView()
    var locationDescriptionLabel = UILabel()
    var locationCategoryLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = AppColors.cellBackgroundColor
        locationDescriptionLabel.textColor = AppColors.textColor
        locationCategoryLabel.textColor = AppColors.textColor
    
        addSubview(locationImageView)
        addSubview(locationDescriptionLabel)
        addSubview(locationCategoryLabel)
        
        locationImageView.translatesAutoresizingMaskIntoConstraints = false
        locationDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        locationCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            locationImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            locationImageView.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            locationImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            locationImageView.widthAnchor.constraint(equalToConstant: 52),
            locationImageView.heightAnchor.constraint(equalToConstant: 52),
            locationDescriptionLabel.leftAnchor.constraint(equalTo: locationImageView.rightAnchor, constant: 10),
            locationDescriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            locationDescriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            locationCategoryLabel.leftAnchor.constraint(equalTo: locationImageView.rightAnchor, constant: 10),
            locationCategoryLabel.topAnchor.constraint(equalTo: locationDescriptionLabel.bottomAnchor, constant: 10),
            locationCategoryLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            locationCategoryLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10)
            ])
        
        locationDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 16)
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
