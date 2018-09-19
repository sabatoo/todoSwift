//
//  TableViewCell.swift
//  FinalProjectSwift
//
//  Created by Shaarbaf-Toosi, Saba [ITUIS] on 4/10/18.
//  Copyright © 2018 Iowa State university. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell
{

    @IBOutlet weak var checkbox: VKCheckbox!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
        
        self.checkbox.line             = .thin
        self.checkbox.bgColorSelected  = UIColor(red: 46/255, green: 119/255, blue: 217/255, alpha: 1)
        self.checkbox.bgColor          = .gray
        self.checkbox.color            = .white
        self.checkbox.borderColor      = .white
        self.checkbox.borderWidth      = 2
        self.checkbox.cornerRadius     = self.checkbox.bounds.size.height / 2
    }
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
