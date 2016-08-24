//
//  ViewController.swift
//  HWSwiftyViewPagerDemo
//
//  Created by HyunWoo Kim on 2016. 1. 19..
//  Copyright © 2016년 KokohApps. All rights reserved.
//

import UIKit

class ProgrammaticViewController: UIViewController {
    
    private lazy var viewPager: HWSwiftyViewPager = {
        let vp = HWSwiftyViewPager(frame: self.view.frame, itemSize: CGSize(width: 356.5, height: 314))
        vp.dataSource = self
        vp.pageSelectedDelegate = self
        vp.registerNib(UINib(nibName: "ViewPagerCell", bundle: nil), forCellWithReuseIdentifier: "ViewPagerCell")
        vp.backgroundColor = .grayColor()
        return vp
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        func setupView() {
            view.backgroundColor = .grayColor()
            view.addSubview(viewPager)
        }
        setupView()
    }


    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        func addConstraints() {
            viewPager.boundInside(view, inset: UIEdgeInsets(top: 84, left: 0, bottom: 115, right: 0))
        }
        
        addConstraints()
    }

}

extension ProgrammaticViewController: UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ViewPagerCell", forIndexPath: indexPath)
        return cell
    }

}

extension ProgrammaticViewController: HWSwiftyViewPagerDelegate {
    
    func pager(pager: HWSwiftyViewPager, didSelectPageAtIndex index: Int) {
        print(#function, index)
    }

}






















private extension UIView {
    func boundInside(superView: UIView, inset: UIEdgeInsets? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = false
        
        superView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-\(inset?.left ?? 0)-[subview]-\(inset?.right ?? 0)-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics:nil, views:["subview":self]))
        superView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-\(inset?.top ?? 0)-[subview]-\(inset?.bottom ?? 0)-|", options: NSLayoutFormatOptions.DirectionLeadingToTrailing, metrics:nil, views:["subview":self]))
    }
}