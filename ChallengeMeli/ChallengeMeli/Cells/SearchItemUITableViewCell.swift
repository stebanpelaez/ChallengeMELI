//
//  SearchUITableViewCell.swift
//  Test ML
//
//  Created by Juan Esteban Pelaez on 15/11/21.
//
import UIKit

class SearchItemUITableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewThumbnail: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelDiscount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
