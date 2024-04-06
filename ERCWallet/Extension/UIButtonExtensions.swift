//
//  UIButtonExtensions.swift
//  ERCWallet
//
//  Created by Ascen Zhong on 2020/7/27.
//  Copyright © 2020 Ascen. All rights reserved.
//

import Foundation
//import Rswift
import RxSwift

private var associatedHandle: UInt8 = 0

extension UIButton {
    
    
    func click(_ clickClosure: @escaping ()->Void) -> Disposable {
        return self.rx
            .controlEvent(.touchUpInside)
            .asDriver()
            .drive(onNext: {
            clickClosure()
        })
    }
    
    func setImageToRight(_ spacing: CGFloat? = 5.0) {
        let s: CGFloat = (spacing ?? 0.0) * 0.5
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: s, bottom: 0, right: -s)
        self.titleEdgeInsets = UIEdgeInsets(top: 0, left: -s, bottom: 0, right: s)
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: s, bottom: 0, right: s)
        self.semanticContentAttribute = .forceRightToLeft
    }
    
    
//    @IBInspectable var autoLocalizable: Bool {
//        get {
//            return true
//        }
//        set {
//            if newValue {
//                let text = Locale.str(self.titleLabel?.text ?? "")
//                self.setTitle(text, for: .normal)
//            }
//        }
//    }
    
//    @IBInspectable var localizableKey: String {
//        get {
//            return self.titleLabel?.text ?? ""
//        }
//        set {
//            let keys = newValue.match("\".+?\"")
//            var text: String = newValue
//            for key in keys {
//                let start = String.Index(utf16Offset: 1, in: key)
//                let end = String.Index(utf16Offset: key.count - 1, in: key)
//                let k = String(key[start..<end])
//
//                let localizedStr = StringResource(key: k, tableName: "Localizable", bundle: Bundle(), locales: ["en", "zh-Hans"], comment: nil).rLocalized()
//                text = newValue.replacingOccurrences(of: key, with: localizedStr)
//            }
//            self.setTitle(text, for: .normal)
//        }
//    }
    
    /// 设置view的渐变颜色背景和圆角
    ///
    /// - Parameter colors: 渐变色颜色数组
//    public func makeBtnGradientLayer(_ colors: [UIColor], _ btnFrame: CGRect, _ start: CGPoint, _ end: CGPoint) {
//        
//        for layer in self.layer.sublayers ?? [] {
//            if let l = layer as? CAGradientLayer {
//                l.removeFromSuperlayer()
//            }
//        }
//        
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.frame = CGRect(x: 0, y: 0, width: kScreenW, height: self.height)
//        gradientLayer.startPoint = start
//        gradientLayer.endPoint = end
//        gradientLayer.locations = [0, 1.0]
//        //设置渐变的主颜色
//        gradientLayer.colors = colors.map{ $0.cgColor }
//        
//        let maskPath = UIBezierPath(
//        roundedRect: btnFrame,
//        byRoundingCorners: .allCorners,
//        cornerRadii: CGSize(width: 6, height: 6))
//        
//        let shape = CAShapeLayer()
//        shape.frame = btnFrame
//        shape.path = maskPath.cgPath
//        gradientLayer.mask = shape
//        
//        gradientLayer.zPosition = -1
//        
//        //将gradientLayer作为子layer添加到主layer上
//        self.layer.addSublayer(gradientLayer)
//    }
}
