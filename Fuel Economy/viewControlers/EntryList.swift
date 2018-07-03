//
//  EntryList.swift
//  Fuel Economy
//
//  Created by Stuart Cameron on 2018-07-02.
//  Copyright © 2018 Stuart Cameron. All rights reserved.
//

import UIKit

class EntryList: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var rowObj: [RowObj] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rowObj = createRowArray()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func createRowArray() -> [RowObj] {
        var temp: [RowObj] = []
        
        let temp0 = RowObj(image: #imageLiteral(resourceName: "gascan.jpeg"), date: "hello", km: "400 Km" , gas: "22.56 L")

        temp.append(temp0)
        temp.append(temp0)
        temp.append(temp0)
        temp.append(temp0)
        temp.append(temp0)
        temp.append(temp0)
        temp.append(temp0)
        temp.append(temp0)
        temp.append(temp0)
        
        return temp
    }
}


extension EntryList: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowObj.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let temp = rowObj[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "entryCell") as! EntryCell
        
        cell.setRow(row: temp)
        
        return cell
    }
    
}
