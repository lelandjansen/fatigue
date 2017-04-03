import UIKit

extension UIColor {
    static let light = UIColor(red: 244/255, green: 239/255, blue: 227/255, alpha: 1)
    
    static let medium = UIColor(red: 125/255, green: 116/255, blue: 127/255, alpha: 1)
    
    static let dark = UIColor(red: 83/255, green: 78/255, blue: 84/255, alpha: 1)
    
    static let gray = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
    
    static let red = UIColor(red: 221/255, green: 105/255, blue: 99/255, alpha: 1)
    
    static let orange = UIColor(red: 228/255, green: 163/255, blue: 108/255, alpha: 1)
    
    static let yellow = UIColor(red: 234/255, green: 211/255, blue: 116/255, alpha: 1)
    
    static let green = UIColor(red: 156/255, green: 211/255, blue: 174/255, alpha: 1)
    
    static let blue = UIColor(red: 149/255, green: 170/255, blue: 191/255, alpha: 1)
    
    
    func blend(withColor color: UIColor) -> UIColor {
        return UIColor(
            red: (CIColor(color: self).red + CIColor(color: color).red) / 2,
            green: (CIColor(color: self).blue + CIColor(color: color).blue) / 2,
            blue: (CIColor(color: self).green + CIColor(color: color).green) / 2,
            alpha: (CIColor(color: self).alpha + CIColor(color: color).alpha) / 2
        )
    }
}
