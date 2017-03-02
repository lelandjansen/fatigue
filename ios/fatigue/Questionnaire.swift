import Foundation

struct Questionnaire {
    
    var questionnaireTreeRoot: QuestionnaireItem {
        get {
            switch UserDefaults.standard.getCareer() {
            case Career.pilot:
                return generatePilotQuestionTree()
            case Career.engineer:
                return generateEngineerQuestionTree()
            }
        }
    }
    
    
    func generatePilotQuestionTree() -> QuestionnaireItem {
        
        let illQuestion = YesNoQuestion(
            question: "Are you ill?",
            details: "Cold, headache, flu, etc.",
            nextItem: Result(withRiskScore: 12)
        )
        
        let deployentTimeQuestion = YesNoQuestion(
            question: "Have you been on tour for more than 75% of your planned deployment?",
            nextItem: illQuestion
        )
        
        let stressQuestion = YesNoQuestion(
            question: "Have you been experiencing elevated stress?",
            details: "Home life, client pressure, team dynamic, etc.",
            nextItem: deployentTimeQuestion
        )
        
        let flightTimeQuestionOnePilot = RangeQuestion(
            question: "How many hours will you be flying today?",
            options: Array(0...12),
            selection: 5,
            units: .hours,
            nextItem: stressQuestion
        )
        
        let flightTimeQuestionTwoPilots = RangeQuestion(
            question: "How many hours will you and your colleague be flying today?",
            options: Array(0...12),
            selection: 5,
            units: .hours,
            nextItem: stressQuestion
        )
        
        let numberOfPilotsQuestion = YesNoQuestion(
            question: "Are you flying with another pilot?",
            nextItemIfYes: flightTimeQuestionTwoPilots,
            nextItemIfNo: flightTimeQuestionOnePilot
        )
        
        let timeZoneTravelQuestion = RangeQuestion(
            question: "Through how many time zones have you traveled in the past three days?",
            options: Array(0...12),
            selection: 0,
            nextItem: numberOfPilotsQuestion
        )
        
        let sleepInPast48HoursQuestion = RangeQuestion(
            question: "How long have you slept in the past 48 hours?",
            options: Array(0...24),
            selection: 14,
            units: .hours,
            nextItem: timeZoneTravelQuestion
        )
        
        let sleepInPast24HoursQuestion = RangeQuestion(
            question: "How long have you slept in the past 24 hours?",
            options: Array(0...12),
            selection: 7,
            units: .hours,
            nextItem: sleepInPast48HoursQuestion
        )
        
        return sleepInPast24HoursQuestion
    }
    
    
    func generateEngineerQuestionTree() -> QuestionnaireItem {
        let illQuestion = YesNoQuestion(
            question: "Are you ill?",
            details: "Cold, headache, flu, etc.",
            nextItem: Result(withRiskScore: 12)
        )
        
        let deployentTimeQuestion = YesNoQuestion(
            question: "Have you been on tour for more than 75% of your planned deployment?",
            nextItem: illQuestion
        )
        
        let stressQuestion = YesNoQuestion(
            question: "Have you been experiencing elevated stress?",
            details: "Home life, client pressure, team dynamic, etc.",
            nextItem: deployentTimeQuestion
        )
        
        let maintenanceTimeQuestion = RangeQuestion(
            question: "How many hours will you be flying today?",
            options: Array(0...12),
            selection: 5,
            units: .hours,
            nextItem: stressQuestion
        )
        
        let timeZoneTravelQuestion = RangeQuestion(
            question: "Through how many time zones have you traveled in the past three days?",
            options: Array(0...12),
            selection: 0,
            nextItem: maintenanceTimeQuestion
        )
        
        let sleepInPast48HoursQuestion = RangeQuestion(
            question: "How long have you slept in the past 48 hours?",
            options: Array(0...24),
            selection: 14,
            units: .hours,
            nextItem: timeZoneTravelQuestion
        )
        
        let sleepInPast24HoursQuestion = RangeQuestion(
            question: "How long have you slept in the past 24 hours?",
            options: Array(0...12),
            selection: 7,
            units: .hours,
            nextItem: sleepInPast48HoursQuestion
        )
        
        return sleepInPast24HoursQuestion
    }
}
