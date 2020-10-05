//
//  PhotoEditor+UITextView.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit
import KMPlaceholderTextView

extension PhotoEditorViewController: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        let rotation = atan2(textView.transform.b, textView.transform.a)
        if rotation == 0 {
            let oldFrame = textView.frame
            let sizeToFit = textView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
            textView.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
        }
        
        if (textView.text.count == 0) {
            let oldFrame = textView.frame
            textView.frame.size = CGSize(width: oldFrame.width, height: 90)
        }
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        isTyping = true
        continueButton.isHidden = true
        doneButton.isHidden = false
        
        lastTextViewTransform =  textView.transform
        lastTextViewTransCenter = textView.center
        lastTextViewFont = textView.font!
        
        if (textView.text.count != 0) {
            colorsCollectionViewDelegate.initialColor = textView.textColor
            self.colorsCollectionView.reloadData()
            textSizeSlider.value = Float(textView.font!.pointSize)
            setFontStyleButton(fontIndex: fontIndex(fontName: textView.font!.fontName))
        }
        
        activeTextView = (textView as! KMPlaceholderTextView)
        textView.superview?.bringSubviewToFront(textView)
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.transform = CGAffineTransform.identity
                        textView.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                                                  y:  UIScreen.main.bounds.height / 5)
                       }, completion: {_ in
                        var sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.width - 40, height:CGFloat.greatestFiniteMagnitude))
                        
                        if (textView.text.count == 0) {
                            sizeToFit.height = 90
                        }
                        
                        textView.frame.size = CGSize(width: UIScreen.main.bounds.width - 40, height: sizeToFit.height)
                        
                        UIView.animate(withDuration: 0.1,
                                       animations: {
                                        textView.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                                                                  y:  UIScreen.main.bounds.height / 5)
                                       }, completion: nil)
                       })
        
        if let recognizers = activeTextView!.gestureRecognizers {
            for recognizer in recognizers {
                if let recognizer = recognizer as? UIPanGestureRecognizer {
                    textView.removeGestureRecognizer(recognizer)
                }
            }
        }
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        guard lastTextViewTransform != nil && lastTextViewTransCenter != nil && lastTextViewFont != nil
        else {
            return
        }
        
        activeTextView = nil
        
        if (textView.text.count == 0) {
            textView.removeFromSuperview()
            return
        }
        
        textView.font = self.lastTextViewFont!

        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.center = self.lastTextViewTransCenter!
                       }, completion: nil)
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(PhotoEditorViewController.panGesture))
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self        
        textView.addGestureRecognizer(panGesture)
    }
}
