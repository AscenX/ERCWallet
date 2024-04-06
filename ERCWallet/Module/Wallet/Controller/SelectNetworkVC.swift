//
//  SelectNetworkVC.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/6.
//

import UIKit

class SelectNetworkVC: BaseViewController {
    
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Life Cycle
    
    private var vm: SelectNetworkVM!
    
    override init() {
        super.init()
        
        vm = SelectNetworkVM()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func setupView() {
        
        tableView.register(SelectNetworkCell.nib, forCellReuseIdentifier: SelectNetworkCell.reuseId)
        tableView.rowHeight = 44
        
    }

    override func setupAction() {
        closeBtn.click { [weak self] in
            guard let self = self else { return }
            dismiss(animated: true)
        }.disposed(by: rx.disposeBag)
    }
}

extension SelectNetworkVC: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return NetworkManager.shared.networkList.value.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectNetworkCell.reuseId, for: indexPath) as! SelectNetworkCell
        cell.bindViewModel(vm, indexPath, tableView.tag)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        NetworkManager.shared.switchNetwork(indexPath.row)
        
        dismiss(animated: true)
    }
}
