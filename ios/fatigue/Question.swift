import Foundation

protocol Question {
    var question: String { get }
    var details: String { get }
    var options: [String] { get }
}

class YesNoQuestion: Question {
    enum Answer: String {
        case yes = "Yes", no = "No"
    }
    
    var question: String
    var details: String
    var options: [String] = [Answer.yes.rawValue, Answer.no.rawValue]
    
    init(question: String, details: String = String()) {
        self.question = question
        self.details = details
    }
}

class RangeQuestion: Question {
    enum Units: String {
        case none = "", hours = "hrs"
        
    }
    
    var question: String
    var details: String
    var options: [String]
    let defaultOption: String
    let units: Units
    
    init(question: String, details: String = String(), options: [UInt], defaultOption: UInt, units: Units = .none) {
        self.question = question
        self.details = details
        self.options = options.map{String($0)}
        self.defaultOption = String(defaultOption)
        self.units = units
    }
}


struct Questions {
    
    private let sleepInPast24HoursQuestion: Question = RangeQuestion(
        question: "How long have you slept in the past 24 hours?",
        options: Array(0...12),
        defaultOption: 7
    )
    
    private let sleepInPast48HoursQuestion: Question = RangeQuestion(
        question: "How long have you slept in the past 48 hours?",
        options: Array(0...24),
        defaultOption: 14
    )
    
    private let timeZoneTravelQuestion: Question = RangeQuestion(
        question: "Through how many time zones have you traveled in the past three days?",
        options: Array(0...(12+14)),
        defaultOption: 0
    )
    
    private let stressQuestion: Question = YesNoQuestion(
        question: "Have you been experiencing elevated stress?",
        details: "Home life, client pressure, team dynamic, etc."
    )
    
    private let deployentTimeQuestion: Question = YesNoQuestion(
        question: "Have you been on tour for more than 75% of your planned deployment?"
    )
    
    private let illQuestion: Question = YesNoQuestion(
        question: "Are you ill?",
        details: "Cold, headache, flu, etc."
    )
    
    
    var questions: [Question] {
        get {
            switch UserDefaults.standard.getCareer() {
            case Career.pilot:
                return [
                    sleepInPast24HoursQuestion,
                    sleepInPast48HoursQuestion,
                    timeZoneTravelQuestion,
                    YesNoQuestion(
                        question: "Are you flying with another pilot?"
                    ),
                    RangeQuestion(
                        question: "How many hours will you be flying today?", // you and your copilot?
                        options: Array(0...12),
                        defaultOption: 5
                    ),
                    stressQuestion,
                    deployentTimeQuestion,
                    illQuestion
                ]
            case Career.engineer:
                return [
                    sleepInPast24HoursQuestion,
                    sleepInPast48HoursQuestion,
                    timeZoneTravelQuestion,
                    RangeQuestion(
                        question: "For how many hours will you be doing maintenance today?",
                        options: Array(0...12),
                        defaultOption: 5
                    ),
                    stressQuestion,
                    deployentTimeQuestion,
                    illQuestion
                ]
            }
        }
    }
}
