//
//  SwitchAccountVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/5.
//

import UIKit

class SwitchAccountVC: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var backBtn: UIButton!
    
    lazy var addView: AddWalletView = {
        let view = AddWalletView.nibView(AddWalletView.name)
        return view as! AddWalletView
    }()
    
    // MARK: - Life Cycle
    
    private var vm: SwitchAccountVM!
    
    override init() {
        super.init()
        
        vm = SwitchAccountVM()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    // MARK: - Set up
    
    override func setupView() {
        title = "Switch Wallet"
        
        tableView.rowHeight = 44.0
        tableView.register(MyWalletCell.nib, forCellReuseIdentifier: MyWalletCell.reuseId)
        
        tableView.tableFooterView = addView
    }
    
    override func setupAction() {
        
        // add wallet
        addView.clickEvent.asDriver(onErrorJustReturn: ()).drive(onNext: { [weak self] _ in
            guard let self = self else { return }
            let vc = NewWalletVC(false)
            navigationController?.pushViewController(vc, animated: true)
        }).disposed(by: rx.disposeBag)
        
        // back click
        backBtn.click { [weak self] in
            guard let self = self else { return }
            navigationController?.popToRootViewController(animated: true)
        }.disposed(by: rx.disposeBag)
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension SwitchAccountVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WalletManager.shared.allMyWallet.value.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MyWalletCell.reuseId, for: indexPath) as! MyWalletCell
        cell.bindViewModel(vm, indexPath, tableView.tag)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        WalletManager.shared.switchIndex(indexPath.row)
        
        navigationController?.popViewController(animated: true)
    }
}
