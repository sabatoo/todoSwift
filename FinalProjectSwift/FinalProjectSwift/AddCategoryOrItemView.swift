//
//  Subview.swift
//  FinalProjectSwift
//
//  Created by Shaarbaf-Toosi, Saba [ITUIS] on 4/9/18.
//  Copyright © 2018 Iowa State university. All rights reserved.
//

import UIKit

class AddCategoryOrItemView: UIView {
    
    let doneButton = UIButton()
    let categoryNameLabel = UILabel()
    let categoryNameText =  UITextField()
    let cancelButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addCategorySetUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addCategorySetUp()
    {
    
        self.backgroundColor = UIColor.white
        
        categoryNameText.borderStyle = .roundedRect
        categoryNameText.placeholder = "Add an item or category"
        self.addSubview(categoryNameText)
        
        categoryNameText.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(20)
            make.height.equalTo(35)
            make.width.equalTo(200)
            make.centerX.equalTo(self)
        }

        self.addSubview(cancelButton)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.setTitleColor(UIColor.blue, for: .normal)

        cancelButton.snp.makeConstraints { (make) in
            make.top.equalTo(categoryNameText.snp.bottom).offset(8)
            make.left.equalTo(self).offset(40)
            make.right.equalTo(self).offset(-150)
        }
        
        doneButton.setTitle("Add", for: .normal)
        doneButton.setTitleColor(UIColor.blue, for: .normal)
        self.addSubview(doneButton)
        
        doneButton.snp.makeConstraints { (make) in
            make.top.equalTo(categoryNameText.snp.bottom).offset(8)
            make.right.equalTo(self).offset(-40)
            make.left.equalTo(self).offset(150)
        }
    }
}
