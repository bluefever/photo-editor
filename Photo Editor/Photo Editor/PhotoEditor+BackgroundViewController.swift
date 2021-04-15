//
//  PhotoEditor+BackgroundViewController.swift
//  Pods
//
//  Created by Adam Podsiadlo on 17/07/2020.
//
//

import Foundation
import UIKit

extension PhotoEditorViewController {
    
    func addBackgroundViewController() {
        backgroundVCIsVisible = true
        backgroundViewController.backgroundViewControllerDelegate = self
        
        for color in self.bgColors {
            backgroundViewController.bgColors.append(color)
        }

        for image in self.bgImages {
            backgroundViewController.bgImages.append(image)
        }
        
        self.addChild(backgroundViewController)
        self.view.addSubview(backgroundViewController.view)
        backgroundViewController.didMove(toParent: self)
        let height = view.frame.height
        let width  = view.frame.width
        backgroundViewController.view.frame = CGRect(x: 0, y: self.view.frame.maxY , width: width, height: height)
    }
    
    func removeBackgroundView() {
        backgroundVCIsVisible = false
        self.canvasImageView.isUserInteractionEnabled = true
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { () -> Void in
                        var frame = self.backgroundViewController.view.frame
                        frame.origin.y = UIScreen.main.bounds.maxY
                        self.backgroundViewController.view.frame = frame
                        
        }, completion: { (finished) -> Void in
            self.backgroundViewController.view.removeFromSuperview()
            self.backgroundViewController.removeFromParent()
        })
    }    
}

extension PhotoEditorViewController: BackgroundViewControllerDelegate {
    func didSelectColorBackground(color: String) {
        self.removeBackgroundView()
        self.setBackgroundColor(color: color)
    }
    
    func didSelectImageBackground(image: String, index: Int) {
        self.removeBackgroundView()
        let matches = image.matchingStrings(regex: "(/backgroundThumbs%2F[a-zA-Z0-9_-]+).png")
        
        if (matches.count == 1 && matches[0].count == 2) {
            self.setBackgroundImage(image: image, internalId: (matches[0][1]).replacingOccurrences(of: "/backgroundThumbs%2F", with: ""))
        } else {
            let matches = image.matchingStrings(regex: "(/backgroundThumbs/[a-zA-Z0-9_-]+).png")

            if (matches.count == 1 && matches[0].count == 2) {
                self.setBackgroundImage(image: image, internalId: (matches[0][1]).replacingOccurrences(of: "/backgroundThumbs/", with: ""))
            }
        }
    }
    
    func backgroundViewDidDisappear() {
        backgroundVCIsVisible = false
    }
}
