//
//  ItemCell.swift
//  TodoeyRealm
//
//  Created by Waleed Saad on 12/29/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var xibView: UIView!
    private var itemXibView = ItemXibView()
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewInit()

    }

    private func viewInit(){
        if let view = Bundle.main.loadNibNamed("ItemXib", owner: self, options: nil)?.first as? ItemXibView {
            itemXibView = view
            itemXibView.frame = xibView.frame
            xibView.addSubview(itemXibView)
        }
    }

    func updateItem(withItem item: Item, currentCellNumber: Int, totalItemsNumber: Int, color: String) {
        itemXibView.itemLabel.text = item.title
        if let xibBackgroundColor = UIColor.init(hexString: color){
            let percentage = CGFloat(currentCellNumber) / CGFloat(totalItemsNumber)
            itemXibView.backgroundColor = xibBackgroundColor.darken(byPercentage: percentage)
            itemXibView.itemLabel.textColor = UIColor.init(contrastingBlackOrWhiteColorOn: itemXibView.backgroundColor!, isFlat: true)
        }
    }
}
