import Foundation

class Result: QuestionnaireItem {
    
    enum QualitativeRisk {
        case low, medium, high, veryHigh
    }
    
    static func getQualitativeRisk(forRiskScore riskScore: Int32) -> QualitativeRisk {
        if riskScore < 6 {
            return .low
        } else if riskScore < 15 {
            return .medium
        } else if riskScore < 18 {
            return .high
        } else {
            return .veryHigh
        }
    }
    
    static func getRemark(forRiskScore riskScore: Int32, role: Role) -> String {
        let qualitativeRisk = getQualitativeRisk(forRiskScore: riskScore)
        return getRemark(forQualitativeRisk: qualitativeRisk, role: role)
    }
    
    static func getRemark(forQualitativeRisk qualitativeRisk: QualitativeRisk, role: Role) -> String {
        switch (role, qualitativeRisk) {
        case (.none, _):
            fatalError("Role cannot be none")
        case (_, .low):
            return "Continue as normal."
        case (.pilot, .medium):
            return "Reduce flight time and if possible reduce duty period."
        case (.engineer, .medium):
            return "Reduce duty day and defer all non-essential tasks."
        case (.pilot, .high):
            return "Proceed upon approval from your supervisor."
        case (.engineer, .high):
            return "Proceed upon approval from your supervisor."
        case (.pilot, .veryHigh):
            return "Stay on the ground."
        case (.engineer, .veryHigh):
            return "Defer all maintenance."
        default:
            fatalError("No remark for qualitative risk and occupation (\(qualitativeRisk), \(role))")
        }
    }
    
    var riskScore: Int32 = 0 {
        didSet {
            qualitativeRisk = Result.getQualitativeRisk(forRiskScore: riskScore)
            remark = Result.getRemark(forQualitativeRisk: qualitativeRisk!, role: UserDefaults.standard.role)
        }
    }
    var remark: String = String()
    var nextItem: QuestionnaireItem?
    var qualitativeRisk: QualitativeRisk?
}
