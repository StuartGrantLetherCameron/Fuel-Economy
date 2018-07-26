//
//  EntryList.swift
//  Fuel Economy
//
//  Created by Stuart Cameron on 2018-07-02.
//  Copyright © 2018 Stuart Cameron. All rights reserved.
//

import UIKit
import SQLite3

class EntryList: UIViewController {

    var db: OpaquePointer?
    
    @IBOutlet weak var tableView: UITableView!
    
    var rowObj: [RowObj] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rowObj = createRowArray()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func createRowArray() -> [RowObj] {
        
        let dirctery = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                    appropriateFor: nil, create: false).appendingPathComponent("km_database.sqlite")
        
        if sqlite3_open(dirctery.path, &db) != SQLITE_OK{
            print("error loading db")
        }
        
        let data = Functions().get_all_from_table(db: db!)
        
        var table_entry: [RowObj] = []
        
        if data.count == 0 {
            return table_entry
        }
        
        for x in 0...(data.count-1){
            let temp = RowObj(image: #imageLiteral(resourceName: "gascan.png"), date: data[x].date, km: String(data[x].km) + " Km", gas: String(data[x].gas) + "L")
            table_entry.insert(temp, at: 0)
        }
        
        return table_entry
    }
}


extension EntryList: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let dirctery = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask,
                                                    appropriateFor: nil, create: false).appendingPathComponent("km_database.sqlite")
        
        if sqlite3_open(dirctery.path, &db) != SQLITE_OK{
            print("error loading db")
            return 10
        }
        
        let data = Functions().get_all_from_table(db: db!)
        print("adding ", data.count, " rows")
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = rowObj[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell") as! EntryCell
        
        cell.setRow(row: temp)
        
        return cell
    }
    
}
