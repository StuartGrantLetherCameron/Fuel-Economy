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
    var date: String
    var km: String
    var gas: String
    var econ: String
    
    init(date: String, km: String, econ: String, gas: String) {
        self.date = date
        self.km = km
        self.econ = econ
        self.gas = gas
    }
}
