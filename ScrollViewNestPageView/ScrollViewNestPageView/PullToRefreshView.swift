//
//  PullToRefreshView.swift
//  ScrollViewNestPageView
//
//  Created by Migu on 2018/9/19.
//  Copyright © 2018年 VIctorChee. All rights reserved.
//

import UIKit

class PullToRefreshView: UIView {
    enum RefreshState {
        case normal
        case pulling
        case refreshing
        case willRefresh
    }
    
    @IBOutlet weak var activityIndicatoryView: UIActivityIndicatorView!
    @IBOutlet weak var label: UILabel!
    
    var state: RefreshState = .normal {
        didSet {
            switch state {
            case .normal:
                activityIndicatoryView.stopAnimating()
                label.text = "下拉刷新"
            case .pulling:
                activityIndicatoryView.stopAnimating()
                label.text = "继续下拉"
            case .refreshing:
                activityIndicatoryView.startAnimating()
                label.text = "刷新中"
            case .willRefresh:
                activityIndicatoryView.startAnimating()
                label.text = "松手刷新"
            }
        }
    }
    var refreshHeandler:((PullToRefreshView) -> Void)?
    var isAnimating = false
    private var scrollView: UIScrollView?
    
    func beginRefreshing() {
        state = .refreshing
        UIView.animate(withDuration: 0.25, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            guard let scrollView = self.scrollView else { return }
            var insets = scrollView.adjustedContentInset
            insets.top = self.frame.height
            self.scrollView?.contentInset = insets
            self.scrollView?.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: -insets.top)
        }) { (_) in
            self.refreshHeandler?(self)
        }
    }

    func endRefreshing() {
        if state != .refreshing { return }
        state = .normal
        
        UIView.animate(withDuration: 0.25, delay: 0, options: [.allowUserInteraction, .curveEaseInOut], animations: {
            guard let scrollView = self.scrollView else { return }
            var insets = scrollView.adjustedContentInset
            insets.top -= self.frame.height
            self.scrollView?.contentInset = insets
            self.scrollView?.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: -insets.top)
        }) { (_) in
            
        }
    }
    
    private func addObservers() {
        superview?.addObserver(self, forKeyPath: "contentOffset", options: [.old, .new], context: nil)
//        superview?.addObserver(self, forKeyPath: "contentInset", options: [.old, .new], context: nil)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let view = newSuperview as? UIScrollView else { return }
        self.scrollView = view
        addObservers()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            guard let offset = change?[NSKeyValueChangeKey.newKey] as? CGPoint else { return }
            var moveOffsetY = offset.y
            if moveOffsetY > 0 { return }
            moveOffsetY = -moveOffsetY
            if scrollView?.isDragging == true {
                // Pull
                if state == .refreshing { return }
                state = .pulling
                if moveOffsetY > self.frame.height {
                    state = .willRefresh
                }
            } else {
                // Release
                if state == .willRefresh {
                    beginRefreshing()
                }
            }
        }
    }
}
