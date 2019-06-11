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
    
    func make_border(button: UIButton, color: CGColor){
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 5;
        button.layer.borderColor = color
        
    }
    
    func turn_to_coordinate(list: [Entry]) -> [Corrdinate] {
        var cor_list = [Corrdinate] ()
        
        let length = list.count
        
        if length < 2 {
            return cor_list
        }
            
        
        var x_cor = 0.0
        var y_cor = 0.0
        var km = 0.0
        
        for x in (0...length-2){
            if (list[x].gas > 0.5){
                x_cor = x_cor+1
                km = Double(list[x+1].km - list[x].km)
                
                if km <= 0.0 {
                    km = 1
                }
                
                y_cor =  Double((list[x+1].gas / km ) * 100)
                y_cor = Double(round_num(num: y_cor))
                print(y_cor)
                
                
                cor_list.append(Corrdinate(x: x_cor, y: y_cor))
            }
        }
        return cor_list
    }
    
    
    func turn_to_coordinate_for_table(list: [Entry]) -> [Corrdinate] {
        var cor_list = [Corrdinate] ()
        
        let length = list.count
        
        if length < 2 {
            return cor_list
        }
        
        
        var x_cor = 0.0
        var y_cor = 0.0
        var km = 0.0
        
        for x in (0...length-2){
            if (list[x].gas >= 0.0){
                x_cor = Double(x+1)
                km = Double(list[x+1].km - list[x].km)
                
                if km <= 0.0 {
                    km = 1
                }
                
                y_cor =  Double((list[x+1].gas / km ) * 100)
                y_cor = Double(round_num(num: y_cor))
                print(y_cor)
                
                
                cor_list.append(Corrdinate(x: x_cor, y: y_cor))
            }else{
                x_cor = Double(x+1)
                y_cor = 0.0
                cor_list.append(Corrdinate(x: x_cor, y: y_cor))
            }
        }
        return cor_list
    }
    
    
    func graph(lineChart: LineChartView, cor: [Corrdinate]) {
        
        let size = cor.count
        var start = 0
        let end = size-1
        if size < 1 {
            return
        }else if size > 9{
            start = size-10
        }
        
        let values = (start...(end)).map { (i) -> ChartDataEntry in
            return ChartDataEntry(x: Double(cor[i].x), y: Double(cor[i].y))
        }
        
        let set1 = LineChartDataSet(values: values, label: "Litters per 100 km")
        let data = LineChartData(dataSet: set1)
        lineChart.chartDescription?.text = ""
        
        lineChart.data = data
    }
    
    func get_date() -> String{
        let formatter = DateFormatter()
        
        formatter.dateStyle = .short
        
        var date = formatter.string(from: Date())
        
        if date.contains("-"){
            date = Functions().turn_to_real_date(date: date)
        }
        
        return date
    }
    
    func turn_to_real_date(date: String) -> String {
        var year: String
        var month: String
        var day: String
        
        month = ""
        day = ""
        
        let date_list = date.components(separatedBy: "-")
        
        let temp_month = date_list[1]
        let temp_day = date_list[2]
        
        year = String(date_list[0].suffix(2))
        
        if temp_month[temp_month.startIndex] == "0"{
            month = String(temp_month.suffix(1))
        }
        
        if temp_day[temp_day.startIndex] == "0" {
            day = String(temp_day.suffix(1))
        }
        
        return month + "/" + day + "/" + year
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
    
    func get_avg_km(list: [Corrdinate]) -> String {
        var sum = 0.0
        let length = list.count
        var avg = 0.0
        
        for x in list{
            sum += x.y
        }
        
        
        avg = Double(sum/Double(length))
        print("this is the big averge", avg)
        avg = round_num(num: avg)
        print(avg, " and agin after rounded")
        
        return String(avg) + " L/100 Km"
    }
    
    func round_num(num: Double) -> Double {
        return Double(round(100*num)/100)
    }
    
    func avg_ten(list: [Corrdinate]) -> String {
        if list.count < 10 {
            return "NA"
        }
        
        var avg = 0.0
        for x in (list.count-9...list.count-1){
            avg += list[x].y
        }
        avg = (avg/Double(list.count))
        avg = round_num(num: avg)
        
        return String(avg) + " L/100Km"
    }
    
    func get_last(list: [Entry]) -> Entry {
        return list[list.count-1]
    }
    
}

