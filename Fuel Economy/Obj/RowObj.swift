//
//  RowObj.swift
//  Fuel Economy
//
//  Created by Stuart Cameron on 2018-07-03.
//  Copyright © 2018 Stuart Cameron. All rights reserved.
//

import Foundation
import UIKit

class RowObj {
    var image: UIImage
    var date: String
    var km: String
    var gas: String
    
    init(image: UIImage, date: String, km: String, gas: String) {
        self.image = image
        self.date = date
        self.km = km
        self.gas = gas
    }
}
