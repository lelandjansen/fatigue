import UIKit

extension UIButton {
    class func createStyledButton(withColor color: UIColor = .medium, withEmptyColor emptyColor: UIColor = .light) -> UIButton {
        let button = UIButton(type: .custom)
        
        button.titleLabel!.font = .systemFont(ofSize: 17, weight: UIFontWeightSemibold)
        
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.layer.borderColor = color.cgColor
        
        button.setTitleColor(emptyColor, for: .normal)
        button.setTitleColor(emptyColor.withAlphaComponent(1/2), for: .highlighted)
        
        button.setBackgroundColor(color, for: .normal)
        button.setBackgroundColor(color, for: .highlighted)
        
        return button
    }
    
    
    class func createStyledSelectButton(withColor color: UIColor = .medium, withEmptyColor emptyColor: UIColor = .light) -> UIButton {
        let button = UIButton(type: .custom)
        
        button.titleLabel!.font = .systemFont(ofSize: 17, weight: UIFontWeightSemibold)
        
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.layer.borderColor = color.cgColor
        
        button.setTitleColor(color, for: .normal)
        button.setTitleColor(emptyColor, for: .selected)
        button.setTitleColor(color.withAlphaComponent(1/2), for: .highlighted)
        button.setTitleColor(emptyColor.withAlphaComponent(1/2), for: UIControlState.highlighted.union(.selected))
        
        button.setBackgroundColor(emptyColor, for: .normal)
        button.setBackgroundColor(color, for: .selected)
        button.setBackgroundColor(emptyColor, for: .highlighted)
        button.setBackgroundColor(color, for: UIControlState.highlighted.union(.selected))
        
        return button
    }
    
    
    func setBackgroundColor(_ color: UIColor, for state: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        UIGraphicsGetCurrentContext()!.setFillColor(color.cgColor)
        UIGraphicsGetCurrentContext()!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: state)
        self.clipsToBounds = true
    }
}
