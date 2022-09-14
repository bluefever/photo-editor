//
//  ColorCollectionViewCell.swift
//  Photo Editor
//
//  Created by Adam Podsiadlo on 17/07/2020.
//

import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var colorView: UIView!
    var previousTransform: CGAffineTransform? = nil
    var initialColor: UIColor? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.frame = CGRect(x: self.frame.minX, y: self.frame.minY, width: UIScreen.main.bounds.width / 9, height: UIScreen.main.bounds.width / 9)
        
        self.colorView.layer.borderWidth = 2
        self.colorView.layer.borderColor = UIColor.white.cgColor
        self.colorView.layer.cornerRadius = self.colorView.frame.size.width / 2
        
        
        self.colorView.clipsToBounds = true
        self.colorView.layer.shadowColor = UIColor.black.cgColor
        self.colorView.layer.shadowOpacity = 0.7
        self.colorView.layer.shadowOffset = .zero
        self.colorView.layer.shadowRadius = 3
        self.colorView.layer.masksToBounds = false
        self.colorView.clipsToBounds = false
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                if (self.previousTransform == nil) {
                    self.previousTransform =  colorView.transform
                    
                    UIView.animate(withDuration: 0.2,
                                   animations: {
                        self.colorView.transform = self.colorView.transform.scaledBy(x: 1.2, y: 1.2)
                    });
                }
            } else {
                if (self.previousTransform != nil) {
                    UIView.animate(withDuration: 0.2, animations: {
                        self.colorView.transform  = self.previousTransform!
                    },
                        completion: { _ in
                            self.previousTransform = nil
                    })
                }
            }
        }
    }
}
