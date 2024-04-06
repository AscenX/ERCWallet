//
//  KeyboardManager.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/7.
//

import Foundation
import RxSwift
import RxCocoa

class KeyboardManager {
    
    static let shared = KeyboardManager()
    
    private(set) var keyboardOb: Observable<(CGFloat, Double)>!
    
    private init() {
        
        keyboardOb = NotificationCenter.default.rx.notification(UIResponder.keyboardWillChangeFrameNotification)
            .map({ note in
                guard let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return (0.0, 0.0) }
                guard let duration = note.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval else { return (0.0, 0.0) }
                return (UIScreen.main.bounds.height - frame.origin.y, duration)
            })
    }
    
}
