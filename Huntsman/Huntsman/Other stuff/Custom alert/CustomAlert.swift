//
//  CustomAlert.swift
//  ModalView
//
//  Created by Aatish Rajkarnikar on 3/20/17.
//  Copyright © 2017 Aatish. All rights reserved.
//

import UIKit

class CustomAlert: UIView, Modal {
    var backgroundView = UIView()
    var dialogView = UIView()
    
    convenience init(title:String,Message:String) {
        self.init(frame: UIScreen.main.bounds)
        initialize(title: title, Message: Message)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func initialize(title:String, Message:String ){
        
        dialogView.clipsToBounds = true
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.2
        backgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTappedOnBackgroundView)))
        addSubview(backgroundView)
        
        let dialogViewWidth = frame.width-64
        let lbl_Alert = UILabel(frame: CGRect(x: 8, y: 8, width: dialogViewWidth-16, height: 30))
        lbl_Alert.text = title
        lbl_Alert.font = UIFont.boldSystemFont(ofSize: lbl_Alert.font.pointSize)
        lbl_Alert.textAlignment = .center
        lbl_Alert.font = UIFont(name: "GillSansMT", size: 19.0)
        dialogView.addSubview(lbl_Alert)

        let titleLabel = UILabel(frame: CGRect(x: 8, y: lbl_Alert.frame.origin.y + lbl_Alert.frame.size.height, width: dialogViewWidth-16, height: 30))
        titleLabel.text = Message
        titleLabel.textColor = UIColor.darkGray
        titleLabel.textAlignment = .center
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = true
        titleLabel.font = UIFont(name: "GillSansMT", size: 16.0)
        titleLabel.sizeToFit()
        titleLabel.frame.size.width = dialogViewWidth-16
        dialogView.addSubview(titleLabel)
        
        let separatorLineView = UIView()
        separatorLineView.frame.origin = CGPoint(x: 0, y:titleLabel.frame.origin.y + titleLabel.frame.height + 8)
        separatorLineView.frame.size = CGSize(width: dialogViewWidth, height: 1)
        separatorLineView.backgroundColor = UIColor.groupTableViewBackground
        dialogView.addSubview(separatorLineView)
        
        let dialogViewHeight = titleLabel.frame.origin.y + titleLabel.frame.height + 8 + separatorLineView.frame.height + 10
        
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogViewHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 10
        addSubview(dialogView)
        let deadlineTime = DispatchTime.now() + .seconds(1) + .milliseconds(15)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.didTappedOnBackgroundView()
        })

    }
    
    @objc func didTappedOnBackgroundView(){
        dismiss(animated: true)
    }
    
}
