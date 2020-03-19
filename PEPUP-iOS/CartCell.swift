//
//  CartCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/02/13.
//  Copyright © 2020 Mondeique. All rights reserved.
//

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
    
    
    override func setup() {
        backgroundColor = .white
        cartcellContentView.addSubview(productImage)
        cartcellContentView.addSubview(productNameLabel)
        cartcellContentView.addSubview(productSizeLabel)
        cartcellContentView.addSubview(productPriceLabel)
        self.addSubview(cartcellContentView)
        self.insertSubview(deleteLabel, belowSubview: cartcellContentView)

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
            self.cartcellContentView.frame = CGRect(x: p.x, y: 0, width: width, height: height);
            self.deleteLabel.frame = CGRect(x: p.x + width + deleteLabel.frame.width, y: 0, width: 100, height: height)
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
    
    let cartcellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let deleteLabel: UILabel = {
        let label = UILabel()
        label.text = "delete"
        label.textColor = .black
        label.backgroundColor = .red
        return label
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
        productImage.topAnchor.constraint(equalTo:cartcellContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 10).isActive = true
        productImage.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 80).isActive = true
        productImage.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 80).isActive = true
    }

    func productNameLabelLayout() {
        productNameLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 16).isActive = true
        productNameLabel.topAnchor.constraint(equalTo:cartcellContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 10).isActive = true
        productNameLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 150).isActive = true
//        productNameLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productSizeLabelLayout() {
        productSizeLabel.leftAnchor.constraint(equalTo:productImage.rightAnchor, constant:UIScreen.main.bounds.width/375 * 16).isActive = true
        productSizeLabel.topAnchor.constraint(equalTo:productNameLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 4).isActive = true
//        productSizeLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productSizeLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productPriceLabelLayout() {
        productPriceLabel.rightAnchor.constraint(equalTo:cartcellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productPriceLabel.topAnchor.constraint(equalTo:cartcellContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 10).isActive = true
//        productPriceLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productPriceLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }
}

class CartHeaderCell: BaseCollectionViewCell {
    
    override func setup() {
        backgroundColor = .white
        cartheadercellContentView.addSubview(btnsellerProfile)
        cartheadercellContentView.addSubview(btnsellerName)
        self.addSubview(cartheadercellContentView)

        cartheadercellContentViewLayout()
        btnsellerProfileLayout()
        btnsellerNameLayout()
    }
    
    let cartheadercellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let btnsellerProfile:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    let btnsellerName: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        btn.setTitleColor(.black, for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    func cartheadercellContentViewLayout() {
        cartheadercellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cartheadercellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cartheadercellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cartheadercellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func btnsellerProfileLayout() {
        btnsellerProfile.leftAnchor.constraint(equalTo:cartheadercellContentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        btnsellerProfile.topAnchor.constraint(equalTo:cartheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 6).isActive = true
        btnsellerProfile.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 44).isActive = true
        btnsellerProfile.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 44).isActive = true
        btnsellerProfile.centerYAnchor.constraint(equalTo:cartheadercellContentView.centerYAnchor).isActive = true
    }
    
    func btnsellerNameLayout() {
        btnsellerName.leftAnchor.constraint(equalTo:btnsellerProfile.rightAnchor, constant: UIScreen.main.bounds.width/375 * 14).isActive = true
        btnsellerName.topAnchor.constraint(equalTo:cartheadercellContentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 19).isActive = true
        btnsellerName.centerYAnchor.constraint(equalTo:cartheadercellContentView.centerYAnchor).isActive = true
    }
}

class CartFooterCell: BaseCollectionViewCell {
    
    override func setup() {
        backgroundColor = .white
        cartfootercellContentView.addSubview(lineLabel)
        cartfootercellContentView.addSubview(productpriceLabel)
        cartfootercellContentView.addSubview(productpriceInfoLabel)
        cartfootercellContentView.addSubview(productdeliveryLabel)
        cartfootercellContentView.addSubview(productdeliveryInfoLabel)
        cartfootercellContentView.addSubview(btnPayment)
        cartfootercellContentView.addSubview(spaceLabel)
        self.addSubview(cartfootercellContentView)

        cartfootercellContentViewLayout()
        lineLabelLayout()
        productpriceLabelLayout()
        productpriceInfoLabelLayout()
        productdeliveryLabelLayout()
        productdeliveryInfoLabelLayout()
        btnPaymentLayout()
        spaceLabelLayout()
    }
    
