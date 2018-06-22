//
//  GasEntry.swift
//  Fuel Economy
//
//  Created by Stuart Cameron on 2018-06-21.
//  Copyright © 2018 Stuart Cameron. All rights reserved.
//

import UIKit
import SQLite3

class GasEntry: UIViewController {

    @IBOutlet weak var km_Input: UITextField!
    @IBOutlet weak var gas_Input: UITextField!
    @IBOutlet weak var type_Input: UISegmentedControl!
    
    
    var db: OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dirctery = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                    appropriateFor: nil, create: false).appendingPathComponent("km_database.sqlite")
        
        if sqlite3_open(dirctery.path, &db) != SQLITE_OK{
            print("error loading db")
        }
        
        let createTable = "CREATE TABLE IF NOT EXISTS entry_table (entry INTEGER PRIMARY KEY AUTOINCREMENT, km INTEGER, gas REAL, type INTEGER)"
        
        if sqlite3_exec(db, createTable, nil, nil, nil) != SQLITE_OK{
            print("couldnt create table")
        }
        
        debugPrint("everything worked !!!")
        
    }
    
    @IBAction func add(_ sender: Any) {
        var add: OpaquePointer?
        
        let add_query = "INSERT INTO entry_table (km, gas, type) VALUES (?,?,?)"
        
        if sqlite3_prepare(db, add_query, -1, &add, nil) != SQLITE_OK{
            debugPrint("couldnt prep")
            return
        }
        
        if sqlite3_bind_int(add, 1, Int32(km_Input.text!)!) != SQLITE_OK{
            debugPrint("could bind km")
            return
        }
        
        if sqlite3_bind_double(add, 2, Double(gas_Input.text!)!) != SQLITE_OK{
            debugPrint("could bind gas")
            return
        }
        
        if sqlite3_bind_int(add, 3, Int32(type_Input.selectedSegmentIndex)) != SQLITE_OK{
            debugPrint("could bind type")
            return
        }
        
        if sqlite3_step(add) != SQLITE_DONE{
            print("couldnt added")
            return
        }else{
            debugPrint("added km: ", km_Input.text ?? "didnt work", " gas: ", gas_Input.text ?? "didnt work", " type: ", type_Input.selectedSegmentIndex)
        }
    }
    
    
    
    
}