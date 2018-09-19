//
//  CollectionViewController.swift
//  ScrollViewNestPageView
//
//  Created by Migu on 2018/9/19.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    var placeholderHeight: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.contentInsetAdjustmentBehavior = .never
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "PlaceholderCell")
        
        if let refreshView = Bundle.main.loadNibNamed("PullToRefreshView", owner: nil, options: nil)?.first as? PullToRefreshView {
            refreshView.frame = CGRect(x: 0, y: -130, width: view.frame.width, height: 130)
            refreshView.backgroundColor = UIColor.cyan
            refreshView.refreshHeandler = { refresh in
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    refresh.endRefreshing()
                }
            }
            collectionView?.addSubview(refreshView)
            refreshView.willMove(toSuperview: collectionView)
        }
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 20
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlaceholderCell", for: indexPath)
            cell.backgroundColor = UIColor.black
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
            cell.backgroundColor = UIColor.red
            return cell
        }
    }

    // MARK: UICollectionViewDelegate
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.frame.width, height: placeholderHeight)
        } else {
            guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
            return layout.itemSize
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets.zero
        } else {
            guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return UIEdgeInsets.zero }
            return layout.sectionInset
        }
    }
}
