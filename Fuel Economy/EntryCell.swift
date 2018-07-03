//
//  EntryCell.swift
//  Fuel Economy
//
//  Created by Stuart Cameron on 2018-07-03.
//  Copyright © 2018 Stuart Cameron. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    @IBOutlet weak var gasImg: UIImageView!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var km: UILabel!
    @IBOutlet weak var gas: UILabel!
    
    func setRow(row: RowObj) {
        gasImg.image = row.image
        date.text = row.date
        km.text = row.km
        gas.text = row.gas
    }
    
}
