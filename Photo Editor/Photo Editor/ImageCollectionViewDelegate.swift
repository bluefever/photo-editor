//
//  ImageCollectionViewDelegatse.swift
//  Photo Editor
//
//  Created by Adam Podsiadlo on 17/07/2020.
//

import UIKit

class ImageCollectionViewDelegate: NSObject, UITableViewDataSource, UITableViewDelegate {
    var backgroundViewControllerDelegate : BackgroundViewControllerDelegate?
    
    var backgroundCategories: [BackgroundCategory] = []
    var backgroundsByCategory: Dictionary<String, [Background]> = [:]
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 16, y: 0, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.font = UIFont(name: "Poppins-Bold", size: 22)
        label.text = backgroundCategories[section].label
        label.textColor = UIColor.init(hexString: "#1E2347")
        
        headerView.addSubview(label)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return backgroundCategories[section].label
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return backgroundCategories.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "TemplateCategoryViewCell", for: indexPath) as? TemplateCategoryViewCell {
            cell.collectionView.tag = indexPath.section
            cell.imageArray = backgroundsByCategory[backgroundCategories[indexPath.section].label] ?? []
            cell.backgroundViewControllerDelegate = backgroundViewControllerDelegate
            cell.collectionView.reloadData()
            return cell
        }
        
        
        return UITableViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
