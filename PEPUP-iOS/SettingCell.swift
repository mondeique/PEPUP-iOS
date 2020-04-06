//
//  SettingCell.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/03/25.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit

class SettingCell: BaseCollectionViewCell {

    override func setup() {
        backgroundColor = .white
        settingcellcontentView.addSubview(settingLabel)
        settingcellcontentView.addSubview(btnGO)
        settingcellcontentView.addSubview(btnAlert)
        settingcellcontentView.addSubview(lineLabel)
        self.addSubview(settingcellcontentView)

        settingcellcontentViewLayout()
        settingLabelLayout()
        btnGOLayout()
        btnAlertLayout()
        lineLabelLayout()
        
    }
    
    @objc func switchonoff() {
        if btnAlert.isOn == true {
            print("true")
        }
        else {
            print("false")
        }
    }
    
    let settingcellcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let settingLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()

    let btnGO: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "btnGO"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let lineLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor(rgb: 0xEBEBF6)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let btnAlert : UISwitch = {
        let btn = UISwitch()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.isOn = false
        btn.isHidden = true
        btn.isEnabled = true
        btn.addTarget(self, action: #selector(switchonoff), for: .touchUpInside)
        return btn
    }()

    func settingcellcontentViewLayout() {
        settingcellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        settingcellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        settingcellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        settingcellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func settingLabelLayout() {
        settingLabel.leftAnchor.constraint(equalTo:settingcellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 18).isActive = true
        settingLabel.topAnchor.constraint(equalTo:settingcellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 18).isActive = true
        settingLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 20).isActive = true
        settingLabel.centerYAnchor.constraint(equalTo:settingcellcontentView.centerYAnchor).isActive = true
    }
    
    func btnGOLayout() {
        btnGO.rightAnchor.constraint(equalTo:settingcellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
        btnGO.topAnchor.constraint(equalTo:settingcellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 20).isActive = true
        btnGO.centerYAnchor.constraint(equalTo:settingcellcontentView.centerYAnchor).isActive = true
        btnGO.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 10).isActive = true
        btnGO.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
    func btnAlertLayout() {
        btnAlert.rightAnchor.constraint(equalTo:settingcellcontentView.rightAnchor, constant: UIScreen.main.bounds.width/375 * -18).isActive = true
//        btnAlert.topAnchor.constraint(equalTo:settingcellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 20).isActive = true
        btnAlert.centerYAnchor.constraint(equalTo:settingcellcontentView.centerYAnchor).isActive = true
//        btnAlert.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 10).isActive = true
//        btnAlert.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 16).isActive = true
    }
    
    func lineLabelLayout() {
        lineLabel.bottomAnchor.constraint(equalTo:settingcellcontentView.bottomAnchor).isActive = true
        lineLabel.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        lineLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/667 * 1).isActive = true
    }
}

class SettingHeaderCell: BaseCollectionViewCell {

    override func setup() {
        backgroundColor = .white
        settingheadercellcontentView.addSubview(settingheaderLabel)
        self.addSubview(settingheadercellcontentView)

        settingheadercellcontentViewLayout()
        settingheaderLabelLayout()
    }
    
    let settingheadercellcontentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()

    let settingheaderLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.backgroundColor = .white
        label.textAlignment = .left
        return label
    }()

    func settingheadercellcontentViewLayout() {
        settingheadercellcontentView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        settingheadercellcontentView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        settingheadercellcontentView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        settingheadercellcontentView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }

    func settingheaderLabelLayout() {
        settingheaderLabel.leftAnchor.constraint(equalTo:settingheadercellcontentView.leftAnchor, constant: UIScreen.main.bounds.width/375 * 14).isActive = true
        settingheaderLabel.topAnchor.constraint(equalTo:settingheadercellcontentView.topAnchor, constant: UIScreen.main.bounds.height/667 * 30).isActive = true
        settingheaderLabel.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/375 * 19).isActive = true
    }
}
