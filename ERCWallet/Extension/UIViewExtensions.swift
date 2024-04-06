//
//  UIView.swift
//  Ascen
//
//  Created by Ascen on 2018/11/13.
//  Copyright © 2018年 Ascen. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

private var loadingViewKey: Void?
private var emptyViewKey: Void?

extension UIView {
    
    func showLoading(_ topMargin: CGFloat? = nil) {

        var activityView: UIActivityIndicatorView?
        if let activity = objc_getAssociatedObject(self, &loadingViewKey) as? UIActivityIndicatorView {
            activityView = activity
        } else {
            activityView = UIActivityIndicatorView(style: .medium)
            objc_setAssociatedObject(self, &loadingViewKey, activityView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        DispatchQueue.main.async {
            activityView!.removeFromSuperview()

            self.addSubview(activityView!)
            activityView!.snp.makeConstraints { mk in
                mk.centerX.equalToSuperview()
                mk.top.equalTo(topMargin ?? 50.0)
            }

            activityView!.startAnimating()
        }
    }

    func removeLoading() {
        DispatchQueue.main.async {
            if let activity = objc_getAssociatedObject(self, &loadingViewKey) as? UIActivityIndicatorView {
                activity.removeFromSuperview()
            }
        }
    }

    func showEmptyView(_ imgName: String? = nil, _ tips: String? = nil, _ topMargin: CGFloat? = nil) {

        var emptyView: UIView?
        if let empty = objc_getAssociatedObject(self, &emptyViewKey) as? UIActivityIndicatorView {
            emptyView = empty
        } else {
            emptyView = UIView()

            let imgView = UIImageView(image: UIImage(named: imgName ?? "ic_empty_data"))
            emptyView!.addSubview(imgView)
            imgView.snp.makeConstraints { mk in
                mk.top.centerX.equalToSuperview()
            }

            let tipsLbl = UILabel()
            tipsLbl.text = tips ?? "No Data"
            tipsLbl.textAlignment = .center
            tipsLbl.textColor = UIColor.hex(0x888888)
            tipsLbl.font = .systemFont(ofSize: 14)
            emptyView?.addSubview(tipsLbl)
            tipsLbl.snp.makeConstraints { mk in
                mk.top.equalTo(imgView.snp.bottom).offset(25.0)
                mk.centerX.bottom.equalToSuperview()
            }

            objc_setAssociatedObject(self, &emptyViewKey, emptyView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }

        DispatchQueue.main.async {
            emptyView!.removeFromSuperview()

            self.addSubview(emptyView!)
            emptyView!.snp.makeConstraints { mk in
                mk.centerX.width.equalToSuperview()
                mk.top.equalTo(topMargin ?? 50.0)
            }
        }
    }

    func removeEmptyView() {
        DispatchQueue.main.async {
            if let emptyView = objc_getAssociatedObject(self, &emptyViewKey) as? UIView {
                emptyView.removeFromSuperview()
            }
        }
    }
}

extension UIView {

    static var reuseId: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

    static var nib: UINib? {
        return UINib(nibName: self.reuseId, bundle: nil)
    }

    static var name: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }

    static func nibView(_ name: String) -> UIView {
        return Bundle.main.loadNibNamed(name, owner: nil, options: nil)!.first as! UIView
    }

    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat, bounds: CGRect? = nil) {
        let path = UIBezierPath(roundedRect: bounds ?? self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    public func addBorder(color: UIColor, width: CGFloat, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: radius, height: radius))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        
        layer.lineWidth = width
        
        layer.fillColor = nil
        layer.strokeColor = color.cgColor
        
        
        self.layer.addSublayer(layer)
    }

    public func shakeViewForTimes(_ times: Int) {
        let anim = CAKeyframeAnimation(keyPath: "transform")
        anim.values = [
            NSValue(caTransform3D: CATransform3DMakeTranslation(-5, 0, 0)),
            NSValue(caTransform3D: CATransform3DMakeTranslation(5, 0, 0))
        ]
        anim.autoreverses = true
        anim.repeatCount = Float(times)
        anim.duration = 7 / 100

        self.layer.add(anim, forKey: nil)
    }
}

/// Interface Builder Property
extension UIView {
    
    @IBInspectable var CornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
}

extension UIView {
    var height: CGFloat {
        get {
            return frame.height
        }
        set {
            frame.size.height = newValue
        }
    }

    var width: CGFloat {
        get {
            return frame.width
        }
        set {
            frame.size.width = newValue
        }
    }

    var x: CGFloat {
        get {
            return frame.origin.x
        }
        set {
            frame.origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return frame.origin.y
        }
        set {
            frame.origin.y = newValue
        }
    }

    var origin: CGPoint {
        get {
            return frame.origin
        }
        set {
            frame.origin = newValue
        }
    }

    var size: CGSize {
        get {
            return frame.size
        }
        set {
            frame.size = newValue
        }
    }

    var maxX: CGFloat {
        get {
            return frame.origin.x + frame.size.width
        }
        set {
            frame.origin.x = newValue - frame.size.width
        }
    }

    var maxY: CGFloat {
        get {
            return frame.origin.y + frame.size.height
        }
        set {
            frame.origin.y = newValue - frame.size.height
        }
    }

    public var centerX: CGFloat {
        get {
            return center.x
        }
        set(value) {
            center.x = value
        }
    }

    public var centerY: CGFloat {
        get {
            return center.y
        }
        set(value) {
            center.y = value
        }
    }
}
