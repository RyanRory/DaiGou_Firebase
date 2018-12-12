//
//  ProductTableViewCell.swift
//  LilyNetwork
//
//  Created by 赵润声 on 1/4/18.
//

import UIKit
import SDWebImage

class ProductTableViewCell: UITableViewCell {

    @IBOutlet var productImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var costLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var barcodeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
