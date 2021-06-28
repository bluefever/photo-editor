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
            textView.superview?.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
        }
        
        if (textView.text.count == 0) {
            let oldFrame = textView.frame
            textView.frame.size = CGSize(width: oldFrame.width, height: 90)
            textView.superview?.frame.size = CGSize(width: oldFrame.width, height: 90)
        }
    }
    public func textViewDidBeginEditing(_ textView: UITextView) {
        selectTextStyle()
        
        isTyping = true
        continueButton.isHidden = true
        doneButton.isHidden = false
        
        lastTextViewTransform =  textView.superview?.transform
        lastTextViewTransCenter = textView.superview?.center
        lastTextViewFont = textView.font!
        
        if (textView.text.count != 0) {
            colorsCollectionViewDelegate.initialColor = textView.textColor
            self.colorsCollectionView.reloadData()
            textSizeSlider.value = Float(textView.font!.pointSize)
            setFontStyleButton(fontIndex: fontIndex(fontName: textView.font!.fontName))
            setAlignButton(align: textView.textAlignment)
        }
        
        activeTextView = (textView as! KMPlaceholderTextView)
        textView.superview?.bringSubviewToFront(textView)
        canvasImageView.bringSubviewToFront(textView.superview!)
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.superview!.transform = CGAffineTransform.identity
                        textView.superview!.center = CGPoint(x: UIScreen.main.bounds.width / 2,
                                                             y:  UIScreen.main.bounds.height / 5)
                       }, completion: nil)
        
        if let recognizers = activeTextView!.superview!.gestureRecognizers {
            for recognizer in recognizers {
                if let recognizer = recognizer as? UIPanGestureRecognizer {
                    activeTextView!.superview!.removeGestureRecognizer(recognizer)
                }
            }
        }
        
        onTextToolOpen()
        canvasImageView.superview?.bringSubviewToFront(activeTextView!)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        guard lastTextViewTransform != nil && lastTextViewTransCenter != nil && lastTextViewFont != nil
        else {
            return
        }
        
        activeTextView = nil
        
        if (textView.text.count == 0) {
            textView.removeFromSuperview()
            onTextToolClose()
            return
        }
        
        textView.font = self.lastTextViewFont!
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.superview!.transform = self.lastTextViewTransform!
                        textView.superview!.center = self.lastTextViewTransCenter!
                       }, completion: nil)
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(PhotoEditorViewController.panGesture))
        panGesture.delegate = self
        textView.superview!.addGestureRecognizer(panGesture)
        
        onTextToolClose()
    }
    
    public func onTextToolOpen() {
        cancelButton.isHidden = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoEditorViewController.tapGesture))
        canvasImageView.addGestureRecognizer(tapGesture)
        
        let opacityCanvas = UIView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        opacityCanvas.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        opacityCanvas.tag = 100
        canvasImageView.insertSubview(opacityCanvas, at: 0)
        
        let canvasImageViewFrame = canvasImageView.superview?.convert(canvasImageView.frame.origin, to: nil)
        
        let opacityTopToolbar = UIView.init(frame: CGRect.init(x: 0, y: 0, width: topToolbar.frame.width, height: canvasImageViewFrame!.y))
        opacityTopToolbar.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        opacityTopToolbar.tag = 100
        
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(PhotoEditorViewController.swipeGesture))
        swipeGesture.direction = .down
        opacityCanvas.addGestureRecognizer(swipeGesture)
        
        self.view.insertSubview(opacityTopToolbar, at: 4)
        self.view.superview?.bringSubviewToFront(topToolbar)
    }
    
    public func onTextToolClose() {
        cancelButton.isHidden = false
        
        if let recognizers = canvasImageView!.superview!.gestureRecognizers {
            for recognizer in recognizers {
                if let recognizer = recognizer as? UITapGestureRecognizer {
                    canvasImageView!.superview!.removeGestureRecognizer(recognizer)
                }
            }
        }
        
        let opacityCanvas = canvasImageView.viewWithTag(100)
        opacityCanvas!.removeFromSuperview()
        
        let opacityTopToolbar = self.view.viewWithTag(100)
        opacityTopToolbar!.removeFromSuperview()
        
        enableNextButton()
    }
}
