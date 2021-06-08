//
//  ImageCollectionViewDelegatse.swift
//  Photo Editor
//
//  Created by Adam Podsiadlo on 17/07/2020.
//

import UIKit

class ImageCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var backgroundViewControllerDelegate : BackgroundViewControllerDelegate?
    
    var bgImages: [String] = []
    var templateCategories: [String] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bgImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        backgroundViewControllerDelegate?.didSelectImageBackground(image: bgImages[indexPath.item], index: indexPath.item + 1)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return templateCategories[section]
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return templateCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "templateCategoryViewCell", for: indexPath) as? TemplateCategoryViewCell {
            cell.title = templateCategories[indexPath.item]
            
            return cell
        }
        
        
        return UITableViewCell()
    }

    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
//        cell.image.layer.cornerRadius = 14
//        cell.image.clipsToBounds = true
//        cell.image.image = nil
//        cell.image.tag = indexPath.item
//        cell.image.loadImage(urlString: bgImages[indexPath.item])
//
//        return cell
//    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
