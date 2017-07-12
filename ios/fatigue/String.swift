import Foundation

extension String {
    init?(describingTime time: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        self.init(formatter.string(from: time))
    }
    
    init?(describingDate date: Date) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .long
        formatter.doesRelativeDateFormatting = true
        self.init(formatter.string(from: date))
    }
    
    func stripHttp() -> String {
        if let range = self.range(of: "^http[s]?:\\/\\/", options: .regularExpression) {
            return self.replacingCharacters(in: range, with: String())
        }
        return self
    }
}
