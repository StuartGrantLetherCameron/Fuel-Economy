//
//  ViewController.swift
//  Fuel Economy
//
//  Created by Stuart Cameron on 2018-06-19.
//  Copyright © 2018 Stuart Cameron. All rights reserved.
//

import UIKit
import SQLite3
import Charts

class ViewController: UIViewController {
    
    @IBOutlet weak var enterGas: UIButton!
    @IBOutlet weak var avg_10: UILabel!
    @IBOutlet weak var avg: UILabel!
    @IBOutlet weak var graph: LineChartView!
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let black = UIColor.black
        Functions().make_border(button: enterGas, color: black.cgColor)
        
        let dirctery = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                    appropriateFor: nil, create: false).appendingPathComponent("km_database.sqlite")
        
        if sqlite3_open(dirctery.path, &db) != SQLITE_OK{
            print("error loading db")
        }
        
        let entry = Functions().get_all_from_table(db: db!)
        
        let cor = Functions().turn_to_coordinate(list: entry)
        
        Functions().graph(lineChart: graph, cor: cor)
        
        avg.text = Functions().get_avg_km(list: cor)
        
        avg_10.text = Functions().avg_ten(list: cor)
        
    }
}

