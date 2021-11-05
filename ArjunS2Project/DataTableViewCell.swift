//
//  DataTableViewCell.swift
//  ArjunS2Project


import UIKit

class DataTableViewCell: UITableViewCell {

    @IBOutlet weak var NameText: UILabel!
    @IBOutlet weak var countryText: UILabel!
    @IBOutlet weak var userImgae: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
