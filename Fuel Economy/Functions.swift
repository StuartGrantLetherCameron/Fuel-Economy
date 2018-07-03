import SQLite3
import UIKit
import Charts

class Functions {
    func get_all_from_table(db: OpaquePointer) -> [Entry] {
        var stmt: OpaquePointer?
        
        var entry_list = [Entry]()
        let query = "SELECT * FROM entry_table_3"
        
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK{
            print("didnt prep")
            return entry_list
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let entry = sqlite3_column_int(stmt, 0)
            let km = sqlite3_column_int(stmt, 1)
            let gas = sqlite3_column_double(stmt, 2)
            let type = sqlite3_column_int(stmt, 3)
            let date = String(cString: sqlite3_column_text(stmt, 4))
            
            entry_list.append(Entry(entry: Int(entry), km: Int(km), gas: Double(gas), type: Int(type), date: String(date)))
            
            print("entry: ", entry, " km: ", km , " gas: ", gas, " type: ", type, " date: ", date)
        }
        return entry_list
    }
    
    func turn_to_coordinate(list: [Entry]) -> [Corrdinate] {
        var cor_list = [Corrdinate] ()
        
        let length = list.count
        
        if length < 2 {
            return cor_list
        }
            
        
        var x_cor = 0.0
        var y_cor = 0.0
        
        for x in (0...length-2){
            x_cor = Double(x+1)
            y_cor = (Double(list[x+1].km - list[x].km) / list[x+1].gas)
            
            cor_list.append(Corrdinate(x: x_cor, y: y_cor))
        }
        return cor_list
    }
    
    func graph(lineChart: LineChartView, cor: [Corrdinate]) {
        
        let size = cor.count
        if size < 1 {
            return
        }
        
        let values = (0...(size-1)).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(cor[i].x), y: Double(cor[i].y))
        }
        
        let set1 = LineChartDataSet(values: values, label: "Litters per 100 km")
        let data = LineChartData(dataSet: set1)
        lineChart.chartDescription?.text = ""
        
        lineChart.data = data
    }
    
    func get_date() -> String{
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        let date = formatter.string(from: Date())
        return date
    }
    
    func drop_table(db: OpaquePointer) {
        
        let query = "DROP TABLE km_database.swift.entry_table"
        var stmt: OpaquePointer?
        
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK{
            print("didnt prep")
        }
        
        if sqlite3_step(stmt) != SQLITE_OK {
            print("didnt work :(")
        }
    }
}

