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
    var colors = [UIColor.init(hexString: "#FF3129"),
                  UIColor.init(hexString: "#FF9B29"),
                  UIColor.init(hexString: "#FFD829"),
                  UIColor.init(hexString: "#59B259"),
                  UIColor.init(hexString: "#29BAFF"),
                  UIColor.init(hexString: "#7F66FF"),
                  UIColor.init(hexString: "#805740"),
                  UIColor.black,
                  UIColor.white]
    
    override init() {
        super.init()
    }
    
    var gifsStickersViewControllerDelegate : GifsStickersViewControllerDelegate?
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        colorDelegate?.didSelectColor(color: colors[indexPath.item])
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: collectionView.contentInset.top, left: 0, bottom: collectionView.contentInset.bottom, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCollectionViewCell", for: indexPath) as! ColorCollectionViewCell
        cell.colorView.backgroundColor = colors[indexPath.item]
        
      
        return cell
    }
}
