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
        print(keyboardSize)
        if (textView.frame.height >= canvasView.frame.height - keyboardSize + 40) {
            let oldFrame = textView.frame.size
            textView.frame.size = CGSize(width: oldFrame.width, height: canvasView.frame.height - keyboardSize + 40)
        } else {
            let oldFrame = textView.frame
            let sizeToFit = textView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
            textView.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
            textView.superview?.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
        }
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        selectTextStyle()
        
        isTyping = true
        continueButton.isHidden = true
        doneButton.isHidden = false
        textView.isScrollEnabled = true
        
        lastTextViewFrame = textView.superview?.frame.origin
        lastTextViewTransform =  textView.superview?.transform
        lastTextViewTransCenter = textView.superview?.center
        lastTextViewFont = textView.font!
        
        
        if (!textView.text.isEmpty) {
            let oldFrame = textView.frame
            let sizeToFit = textView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
            textView.frame.size = CGSize(width: UIScreen.main.bounds.width, height: sizeToFit.height)
            textView.superview?.frame.size = CGSize(width: UIScreen.main.bounds.width, height: sizeToFit.height)
            isNewText = false
        } else {
            isNewText = true
        }
        
        if (textView.text.count != 0) {
            colorsCollectionViewDelegate.initialColor = textView.textColor
            self.colorsCollectionView.reloadData()
            textSizeSlider.value = Float(textView.font!.pointSize)
            setFontStyleButton(fontIndex: fontIndex(fontName: textView.font!.fontName))
            setAlignButton(align: textView.textAlignment)
        }
        
        activeTextView = (textView as! KMPlaceholderTextView)
        activeTextView?.clearAttributes()
        
        textView.superview?.bringSubviewToFront(textView)
        canvasImageView.bringSubviewToFront(textView.superview!)
        
        UIView.animate(withDuration: 0.3,
                       animations: {
                        textView.superview!.transform = CGAffineTransform.identity
                        textView.superview!.frame = CGRect(x: 0, y: 0,
                                       width: textView.frame.width, height: textView.frame.height)
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
        
        if (activeTextView != nil) {
            let oldFrame = activeTextView?.frame

            let sizeToFit = activeTextView?.sizeThatFits(CGSize(width: oldFrame!.width, height:CGFloat.greatestFiniteMagnitude))
            activeTextView?.frame.size = CGSize(width: sizeToFit!.width, height: sizeToFit!.height)
            activeTextView?.superview?.frame.size = CGSize(width: sizeToFit!.width, height: sizeToFit!.height)
        }
        
        activeTextView = nil
        
        if (textView.text.count == 0) {
            textView.removeFromSuperview()
            onTextToolClose()
            return
        }
        
        textView.font = self.lastTextViewFont!
        textView.isScrollEnabled = false
        
        if (!isNewText) {
            let transformPoint = __CGPointApplyAffineTransform(self.lastTextViewFrame!, self.lastTextViewTransform!)
            
            if (self.lastTextViewFrame!.x != transformPoint.x) {
                UIView.animate(withDuration: 0.3,
                           animations: {
                            textView.superview!.transform = self.lastTextViewTransform!
                            textView.superview!.center = self.lastTextViewTransCenter!
                           }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3,
                           animations: {
                            textView.superview!.transform = self.lastTextViewTransform!
                            textView.superview!.frame.origin.x = self.lastTextViewFrame!.x
                            textView.superview!.frame.origin.y = self.lastTextViewFrame!.y
                           }, completion: nil)
            }
        }
        
        let panGesture = UIPanGestureRecognizer(target: self,
                                                action: #selector(PhotoEditorViewController.panGesture))
        panGesture.delegate = self
        textView.superview!.addGestureRecognizer(panGesture)
        
        onTextToolClose()
    }
    
    public func onTextToolOpen() {
        alertButton.isHidden = true
        cancelButton.isHidden = true
        
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
        
        if let recognizers = canvasImageView.superview?.gestureRecognizers {
            for recognizer in recognizers {
                if let recognizer = recognizer as? UITapGestureRecognizer {
                    canvasImageView.superview?.removeGestureRecognizer(recognizer)
                }
            }
        }
        
        if let opacityCanvas = canvasImageView.viewWithTag(100) {
            opacityCanvas.removeFromSuperview()
        }
        
        if let opacityTopToolbar = self.view.viewWithTag(100) {
            opacityTopToolbar.removeFromSuperview()
        }
        
        enableNextButton()
    }
}
