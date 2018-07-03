class Entry {
    let entry: Int
    let km: Int
    let gas: Double
    let type: Int
    let date: String
    
    init(entry: Int, km: Int, gas: Double, type: Int, date: String) {
        self.entry = entry
        self.gas = gas
        self.km = km
        self.type = type
        self.date = date
    }
}
