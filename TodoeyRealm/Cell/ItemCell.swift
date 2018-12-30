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

    func updateItemName(withItem item: Item) {
        itemXibView.itemLabel.text = item.title
    }
}
