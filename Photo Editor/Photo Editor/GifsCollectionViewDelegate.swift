//
//  EmojisCollectionViewDelegate.swift
//  Photo Editor
//
//  Created by Adam Podsiadlo on 21/07/2020.
//

import UIKit
import SwiftyGif
import CollectionViewWaterfallLayout

class GifsCollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, CollectionViewWaterfallLayoutDelegate {
    var gifsStickersViewControllerDelegate : GifsStickersViewControllerDelegate?
    
    let gifManager = SwiftyGifManager(memoryLimit:200)
    let width = (CGFloat) ((UIScreen.main.bounds.size.width - 30) / 2.0)
    var data: [GiphySizes] = []
    
    func randomizeContent() {
        data.shuffle()
    }
    
    func setData(data: [GiphySizes]) {
        self.data = data
    }
    
    func insertData(data: [GiphySizes]) {
        self.data.append(contentsOf: data)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastSectionIndex = collectionView.numberOfSections - 1
        let lastRowIndex = collectionView.numberOfItems(inSection: lastSectionIndex) - 1
        
        if indexPath.section == lastSectionIndex && indexPath.row == lastRowIndex {
            gifsStickersViewControllerDelegate?.onLoadMore()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let aspectRatio = CGFloat(Double((data[indexPath.item].preview_gif?.height)!)! / Double((data[indexPath.item].preview_gif?.width)!)!)
        
        return CGSize(width: width, height: width * aspectRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        gifsStickersViewControllerDelegate?.didSelectGif(gif: (data[indexPath.item].downsized?.url)!, width: Int((collectionView.cellForItem(at: indexPath)?.frame.width)!), height: Int((collectionView.cellForItem(at: indexPath)?.frame.height)!))
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "GifCollectionViewCell", for: indexPath) as! GifCollectionViewCell
        
        
        if let url = URL.init(string: (data[indexPath.item].preview_gif?.url)!) {
            let loader = UIActivityIndicatorView.init(style: .gray)
            cell.gifImageView.setGifFromURL(url, customLoader: loader)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let aspectRatio = CGFloat(Double((data[indexPath.item].preview_gif?.height)!)! / Double((data[indexPath.item].preview_gif?.width)!)!)
        
        return CGSize(width: width, height: width * aspectRatio)
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        let aspectRatio = CGFloat(Double((data[indexPath.item].preview_gif?.height)!)! / Double((data[indexPath.item].preview_gif?.width)!)!)
        
        return CGFloat(width * aspectRatio)
    }
}
