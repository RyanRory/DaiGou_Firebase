//
//  ShippingTableViewCell.swift
//  LilyNetwork
//
//  Created by 赵润声 on 1/4/18.
//

import UIKit
import SDWebImage

class ShippingTableViewCell: UITableViewCell {

    @IBOutlet var memberNameLabel: UILabel!
    @IBOutlet var memberNoLabel: UILabel!
    @IBOutlet var productNameLabel: UILabel!
    @IBOutlet var productAmountLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var productImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
