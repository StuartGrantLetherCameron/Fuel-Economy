import SQLite3
import UIKit
import Charts

class Functions {
    func get_all_from_table(db: OpaquePointer) -> [Entry] {
        var stmt: OpaquePointer?
        
        var entry_list = [Entry]()
        let query = "SELECT * FROM entry_table"
        
        if sqlite3_prepare(db, query, -1, &stmt, nil) != SQLITE_OK{
            print("didnt prep")
            return entry_list
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let entry = sqlite3_column_int(stmt, 0)
            let km = sqlite3_column_int(stmt, 1)
            let gas = sqlite3_column_double(stmt, 2)
            let type = sqlite3_column_int(stmt, 3)
            
            entry_list.append(Entry(entry: Int(entry), km: Int(km), gas: Double(gas), type: Int(type)))
            
            print("entry: ", entry, " km: ", km , " gas: ", gas, " type: ", type)
        }
        return entry_list
    }
    
    func turn_to_coordinate(list: [Entry]) -> [Corrdinate] {
        var cor_list = [Corrdinate] ()
        
        let length = list.count
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
        
        let values = (0...(size-1)).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(cor[i].x), y: Double(cor[i].y))
        }
        
        let set1 = LineChartDataSet(values: values, label: "DataSet 1")
        let data = LineChartData(dataSet: set1)
        
        lineChart.data = data
    }
}

