import Foundation

class Result {
    let riskScore: UInt
    let remark: String
    
    init(withRiskScore riskScore: UInt) {
        self.riskScore = riskScore
        
        switch UserDefaults.standard.getCareer() {
        case .pilot:
            if riskScore < 6 {
                remark = "Continue as normal."
            }
            else if riskScore < 15 {
                remark = "Reduce flight time and if possible reduce duty period."
            }
            else if riskScore < 18 {
                remark = "Proceed upon approval from Chief Pilot of agreed mitigation measures."
            }
            else {
                remark = "Stay on the ground."
            }
        case .engineer:
            if riskScore < 6 {
                remark = "Continue as normal."
            }
            else if riskScore < 15 {
                remark = "Reduce duty day and defer all non-essential tasks."
            }
            else if riskScore < 18 {
                remark = "Proceed upon approval of agreed mitigation measures from Head of Maintenance."
            }
            else {
                remark = "Defer all maintenance."
            }
        }
    }
}
