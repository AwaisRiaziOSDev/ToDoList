//
//  TaskTableViewCell.swift
//  To-Do List
//
//  Created by Awais Malik on 25/01/2023.
//

import UIKit

class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblDueDate: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var object: TaskModel!{
        didSet{
            self.lblTitle.text = object.title
            self.lblDescription.text = object.description
            self.lblDueDate.text = "DueDate: \(object.dueDate)"
        }
    }

}
