//
//  ColorsCollectionViewDelegate.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 5/1/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit

class ColorsCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var colorDelegate : ColorDelegate?
    
    var initialColor: UIColor?
    
    /**
     Array of Colors that will show while drawing or typing
     */
    var colors = [UIColor.white,
                  UIColor.init(hexString: "#30b2bb"),
                  UIColor.init(hexString: "#76fecb"),
                  UIColor.init(hexString: "#ca71f6"),
                  UIColor.init(hexString: "#32c5ff"),
                  UIColor.init(hexString: "#e020ce"),
                  UIColor.init(hexString: "#fdbeea"),
                  UIColor.init(hexString: "#e02020"),
                  UIColor.init(hexString: "#fa6400"),
                  UIColor.black]
    
    override init() {
        super.init()
    }
    
    var gifsStickersViewControllerDelegate : GifsStickersViewControllerDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        for cell in collectionView.visibleCells {
            if (collectionView.indexPath(for: cell)?.item != indexPath.item) {
                let colorCell = cell as! ColorCollectionViewCell
                colorCell.colorView.layer.masksToBounds = true
                colorCell.colorView.clipsToBounds = true
            }
        }
        
        colorDelegate?.didSelectColor(color: colors[indexPath.item])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = UIScreen.main.bounds.width - collectionView.frame.size.width
        
        return UIEdgeInsets(top: collectionView.contentInset.top, left: -left / 2 + 12, bottom: collectionView.contentInset.bottom, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        cell.colorView.backgroundColor = colors[indexPath.item]
        cell.colorView.layer.cornerRadius = 0
        
        if (colors[indexPath.item].cgColor == initialColor?.cgColor) {
            cell.colorView.layer.shadowColor = UIColor.black.cgColor
            cell.colorView.layer.shadowOpacity = 0.7
            cell.colorView.layer.shadowOffset = .zero
            cell.colorView.layer.shadowRadius = 6
            cell.colorView.layer.masksToBounds = false
            cell.colorView.clipsToBounds = false
        }
        
        if indexPath.item == 0 {
            cell.colorView.layer.cornerRadius = 15
            
            if #available(iOS 11.0, *) {
                cell.colorView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMinXMinYCorner]
            } else {
                let path = UIBezierPath(roundedRect: cell.colorView.bounds,
                                        byRoundingCorners: [.bottomLeft, .topLeft],
                                        cornerRadii: CGSize(width: 20, height: 20))
                
                let maskLayer = CAShapeLayer()
                
                maskLayer.path = path.cgPath
                cell.colorView.layer.mask = maskLayer
            }
        } else if indexPath.item == colors.count - 1 {
            cell.colorView.layer.cornerRadius = 15
            
            if #available(iOS 11.0, *) {
                cell.colorView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner]
            } else {
                let path = UIBezierPath(roundedRect: cell.colorView.bounds,
                                        byRoundingCorners: [.bottomRight, .topRight],
                                        cornerRadii: CGSize(width: 20, height: 20))
                
                let maskLayer = CAShapeLayer()
                
                maskLayer.path = path.cgPath
                cell.colorView.layer.mask = maskLayer
            }
        }
        cell.clipsToBounds = false
        cell.layer.masksToBounds = false
        return cell
    }
    
}
