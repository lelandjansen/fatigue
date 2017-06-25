import Foundation

struct Questionnaire {
    var questionnaireTreeRoot: QuestionnaireItem {
        get {
            switch UserDefaults.standard.occupation {
            case Occupation.pilot:
                return generatePilotQuestionTree()
            case Occupation.engineer:
                return generateEngineerQuestionTree()
            case Occupation.none:
                fatalError("Occupation cannot be none")
            }
        }
    }
    
    func generatePilotQuestionTree() -> QuestionnaireItem {
        let result = Result()
        let reasonNotToFly = YesNoQuestion(
            question: "Do you know of any other reason you should not fly today?",
            description: "Other reason not to fly",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 18 : 0
            },
            nextItem: result
        )
        let illQuestion = YesNoQuestion(
            question: "Are you ill?",
            details: "Cold, headache, flu, etc.",
            description: "Reported illness",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: reasonNotToFly
        )
        let deployentTimeQuestion = YesNoQuestion(
            question: "Have you been on tour for more than 75% of your planned deployment?",
            description: "On tour for more than 75% of planned deployment",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: illQuestion
        )
        let stressQuestion = YesNoQuestion(
            question: "Have you been experiencing elevated stress?",
            details: "Home life, client pressure, team dynamic, etc.",
            description: "Elevated stress",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: deployentTimeQuestion
        )
        let flightTimeQuestionOnePilot = RangeQuestion(
            question: "How many hours will you be flying today?",
            description: "Hours in-flight",
            options: Array(0...24),
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
            description: "Hours flying",
            options: Array(0...24),
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
            description: "Flying with another pilot",
            riskScoreContribution: { _ in 0 },
            nextItemIfYes: flightTimeQuestionTwoPilots,
            nextItemIfNo: flightTimeQuestionOnePilot
        )
        let timeZoneQuantityQuestion = RangeQuestion(
            question: "How many time zones did you travel through to get to the project site?",
            description: "Time zones travelled to project site",
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
        let timeZoneTravelQuestion = YesNoQuestion(
            question: "Have you been on-site for less than three full days?",
            description: "On-site for less than three full days",
            riskScoreContribution: { _ in 0 },
            nextItemIfYes: timeZoneQuantityQuestion,
            nextItemIfNo: numberOfPilotsQuestion
        )
        let forecastHoursAwake = RangeQuestion(
            question: "How many hours do you anticipate having been awake when the aircraft is shut down?",
            description: "Hours anticipated having been awake when aircraft is shut down",
            options: Array(0...24),
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
            description: "Sleep in past 48 hours",
            options: Array(0...48),
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
            description: "Sleep in past 24 hours",
            options: Array(0...24),
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
        let reasonNotToFly = YesNoQuestion(
            question: "Do you know of any other reason you should not work today?",
            description: "Other reason not to fly",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 18 : 0
            },
            nextItem: result
        )
        let illQuestion = YesNoQuestion(
            question: "Are you ill?",
            details: "Cold, headache, flu, etc.",
            description: "Reported illness",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: reasonNotToFly
        )
        let deployentTimeQuestion = YesNoQuestion(
            question: "Have you been on tour for more than 75% of your planned deployment?",
            description: "On tour for more than 75% of planned deployment",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: illQuestion
        )
        let stressQuestion = YesNoQuestion(
            question: "Have you been experiencing elevated stress?",
            details: "Home life, client pressure, team dynamic, etc.",
            description: "Elevated stress",
            riskScoreContribution: {
                selection in (selection == YesNoQuestion.Answer.yes.rawValue) ? 1 : 0
            },
            nextItem: deployentTimeQuestion
        )
        let maintenanceTimeQuestion = RangeQuestion(
            question: "How many hours will you be performing maintenance today?",
            description: "Hours performing maintenance",
            options: Array(0...24),
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
        let timeZoneQuantityQuestion = RangeQuestion(
            question: "How many time zones did you travel through to get to the project site?",
            description: "Time zones travelled to project site",
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
        let timeZoneTravelQuestion = YesNoQuestion(
            question: "Have you been on-site for less than three full days?",
            description: "On-site for less than three full days",
            riskScoreContribution: { _ in 0 },
            nextItemIfYes: timeZoneQuantityQuestion,
            nextItemIfNo: maintenanceTimeQuestion
        )
        let forecastHoursAwake = RangeQuestion(
            question: "How many hours do you anticipate having been awake after finishing today's maintenance tasks?",
            description: "Hours anticipated having been awake when maintenance tasks are complete",
            options: Array(0...24),
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
            description: "Sleep in past 48 hours",
            options: Array(0...48),
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
            description: "Sleep in past 24 hours",
            options: Array(0...24),
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
