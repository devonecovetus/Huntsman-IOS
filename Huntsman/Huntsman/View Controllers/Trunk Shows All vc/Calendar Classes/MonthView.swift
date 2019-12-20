//
//  MonthView.swift
//  myCalender2
//
//  Created by Muskan on 10/22/17.
//  Copyright © 2017 akhil. All rights reserved.
//

import UIKit

protocol MonthViewDelegate: class {
    func didChangeMonth(monthIndex: Int, year: Int)
    func didChangeMonthPrivous(monthIndex: Int, year: Int, StrFlage:NSString)
    func didChangeNext(monthIndex: Int, year: Int ,StrFlage:NSString)

}

class MonthView: UIView {
    var monthsArr = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    var currentMonthIndex = 0
    var currentYear: Int = 0
    var delegate: MonthViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        currentMonthIndex = Calendar.current.component(.month, from: Date()) - 1
        currentYear = Calendar.current.component(.year, from: Date())
        
        setupViews()
        
      //  btnLeft.isEnabled=false
    }
    
    @objc func btnLeftRightAction(sender: UIButton) {
        if sender == btnRight {
            currentMonthIndex += 1
            if currentMonthIndex > 11 {
                currentMonthIndex = 0
                currentYear += 1
            }
            delegate?.didChangeNext(monthIndex: currentMonthIndex, year: currentYear ,StrFlage:"\(monthsArr[currentMonthIndex]) \(currentYear)" as NSString)

        } else {
            currentMonthIndex -= 1
            if currentMonthIndex < 0 {
                currentMonthIndex = 11
                currentYear -= 1
            }
            delegate? .didChangeMonthPrivous(monthIndex: currentMonthIndex, year: currentYear, StrFlage:"\(monthsArr[currentMonthIndex]) \(currentYear)" as NSString)

        }
        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)".uppercased()
        let myString = "\(monthsArr[currentMonthIndex])"
        lblMiddleName.text = String(myString.prefix(3)).uppercased()
        delegate?.didChangeMonth(monthIndex: currentMonthIndex, year: currentYear)
    }
    
    func setupViews() {
        self.addSubview(lblName)
        lblName.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lblName.leftAnchor.constraint(equalTo:leftAnchor, constant: -5).isActive=true
        lblName.widthAnchor.constraint(equalToConstant: 150).isActive=true
        lblName.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
        lblName.text="\(monthsArr[currentMonthIndex]) \(currentYear)".uppercased()
        
        self.addSubview(btnLeft)
        btnLeft.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnLeft.leftAnchor.constraint(equalTo:lblName.leftAnchor , constant:CGFloat(Device.SCREEN_WIDTH - 120)).isActive = true
        btnLeft.widthAnchor.constraint(equalToConstant: 40).isActive=true
        btnLeft.heightAnchor.constraint(equalToConstant: 40).isActive=true
        
        self.addSubview(lblMiddleName)
        lblMiddleName.topAnchor.constraint(equalTo: topAnchor).isActive=true
        lblMiddleName.leftAnchor.constraint(equalTo:btnLeft.leftAnchor , constant:20).isActive = true
        lblMiddleName.widthAnchor.constraint(equalToConstant: 70).isActive=true
        lblMiddleName.heightAnchor.constraint(equalTo: heightAnchor).isActive=true
        let myString = "\(monthsArr[currentMonthIndex])"
        lblMiddleName.text = String(myString.prefix(3)).uppercased()
        
        
        self.addSubview(btnRight)
        btnRight.topAnchor.constraint(equalTo: topAnchor).isActive=true
        btnRight.rightAnchor.constraint(equalTo:lblMiddleName.rightAnchor , constant:20).isActive = true
        btnRight.widthAnchor.constraint(equalToConstant: 40).isActive=true
        btnRight.heightAnchor.constraint(equalToConstant: 40).isActive=true
    }
    
    let lblName: UILabel = {
        let lbl=UILabel()
        lbl.text="Default Month Year text"
        lbl.textColor = UIColor(red: 143/255.0, green: 0/255.0, blue: 42/255.0, alpha: 1.0)
        lbl.textAlignment = .left
        lbl.font = UIFont(name: "GillSansMT" , size: 17.0)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    
    let lblMiddleName: UILabel = {
        let lbl=UILabel()
        lbl.text="Default Month Year text"
        lbl.textColor = Style.monthViewLblColor
        lbl.textAlignment = .center
        lbl.font = UIFont(name: "GillSansMT" , size: 14.0)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let btnRight: UIButton = {
        let btn = UIButton(type: .custom)
         btn.setImage(UIImage(named:"next"), for: UIControlState.normal)
        btn.imageView?.tintColor = UIColor.black
        btn.imageView?.contentMode = .scaleToFill
        btn.setTitleColor(Style.monthViewBtnRightColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       // btn.adjustsImageSizeForAccessibilityContentSizeCategory = true
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        return btn
    }()
    
    let btnLeft: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(named:"previous"), for: .normal)
        btn.imageView?.tintColor = UIColor.black
        btn.setTitleColor(Style.monthViewBtnLeftColor, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints=false
        btn.addTarget(self, action: #selector(btnLeftRightAction(sender:)), for: .touchUpInside)
        btn.setTitleColor(UIColor.lightGray, for: .disabled)
        btn.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      //  btn.adjustsImageSizeForAccessibilityContentSizeCategory = true
        return btn
    }()
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
