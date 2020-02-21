//
//  CartCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/13.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class CartCell: BaseCollectionViewCell, UIGestureRecognizerDelegate {
    
    var pan: UIPanGestureRecognizer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override func setup() {
        backgroundColor = .red
        cartcellContentView.addSubview(productImage)
        cartcellContentView.addSubview(productNameLabel)
        cartcellContentView.addSubview(productSizeLabel)
        cartcellContentView.addSubview(productPriceLabel)
        self.addSubview(cartcellContentView)
        self.insertSubview(deleteLabel1, belowSubview: cartcellContentView)

        cartcellContentViewLayout()
        productImageLayout()
        productNameLabelLayout()
        productSizeLabelLayout()
        productPriceLabelLayout()
        
        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if (pan.state == UIGestureRecognizer.State.changed) {
            let p: CGPoint = pan.translation(in: self)
            let width = self.cartcellContentView.frame.width
            let height = self.cartcellContentView.frame.height
            self.cartcellContentView.frame = CGRect(x: p.x, y: 0, width: width, height: height)
            self.deleteLabel1.frame = CGRect(x: p.x + width + deleteLabel1.frame.size.width, y: 0, width: 100, height: height)
        }
    }
    
    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizer.State.began {
            
        }
        else if pan.state == UIGestureRecognizer.State.changed {
            self.setNeedsLayout()
        }
        else {
            if abs(pan.velocity(in: self).x) > 500 {
                let collectionView: UICollectionView = self.superview as! UICollectionView
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
            }
            else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                })
            }
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }

    let deleteLabel1: UILabel = {
        let label = UILabel()
        label.text = "delete"
        label.textColor = UIColor.white
        return label
    }()
    
    let cartcellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let productImage: UIButton = {
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.clipsToBounds = true
        return btn
    }()

    let productNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.backgroundColor = .white
        return label
    }()

    let productSizeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let productPriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        label.backgroundColor = .white
        return label
    }()

    func cartcellContentViewLayout() {
        cartcellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cartcellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cartcellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cartcellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func productImageLayout() {
        productImage.leftAnchor.constraint(equalTo:cartcellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        productImage.topAnchor.constraint(equalTo:cartcellContentView.topAnchor, constant:10).isActive = true
        productImage.widthAnchor.constraint(equalToConstant:80).isActive = true
        productImage.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productNameLabelLayout() {
        productNameLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 16).isActive = true
        productNameLabel.topAnchor.constraint(equalTo:cartcellContentView.topAnchor, constant:10).isActive = true
//        productNameLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productNameLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productSizeLabelLayout() {
        productSizeLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 16).isActive = true
        productSizeLabel.topAnchor.constraint(equalTo:productNameLabel.bottomAnchor, constant:4).isActive = true
//        productSizeLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productSizeLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productPriceLabelLayout() {
        productPriceLabel.rightAnchor.constraint(equalTo:cartcellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productPriceLabel.topAnchor.constraint(equalTo:cartcellContentView.topAnchor, constant:10).isActive = true
//        productPriceLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productPriceLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }
}
