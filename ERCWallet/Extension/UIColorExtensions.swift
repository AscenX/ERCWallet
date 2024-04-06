
import Foundation
import UIKit

extension UIColor {
    static let primary: UIColor = .hex(0x3273DC)
    static let textColor: UIColor = .darkText
}

extension UIColor {
    
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")

        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }

    convenience init(netHex: Int) {
        self.init(red: (netHex >> 16) & 0xff, green: (netHex >> 8) & 0xff, blue: netHex & 0xff)
    }
    
    static func hex(_ hexValue: Int) -> UIColor {
        return UIColor(red: (CGFloat)((hexValue & 0xFF0000) >> 16) / 255.0, green: (CGFloat)((hexValue & 0xFF00) >> 8) / 255.0, blue: (CGFloat)(hexValue & 0xFF) / 255.0, alpha: 1.0)
    }
    
    static func hex(_ hexValue: Int, _ alpha: CGFloat) -> UIColor {
        return UIColor(red: (CGFloat)((hexValue & 0xFF0000) >> 16) / 255.0, green: (CGFloat)((hexValue & 0xFF00) >> 8) / 255.0, blue: (CGFloat)(hexValue & 0xFF) / 255.0, alpha: alpha)
    }
    
    func image(frame: CGRect? = nil) -> UIImage {
        let renderRect = frame ?? CGRect(x: 0, y: 0, width: 1, height: 1)
        let renderColor = self
        UIGraphicsBeginImageContext(renderRect.size)
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.setFillColor(renderColor.cgColor)
        ctx?.fill(renderRect)
        let img = UIImage(cgImage: (ctx?.makeImage())!)
        UIGraphicsEndImageContext()
        return img
    }

    static func random() -> UIColor {
        return UIColor(red: CGFloat(arc4random_uniform(255)) / 255.0, green: CGFloat(arc4random_uniform(255)) / 255.0, blue: CGFloat(arc4random_uniform(255)) / 255.0, alpha: 1.0)
    }
}
