//
//  TemplateCollectionViewCell.swift
//  iOSPhotoEditor
//
//  Created by Adam Podsiadlo on 08/06/2021.
//

import Foundation

import UIKit
class TemplateCategoryViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var collectionView: UICollectionView!
    
    var backgroundViewControllerDelegate : BackgroundViewControllerDelegate?
    var imageArray = [Background] ()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 12)
        
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.collectionViewLayout = layout
        self.collectionView.register(UINib(nibName: "ImageCollectionViewCell", bundle: Bundle(for: ImageCollectionViewCell.self)), forCellWithReuseIdentifier: "ImageCollectionViewCell")
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let url = imageArray[indexPath.section].url {
            backgroundViewControllerDelegate?.didSelectImageBackground(image: url)
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as? ImageCollectionViewCell {
            if let url = imageArray[indexPath.section].url {
                cell.image.load(url: url)
               
                let path = UIBezierPath(roundedRect: cell.bounds,
                                        byRoundingCorners: [.topRight, .bottomRight],
                                        cornerRadii: CGSize(width: 24, height: 24))
                
                let maskLayer = CAShapeLayer()
                
                maskLayer.path = path.cgPath
                cell.layer.mask = maskLayer
                
                cell.layer.borderWidth = 0.75
                cell.layer.borderColor = UIColor.init(hexString: "#EEEEEE").cgColor
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    } 
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let size = CGSize(width: 120, height: collectionView.frame.size.height)
        
        return size
    }
}
