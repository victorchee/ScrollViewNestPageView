//
//  ViewController.swift
//  ScrollViewNestPageView
//
//  Created by Migu on 2018/8/29.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var headerView: UIView!
    @IBOutlet weak var headerViewTopContstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentedBar: SegmentedBar!
    
    private var topShowingHeight: CGFloat {
        if headerView.frame.minX >= 0 {
            return segmentedBar.frame.maxY
        } else {
            return segmentedBar.frame.maxY + headerView.frame.minY
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        collectionView.contentInsetAdjustmentBehavior = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            guard let offset = change?[NSKeyValueChangeKey.newKey] as? CGPoint else { return }
            var constant = -offset.y
            if constant < -headerView.bounds.height {
                // SegmentedBar吸顶
                constant = -headerView.bounds.height
            }
            headerViewTopContstraint.constant = constant
            headerView.superview?.layoutIfNeeded()
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ContentCollectionViewCell", for: indexPath) as! ContentCollectionViewCell
        if indexPath.item == 0 {
            cell.backgroundColor = UIColor.orange
        } else if indexPath.item == 1 {
            cell.backgroundColor = UIColor.purple
        } else {
            cell.backgroundColor = UIColor.cyan
        }
        
        if let controller = cell.collectionViewController {
            controller.collectionView?.reloadData()
        } else {
            if let controller = storyboard?.instantiateViewController(withIdentifier: "CollectionViewController") as? CollectionViewController {
                cell.collectionViewController = controller
            }
        }
        cell.collectionViewController?.placeholderHeight = topShowingHeight
        cell.collectionViewController?.collectionView?.addObserver(self, forKeyPath: "contentOffset", options: [.old, .new], context: nil)
        
        return cell
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let layout = collectionViewLayout as? UICollectionViewFlowLayout else { return CGSize.zero }
        let width = collectionView.bounds.width - layout.sectionInset.left - layout.sectionInset.right - collectionView.adjustedContentInset.left - collectionView.adjustedContentInset.right
        let height = collectionView.bounds.height - layout.sectionInset.top - layout.sectionInset.bottom - collectionView.adjustedContentInset.top - collectionView.adjustedContentInset.bottom
        return CGSize(width: width, height: height)
    }
}
