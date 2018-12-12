//
//  DaiGouTableViewCell.swift
//  LilyNetwork
//
//  Created by 赵润声 on 12/3/18.
//

import UIKit
import SDWebImage

class DaiGouTableViewCell: UITableViewCell {

    @IBOutlet var boughtButton: UIButton!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var qualityLabel: UILabel!
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
