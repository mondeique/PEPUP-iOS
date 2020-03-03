//
//  FollowCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class FollowCell: BaseCollectionViewCell, UIScrollViewDelegate {
    
    override func setup() {
        backgroundColor = .white
        
        self.addSubview(cellcontentView)
        
        productScrollView.addSubview(productImage)
        cellcontentView.addSubview(productScrollView)
        cellcontentView.addSubview(pageControl)
        
        cellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        productImage.leftAnchor.constraint(equalTo: productScrollView.leftAnchor).isActive = true
        productImage.topAnchor.constraint(equalTo: productScrollView.topAnchor).isActive = true
        productImage.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        productImage.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        
        pageControl.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: cellcontentView.bottomAnchor).isActive = true
        pageControl.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        pageControl.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 50).isActive = true
        
        productScrollView.leftAnchor.constraint(equalTo: cellcontentView.leftAnchor).isActive = true
        productScrollView.topAnchor.constraint(equalTo: cellcontentView.topAnchor).isActive = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        // When the number of scrolls is one page worth.
        if fmod(scrollView.contentOffset.x, scrollView.frame.maxX) == 0 {
            // Switch the location of the page.
            pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.frame.maxX)
        }
    }
    
    lazy var productScrollView : UIScrollView = {
        // Create a UIScrollView.
        let scrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width))
        
        // Hide the vertical and horizontal indicators.
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        // Allow paging.
        scrollView.isPagingEnabled = true
        
        // Set delegate of ScrollView.
        scrollView.delegate = self

        // Specify the screen size of the scroll.
        scrollView.contentSize = CGSize(width: CGFloat(5) * UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
        
        return scrollView
    }()
    
    lazy var pageControl: UIPageControl = {
        // Create a UIPageControl.
        let pageControl = UIPageControl(frame: CGRect(x: 0, y: UIScreen.main.bounds.width - 50, width: UIScreen.main.bounds.width, height: 50))
        pageControl.backgroundColor = UIColor.clear
        
        // Set the number of pages to page control.
        pageControl.numberOfPages = 5
        
        // Set the current page.
        pageControl.currentPage = 0
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        return pageControl
    }()
    
    let cellcontentView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let productImage: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
}
