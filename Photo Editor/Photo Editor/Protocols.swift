//
//  Protocols.swift
//  Photo Editor
//
//  Created by Mohamed Hamed on 6/15/17.
//
//

import Foundation
import UIKit
/**
 - didSelectView
 - didSelectImage
 - stickersViewDidDisappear
 */

@objc public protocol PhotoEditorDelegate {
    /**
     - Parameter expression: json expression data
     - Parameter image: expression thumbnail
     */
     func doneEditing(expression: String, image: UIImage)
    /**
     StickersViewController did Disappear
     */
    func canceledEditing(edited: Bool)
}


/**
 - didSelectView
 - didSelectImage
 - stickersViewDidDisappear
 */
@objc public protocol  GifsStickersViewControllerDelegate {
    /**
     - Parameter image: selected Gif from GifsStickersViewController
     */
    func didSelectGif(gif: String, width: Int, height: Int)
    /**
     GifsStickersViewController on load more data
    */
    func onLoadMore()
    /**
     GifsStickersViewController did Disappear
     */
    func stickersViewDidDisappear()
}

/**
- didSelectColorBackground
- didSelectImageBackground
- backgroundViewDidDisappear
*/
protocol BackgroundViewControllerDelegate {
    /**
     - Parameter color: selected color from BackgroundViewController
     */
    func didSelectColorBackground(color: String)
    /**
     - Parameter image: selected image from BackgroundViewController
     */
    func didSelectImageBackground(image: String)
    /**
     BackgroundViewController did Disappear
     */
    func backgroundViewDidDisappear()
}


/**
 - didSelectColor
 */
protocol ColorDelegate {
    func didSelectColor(color: UIColor)
}

protocol GiphyApiManagerDelegate {
    func onLoadData(data: [GiphySizes], type: GiphyType)
    func onLoadMoreData(data: [GiphySizes], type: GiphyType)
}
