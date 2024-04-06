//
//  SelectNetworkCell.swift
//  ERCWallet
//
//  Created by Ascen on 2024/4/6.
//

import UIKit

class SelectNetworkCell: BaseTableViewCell, CellProtocol {
    
    @IBOutlet weak var nameLbl: UILabel!
    
    @IBOutlet weak var selectedImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func bindViewModel<T>(_ viewModel: T, _ ip: IndexPath, _ tag: Int?) where T : ViewModelCellType {
        guard let cellVm = viewModel.cellViewModel(ip, tag) as? SelectNetworkCellVM else { return }
        
        nameLbl.text = cellVm.name
        selectedImgView.isHidden = !cellVm.isSelected
    }
    
}
