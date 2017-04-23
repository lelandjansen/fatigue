import Foundation

class Result: QuestionnaireItem {
    
    enum QualitativeRisk {
        case low, medium, high, veryHigh
    }
    
    var riskScore: Int = 0 {
        didSet {
            switch UserDefaults.standard.occupation {
            case .pilot:
                if riskScore < 6 {
                    remark = "Continue as normal."
                    qualitativeRisk = QualitativeRisk.low
                }
                else if riskScore < 15 {
                    remark = "Reduce flight time and if possible reduce duty period."
                    qualitativeRisk = QualitativeRisk.medium
                }
                else if riskScore < 18 {
                    remark = "Proceed upon approval from your supervisor."
                    qualitativeRisk = QualitativeRisk.high
                }
                else {
                    remark = "Stay on the ground."
                    qualitativeRisk = QualitativeRisk.veryHigh
                }
            case .engineer:
                if riskScore < 6 {
                    remark = "Continue as normal."
                    qualitativeRisk = QualitativeRisk.low
                }
                else if riskScore < 15 {
                    remark = "Reduce duty day and defer all non-essential tasks."
                    qualitativeRisk = QualitativeRisk.medium
                }
                else if riskScore < 18 {
                    remark = "Proceed upon approval from your supervisor."
                    qualitativeRisk = QualitativeRisk.high
                }
                else {
                    remark = "Defer all maintenance."
                    qualitativeRisk = QualitativeRisk.veryHigh
                }
            default:
                fatalError("Career cannot be none")
            }
        }
    }
    var remark: String = String()
    var nextItem: QuestionnaireItem?
    var qualitativeRisk: QualitativeRisk?
}
