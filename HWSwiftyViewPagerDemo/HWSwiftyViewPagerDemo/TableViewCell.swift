//
//  TableViewCell.swift
//  HWSwiftViewPager
//
//  Created by HyunWoo Kim on 2016. 1. 11..
//  Copyright © 2016년 KokohApps. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell, UICollectionViewDataSource, HWSwiftyViewPagerDelegate {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var pager: HWSwiftyViewPager!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.pager.dataSource = self
        self.pager.pageSelectedDelegate = self
    }
    
    
    //MARK: CollectionViewDataSource
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionCell", forIndexPath: indexPath)
        return cell
    }
    
    
    //MARK: HWSwiftyViewPagerDelegate
    func pager(pager: HWSwiftyViewPager, didSelectPageAtIndex index: Int) {
        let string = "SelectedPage = \(index)"
        self.label.text = string
    }
    
    
    


}
