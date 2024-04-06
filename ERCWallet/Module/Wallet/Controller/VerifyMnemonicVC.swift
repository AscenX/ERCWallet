//
//  VerifyMnemonicVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/3.
//

import UIKit
import RxSwift
import RxCocoa
import Web3Core

class VerifyMnemonicVC: BaseViewController {
    
    @IBOutlet weak var wordTitleLbl1: UILabel!
    @IBOutlet weak var wordTitleLbl2: UILabel!
    @IBOutlet weak var wordTitleLbl3: UILabel!
    
    @IBOutlet weak var failedTipsLbl: UILabel!
    @IBOutlet weak var verifyBtn: UIButton!
    
    private var mnemonicList: [String] = []
    
    /// confuse mnemonic list
    private var confuseMnemonicList: [String] = []
    
    /// mnemonic index map
    private var mnemonicDict : [String: Int] = [:]
    
    private var verifyWords: [String] = []
    private var verifyIndexes: [Int] = []
    
    private let indexSelected = PublishRelay<Int>()

    // right word in the index of row
    private var rightWordIndexes: [Int] = []
    private var selectedIndexes: [Int] = [-1, -1, -1]

    // MARK: - Life Cycle
    
    convenience init(_ mnemonics: [String]) {
        
        self.init()
        
        mnemonicList = mnemonics
    }
    
    // MARK: - Set up
    
    override func setupData() {
        
        generateRandomWords()
        
        for i in 0 ..< mnemonicList.count {
            mnemonicDict[mnemonicList[i]] = i
        }
        let original = mnemonicList
        mnemonicList.shuffle()
        
        // get verify index and sort
        verifyIndexes = mnemonicList[..<3].map{ mnemonicDict[$0] ?? 0 }.sorted()
        verifyWords = verifyIndexes.map{ original[$0] }
    }

    override func setupView() {
        // right word in indexes
        rightWordIndexes = [0,0,0].map { _ in
            return Int(arc4random_uniform(100) % 3)
        }
        
        for i in 0 ..< mnemonicList.count {
            if let btn = view.viewWithTag(i+1) as? UIButton {
                btn.CornerRadius = 4.0
                btn.layer.borderWidth = 1.0
                btn.layer.borderColor = UIColor.primary.cgColor
                let keyIdx = Int(i / 3)
                btn.setTitle( rightWordIndexes[keyIdx] == i % 3 ?  verifyWords[keyIdx] : confuseMnemonicList[i], for: .normal)
                
                btn.click {
                    self.indexSelected.accept(btn.tag)
                }.disposed(by: rx.disposeBag)
            }
        }
        
        wordTitleLbl1.text = "Word #\(verifyIndexes[0]+1)"
        wordTitleLbl2.text = "Word #\(verifyIndexes[1]+1)"
        wordTitleLbl3.text = "Word #\(verifyIndexes[2]+1)"
    }
    
    override func setupAction() {
        
        indexSelected.asDriver(onErrorJustReturn: 0).drive(onNext: { [weak self] idx in
            guard let self = self else { return }
            let row = Int((idx - 1) / 3)
            let begin = row * 3
            for i in begin ..< (begin + 3) {
                if let btn = view.viewWithTag(i+1) as? UIButton {
                    let isSelected = btn.tag == idx
                    btn.isSelected = isSelected
                    btn.backgroundColor = isSelected ? .primary.withAlphaComponent(0.2) : .white
                }
            }
            selectedIndexes[row] = (idx - 1) % 3
            failedTipsLbl.isHidden = true
        }).disposed(by: rx.disposeBag)
        
        verifyBtn.click { [weak self] in
            guard let self = self else { return }
            guard selectedIndexes == rightWordIndexes else {
                failedTipsLbl.isHidden = false
                return
            }
            HUD.showSuccess("Back up successfully!")
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
                self.navigationController?.popToRootViewController(animated: true)                
            }
        }.disposed(by: rx.disposeBag)
    }
    
    // MARK: - Logic

    private func generateRandomWords() {
        let words = BIP39Language.english.words
        let total = UInt32(words.count)
        for _ in 0 ..< 12 {
            confuseMnemonicList.append(words[Int(arc4random_uniform(total))])
        }
    }
}
