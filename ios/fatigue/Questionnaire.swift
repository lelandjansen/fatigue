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
        
        let result = Result()
        
        let illQuestion = YesNoQuestion(
            question: "Are you ill?",
            details: "Cold, headache, flu, etc.",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: result
        )
        
        let deployentTimeQuestion = YesNoQuestion(
            question: "Have you been on tour for more than 75% of your planned deployment?",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: illQuestion
        )
        
        let stressQuestion = YesNoQuestion(
            question: "Have you been experiencing elevated stress?",
            details: "Home life, client pressure, team dynamic, etc.",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: deployentTimeQuestion
        )
        
        let flightTimeQuestionOnePilot = RangeQuestion(
            question: "How many hours will you be flying today?",
            options: Array(0...12),
            selection: 5,
            units: .hours,
            riskScoreContribution: {
                selection in switch Int(selection) {
                case let x where x! < 6:
                    return 0
                case let x where x! < 9:
                    return 2
                default:
                    return 6
                }
            },
            nextItem: stressQuestion
        )
        
        let flightTimeQuestionTwoPilots = RangeQuestion(
            question: "How many hours will you and your colleague be flying today?",
            options: Array(0...12),
            selection: 5,
            units: .hours,
            riskScoreContribution: {
                selection in switch Int(selection) {
                case let x where x! < 8:
                    return 0
                case let x where x! < 11:
                    return 2
                default:
                    return 6
                }
            },
            nextItem: stressQuestion
        )
        
        let numberOfPilotsQuestion = YesNoQuestion(
            question: "Are you flying with another pilot?",
            riskScoreContribution: { _ in 0 },
            nextItemIfYes: flightTimeQuestionTwoPilots,
            nextItemIfNo: flightTimeQuestionOnePilot
        )
        
        let timeZoneTravelQuestion = RangeQuestion(
            question: "Through how many time zones have you traveled in the past three days?",
            options: Array(0...12),
            selection: 0,
            riskScoreContribution: {
                selection in switch Int(selection) {
                case let x where x! < 3:
                    return 0
                case let x where x! < 6:
                    return 2
                default:
                    return 4
                }
            },
            nextItem: numberOfPilotsQuestion
        )
        
        let forecastHoursAwake = RangeQuestion(
            question: "How many hours do you anticipate to have been awake when the aircraft is shut down?",
            options: Array(0...16),
            selection: 6,
            units: .hours,
            riskScoreContribution: {
                selection in switch Int(selection) {
                case let x where x! < 8:
                    return 0
                case let x where x! < 11:
                    return 1
                default:
                    return 2
                }
            },
            nextItem: timeZoneTravelQuestion
        )
        
        let sleepInPast48HoursQuestion = RangeQuestion(
            question: "How long have you slept in the past 48 hours?",
            options: Array(0...24),
            selection: 14,
            units: .hours,
            riskScoreContribution: {
                selection in switch Int(selection) {
                case let x where x! < 12:
                    return 4
                case let x where x! < 14:
                    return 1
                default:
                    return 0
                }
            },
            nextItem: forecastHoursAwake
        )
        
        let sleepInPast24HoursQuestion = RangeQuestion(
            question: "How long have you slept in the past 24 hours?",
            options: Array(0...12),
            selection: 7,
            units: .hours,
            riskScoreContribution: {
                selection in switch Int(selection) {
                case let x where x! < 5:
                    return 4
                case let x where x! < 8:
                    return 1
                default:
                    return 0
                }
            },
            nextItem: sleepInPast48HoursQuestion
        )
        
        return sleepInPast24HoursQuestion
    }
    
    
    func generateEngineerQuestionTree() -> QuestionnaireItem {
        
        let result = Result()
        
        let illQuestion = YesNoQuestion(
            question: "Are you ill?",
            details: "Cold, headache, flu, etc.",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: result
        )
        
        let deployentTimeQuestion = YesNoQuestion(
            question: "Have you been on tour for more than 75% of your planned deployment?",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: illQuestion
        )
        
        let stressQuestion = YesNoQuestion(
            question: "Have you been experiencing elevated stress?",
            details: "Home life, client pressure, team dynamic, etc.",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: deployentTimeQuestion
        )
        
        let maintenanceTimeQuestion = RangeQuestion(
            question: "How many hours will you be performing maintenance today?",
            options: Array(0...12),
            selection: 5,
            units: .hours,
            riskScoreContribution: {
                selection in switch Int(selection) {
                case let x where x! < 6:
                    return 0
                case let x where x! < 9:
                    return 2
                default:
                    return 6
                }
            },
            nextItem: stressQuestion
        )
        
        let timeZoneTravelQuestion = RangeQuestion(
            question: "Through how many time zones have you traveled in the past three days?",
            options: Array(0...12),
            selection: 0,
            riskScoreContribution: {
                selection in switch Int(selection) {
                case let x where x! < 3:
                    return 0
                case let x where x! < 6:
                    return 2
                default:
                    return 4
                }
            },
            nextItem: maintenanceTimeQuestion
        )
        
        let forecastHoursAwake = RangeQuestion(
            question: "How many hours do you anticipate to have been awake after finishing today's maintenance tasks?",
            options: Array(0...16),
            selection: 6,
            units: .hours,
            riskScoreContribution: {
                selection in switch Int(selection) {
                case let x where x! < 8:
                    return 0
                case let x where x! < 11:
                    return 1
                default:
                    return 2
                }
            },
            nextItem: timeZoneTravelQuestion
        )
        
        let sleepInPast48HoursQuestion = RangeQuestion(
            question: "How long have you slept in the past 48 hours?",
            options: Array(0...24),
            selection: 14,
            units: .hours,
            riskScoreContribution: {
                selection in switch Int(selection) {
                case let x where x! < 12:
                    return 4
                case let x where x! < 14:
                    return 1
                default:
                    return 0
                }
            },
            nextItem: forecastHoursAwake
        )
        
        let sleepInPast24HoursQuestion = RangeQuestion(
            question: "How long have you slept in the past 24 hours?",
            options: Array(0...12),
            selection: 7,
            units: .hours,
            riskScoreContribution: {
                selection in switch Int(selection) {
                case let x where x! < 5:
                    return 4
                case let x where x! < 8:
                    return 1
                default:
                    return 0
                }
            },
            nextItem: sleepInPast48HoursQuestion
        )
        
        return sleepInPast24HoursQuestion
    }
}
