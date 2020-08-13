//
//  ColorCollectionViewCell.swift
//  Photo Editor
//
//  Created by Adam Podsiadlo on 17/07/2020.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                let previouTransform =  colorView.transform
                UIView.animate(withDuration: 0.2,
                               animations: {
                                self.colorView.transform = self.colorView.transform.scaledBy(x: 0.9, y: 0.9)
                },
                               completion: { _ in
                                UIView.animate(withDuration: 0.2) {
                                    self.colorView.transform  = previouTransform
                                }
                })
                
                self.colorView.layer.shadowColor = UIColor.black.cgColor
                self.colorView.layer.shadowOpacity = 0.7
                self.colorView.layer.shadowOffset = .zero
                self.colorView.layer.shadowRadius = 6
                self.colorView.layer.masksToBounds = false
                self.colorView.clipsToBounds = false
            } else {
                self.colorView.layer.masksToBounds = true
                self.colorView.clipsToBounds = true
            }
        }
    }
}
