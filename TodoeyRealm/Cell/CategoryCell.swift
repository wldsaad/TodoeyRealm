//
//  CategoryCell.swift
//  TodoeyRealm
//
//  Created by Waleed Saad on 12/29/18.
//  Copyright © 2018 Waleed Saad. All rights reserved.
//

import UIKit

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var xibView: UIView!
    private var categoryView = CategoryXibView()
    override func awakeFromNib() {
        super.awakeFromNib()
        viewInit()
    }

    private func viewInit(){
        if let view = Bundle.main.loadNibNamed("CategoryXib", owner: self, options: nil)?.first as? CategoryXibView {
            categoryView = view
            categoryView.frame = xibView.frame
            xibView.addSubview(categoryView)
        }
    }

    func updateCategoryName(withCategory category: Category){
        categoryView.categoryLabel.text = category.name
    }

}
