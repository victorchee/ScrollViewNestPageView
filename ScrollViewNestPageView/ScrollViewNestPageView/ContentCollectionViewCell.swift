//
//  ContentCollectionViewCell.swift
//  ScrollViewNestPageView
//
//  Created by Migu on 2018/9/19.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import UIKit

class ContentCollectionViewCell: UICollectionViewCell {
    var collectionViewController: CollectionViewController? {
        didSet {
            guard let view = collectionViewController?.view else { return }
            contentView.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[view]|", options: .alignAllCenterX, metrics: nil, views: ["view": view]))
            contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[view]|", options: .alignAllCenterY, metrics: nil, views: ["view": view]))
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
}
