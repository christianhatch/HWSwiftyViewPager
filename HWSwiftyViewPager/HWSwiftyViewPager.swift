//
//  HWSwiftyViewPager.swift
//  HWSwiftViewPager
//
//  Created by HyunWoo Kim on 2016. 1. 11..
//  Copyright © 2016년 KokohApps. All rights reserved.
//  email : hyunwoo-21@hanmail.net
//

import UIKit

public protocol HWSwiftyViewPagerDelegate {
    func pager(pager: HWSwiftyViewPager, didSelectPageAtIndex index: Int)
}


public class HWSwiftyViewPager: UICollectionView {
    
    enum PagerControlState: Int {
        case StayCurrent = 0
        case ToLeft = 1
        case ToRight = 2
    }
    
    private let VELOCITY_STANDARD: CGFloat = 0.6
    
    private var flowLayout: UICollectionViewFlowLayout!
    private var beforeFrame: CGRect!
    private var itemsTotalCount = 0
    private var selectedPageNum = 0
    private var itemWidthWithMargin: CGFloat = 0
    private var scrollBeginOffset: CGFloat = 0
    private var pagerControlState = PagerControlState.StayCurrent
    
    var pageSelectedDelegate: HWSwiftyViewPagerDelegate?
    

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    required public init(frame: CGRect, itemSize: CGSize) {
        let layout = UICollectionViewFlowLayout.viewPagerLayout(forSize: itemSize)
        super.init(frame: frame, collectionViewLayout: layout)
        commonInit(layout)
    }

}

extension HWSwiftyViewPager {
    
    private func commonInit(withLayout: UICollectionViewFlowLayout? = nil) {
        scrollEnabled = true
        pagingEnabled = false
        delegate = self
        decelerationRate = UIScrollViewDecelerationRateFast
        
        flowLayout = withLayout ?? collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.scrollDirection = .Horizontal
        showsHorizontalScrollIndicator = false
        showsVerticalScrollIndicator = false
        beforeFrame = frame
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        //현재 뷰의 프레임 크기와 이전의 프레임과 다르다면, 아이템의 크기도 함게 바꿔준다.
        if !CGRectEqualToRect(frame, beforeFrame) {
            let widthNew = frame.size.width - (flowLayout.sectionInset.left * 2) - flowLayout.minimumLineSpacing
            let heightNew = frame.size.height - flowLayout.sectionInset.top - flowLayout.sectionInset.bottom
            flowLayout.itemSize = CGSizeMake(widthNew, heightNew)
            
            beforeFrame = frame
            
            itemWidthWithMargin = widthNew + flowLayout.minimumLineSpacing
            
            //현재 선택된 페이지의 오프셋으로 이동시켜준다.
            let targetX = getOffSetFromPage(selectedPageNum, scrollView: self)
            contentOffset = CGPointMake(targetX, 0)
            layoutIfNeeded()
        }
        
    }
    
    override public func reloadData() {
        super.reloadData()
        
        itemsTotalCount = 0
        
        let sectionCount = numberOfSections()
        for section in 0..<sectionCount {
            itemsTotalCount = itemsTotalCount + dataSource!.collectionView(self, numberOfItemsInSection: section)
        }
        
        //새로 불러왔을 때, 페이지넘을 0으로, 오프셋도 0으로 이동시켜준다.
        selectedPageNum = 0
        contentOffset = CGPointMake(0, 0)
        layoutIfNeeded()
    }
}

extension HWSwiftyViewPager {
    
    public func setPage(pageNum pageNum: Int, animated: Bool) {
        if pageNum == selectedPageNum || pageNum >= itemsTotalCount {
            return
        }
        
        let offset = getOffSetFromPage(pageNum, scrollView: self)
        setContentOffset(CGPointMake(offset, 0), animated: animated)
        selectedPageNum = pageNum
        pageSelectedDelegate?.pager(self, didSelectPageAtIndex: pageNum)
    }
    
}

extension HWSwiftyViewPager: UICollectionViewDelegate {
    
    //MARK: ScrollViewDelegate
    public func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        scrollBeginOffset = scrollView.contentOffset.x
        pagerControlState = .StayCurrent
    }
    
    public func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        //타겟 포인트를 저장.
        var point = targetContentOffset.memory
        
        //벨로서티 기준에 따라서 이동 여부를 결정한다.
        if velocity.x > VELOCITY_STANDARD {
            pagerControlState = .ToRight
        }
        else if velocity.x < -VELOCITY_STANDARD {
            pagerControlState = .ToLeft
        }
        
        //총 스크롤 한 거리를 구한다.
        let scrollDistance = scrollBeginOffset - scrollView.contentOffset.x
        let standardDistance = itemWidthWithMargin / 2
        
        //컨텐츠 크기의 반만큼보다 많이 스크롤을 했다면,
        if scrollDistance < -standardDistance {
            pagerControlState = .ToRight
        }
        else if scrollDistance > standardDistance {
            pagerControlState = .ToLeft
        }
        
        //선택 페이지를 결정한다.
        if pagerControlState == .ToLeft && selectedPageNum > 0 {
            selectedPageNum -= 1
        }
        else if pagerControlState == .ToRight && selectedPageNum < (itemsTotalCount - 1) {
            selectedPageNum += 1
        }
        
        //페이지가 설정되었고, 델리게이트가 설정되었다면, 델리게이트를 호출한다.
        pageSelectedDelegate?.pager(self, didSelectPageAtIndex: selectedPageNum)
        
        point.x = getOffSetFromPage(selectedPageNum, scrollView: scrollView)
        targetContentOffset.memory = point
        
    }
    
    //페이지 번호로 offset 을 구하기.
    private func getOffSetFromPage(pageNum: Int, scrollView:UIScrollView) -> CGFloat {
        if pageNum == 0 {
            return 0
        }
        
        else if pageNum >= itemsTotalCount - 1 {
            return scrollView.contentSize.width - frame.size.width
        }
        
        return (itemWidthWithMargin * CGFloat(pageNum)) - (flowLayout.minimumLineSpacing / 2)
    }
}







private extension UICollectionViewFlowLayout {
    
    class func viewPagerLayout(forSize size: CGSize) -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        layout.itemSize = size
        return layout
    }
    
}











