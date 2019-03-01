//
//  TableViewCell.swift
//  MeetUp
//
//  Created by Student 06 on 01/03/19.
//  Copyright © 2019 Student 06. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet var descriptionlabel: UILabel!
    @IBOutlet var memberslabel: UILabel!
    @IBOutlet var namelabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
