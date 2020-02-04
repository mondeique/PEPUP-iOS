//
//  DetailVC.swift
//  PEPUP-iOS
//
//  Created by Eren-shin on 2020/01/30.
//  Copyright © 2020 Mondeique. All rights reserved.
//

import UIKit
import Alamofire

class DetailVC: UIViewController{
    
    var productDatas = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
        getData()

    }
    func setup() {
        view.backgroundColor = .white
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y: 120, width: screenWidth, height: screenHeight))
        
        scrollView.addSubview(labelOne)
        scrollView.addSubview(labelTwo)
        scrollView.addSubview(labelThree)
        scrollView.addSubview(labelFour)
        scrollView.addSubview(labelFive)
        
        NSLayoutConstraint(item: labelOne, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: labelOne, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: labelOne, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: labelOne, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        NSLayoutConstraint(item: labelTwo, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: labelTwo, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: labelTwo, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 100).isActive = true
        NSLayoutConstraint(item: labelTwo, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        NSLayoutConstraint(item: labelThree, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: labelThree, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: labelThree, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: labelThree, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        NSLayoutConstraint(item: labelFour, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: labelFour, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: labelFour, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 500).isActive = true
        NSLayoutConstraint(item: labelFour, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true
        
        NSLayoutConstraint(item: labelFive, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leadingMargin, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: labelFive, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200).isActive = true
        NSLayoutConstraint(item: labelFive, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .topMargin, multiplier: 1, constant: 1500).isActive = true
        NSLayoutConstraint(item: labelFive, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30).isActive = true

        scrollView.contentSize = CGSize(width: screenWidth, height: 2000)
        view.addSubview(scrollView)
    }
    
    let labelOne: UILabel = {
        let label = UILabel()
        label.text = "Scroll Top"
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let labelTwo: UILabel = {
        let label = UILabel()
        label.text = "Scroll Middle 1"
        label.backgroundColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelThree: UILabel = {
        let label = UILabel()
        label.text = "Scroll Middle 2"
        label.backgroundColor = .green
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelFour: UILabel = {
        let label = UILabel()
        label.text = "Scroll Middle 3"
        label.backgroundColor = .blue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let labelFive: UILabel = {
        let label = UILabel()
        label.text = "Scroll Bottom"
        label.backgroundColor = .purple
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func getData() {
        Alamofire.AF.request("http://mypepup.com/api/products/5/", method: .get, parameters: [:], encoding: URLEncoding.default, headers: ["Content-Type":"application/json", "Accept":"application/json",  "Authorization": UserDefaults.standard.object(forKey: "token") as! String]) .validate(statusCode: 200..<300) .responseJSON {
            (response) in switch response.result {
            case .success(let JSON):
                print("Success with JSON: \(JSON)")
                let response = JSON as! NSDictionary
                self.productDatas = response
                
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}