    let cartfootercellContentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    
    let lineLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let productpriceLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "상품금액"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let productpriceInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let productdeliveryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.text = "배송비"
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let productdeliveryInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.backgroundColor = .white
        return label
    }()

    let btnPayment: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.titleLabel?.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 17)
        btn.layer.borderColor = UIColor.black.cgColor
        btn.layer.borderWidth = 1.5
        btn.setTitleColor(.black, for: .normal)
        btn.clipsToBounds = true
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let spaceLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xF4F5FC)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    func cartfootercellContentViewLayout() {
        cartfootercellContentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        cartfootercellContentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cartfootercellContentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        cartfootercellContentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func lineLabelLayout() {
        lineLabel.leftAnchor.constraint(equalTo:cartfootercellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        lineLabel.topAnchor.constraint(equalTo:cartfootercellContentView.topAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 339).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant:1).isActive = true
        lineLabel.centerXAnchor.constraint(equalTo:cartfootercellContentView.centerXAnchor).isActive = true
    }

    func productpriceLabelLayout() {
        productpriceLabel.leftAnchor.constraint(equalTo:cartfootercellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        productpriceLabel.topAnchor.constraint(equalTo:cartfootercellContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 20).isActive = true
//        productpriceLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productpriceLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productpriceInfoLabelLayout() {
        productpriceInfoLabel.rightAnchor.constraint(equalTo:cartfootercellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productpriceInfoLabel.topAnchor.constraint(equalTo:cartfootercellContentView.topAnchor, constant:UIScreen.main.bounds.height/667 * 20).isActive = true
//        productpriceInfoLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productpriceInfoLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productdeliveryLabelLayout() {
        productdeliveryLabel.leftAnchor.constraint(equalTo:cartfootercellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        productdeliveryLabel.topAnchor.constraint(equalTo:productpriceLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 10).isActive = true
//        productdeliveryLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productdeliveryLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func productdeliveryInfoLabelLayout() {
        productdeliveryInfoLabel.rightAnchor.constraint(equalTo:cartfootercellContentView.rightAnchor, constant:UIScreen.main.bounds.width/375 * -18).isActive = true
        productdeliveryInfoLabel.topAnchor.constraint(equalTo:productpriceInfoLabel.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 10).isActive = true
//        productdeliveryInfoLabel.widthAnchor.constraint(equalToConstant:80).isActive = true
//        productdeliveryInfoLabel.heightAnchor.constraint(equalToConstant:80).isActive = true
    }

    func btnPaymentLayout() {
        btnPayment.leftAnchor.constraint(equalTo:cartfootercellContentView.leftAnchor, constant:UIScreen.main.bounds.width/375 * 18).isActive = true
        btnPayment.topAnchor.constraint(equalTo:productdeliveryLabel.bottomAnchor, constant:24).isActive = true
        btnPayment.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width/375 * 339).isActive = true
        btnPayment.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 48).isActive = true
        btnPayment.centerXAnchor.constraint(equalTo:cartfootercellContentView.centerXAnchor).isActive = true
    }
    
    func spaceLabelLayout() {
        spaceLabel.leftAnchor.constraint(equalTo:cartfootercellContentView.leftAnchor).isActive = true
        spaceLabel.topAnchor.constraint(equalTo:btnPayment.bottomAnchor, constant:UIScreen.main.bounds.height/667 * 16).isActive = true
        spaceLabel.widthAnchor.constraint(equalToConstant:UIScreen.main.bounds.width).isActive = true
        spaceLabel.heightAnchor.constraint(equalToConstant:UIScreen.main.bounds.height/667 * 8).isActive = true
    }
}
