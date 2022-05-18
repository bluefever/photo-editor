//
//  GifCollectionViewCell.swift
//  Photo Editor
//
//  Created by Adam Podsiadlo on 21/07/2020.
//

import UIKit
import SDWebImage

class GifCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gifImageView: SDAnimatedImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .white
        gifImageView.layer.cornerRadius = 16
        gifImageView.clipsToBounds = true
        gifImageView.layer.borderColor = UIColor.init(hexString: "#DFDFDF").cgColor
        gifImageView.layer.borderWidth = 1
        gifImageView.layer.masksToBounds = true
    }
}
