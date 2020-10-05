//
//  PhotoEditor+Controls.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit
import KMPlaceholderTextView

// MARK: - Control
public enum control: String {
    case crop
    case sticker
    case draw
    case text
    case save
    case share
    case clear
    
    public func string() -> String {
        return self.rawValue
    }
}

extension PhotoEditorViewController {
    
    //MARK: Top Toolbar
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if(self.isTyping) {
            closeTextTool()
        }
        
        let refreshAlert = UIAlertController(title: "Abandon your Note?", message: "Leaving now will delete this note forever.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Abandon", style: .default, handler: { (action: UIAlertAction!) in
            self.photoEditorDelegate?.canceledEditing()
            self.dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        
        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func cropButtonTapped(_ sender: UIButton) {
        let controller = CropViewController()
        controller.delegate = self
        controller.image = image
        let navController = UINavigationController(rootViewController: controller)
        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func stickersButtonTapped(_ sender: Any) {
        addGifsStickersViewController()
    }
    
    @IBAction func drawButtonTapped(_ sender: Any) {
        isDrawing = true
        canvasImageView.isUserInteractionEnabled = false
        doneButton.isHidden = false
        colorPickerView.isHidden = false
        hideToolbar(hide: true)
    }
    
    @IBAction func textButtonTapped(_ sender: Any) {
        openTextTool()
    }    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        closeTextTool()
    }
    
    //MARK: Bottom Toolbar
    
    @IBAction func saveButtonTapped(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(canvasView.toImage(),self, #selector(PhotoEditorViewController.image(_:withPotentialError:contextInfo:)), nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        let activity = UIActivityViewController(activityItems: [canvasView.toImage()], applicationActivities: nil)
        if let popoverController = activity.popoverPresentationController {
            popoverController.barButtonItem = UIBarButtonItem(customView: sender)
        }
        
        present(activity, animated: true, completion: nil)
        
    }
    
    @IBAction func clearButtonTapped(_ sender: AnyObject) {
        //clear drawing
        canvasImageView.image = nil
        //clear stickers and textviews
        for subview in canvasImageView.subviews {
            subview.removeFromSuperview()
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: Any) {
        hideToolbar(hide: true)
        cancelButton.isHidden = true
        
        let snapshot = self.view.toImage()
        let thumbnail = snapshot.cropToRect(rect: CGRect(x: Double(snapshot.size.width) * 0.1 / 2, y:Double(snapshot.size.height) * 0.5 / 2, width: Double(snapshot.size.width) * 0.9, height: Double(snapshot.size.height) * 0.5))
        
        photoEditorDelegate?.doneEditing(expression: exportExpression()!, image: thumbnail!)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundButtonPressed(_ sender: Any) {
        addBackgroundViewController()
    }
    
    @IBAction func onStylePressed(sender: UIButton) {
        setFontStyleButton(fontIndex: sender.tag)
    }
    
    func setFontStyleButton (fontIndex: Int) {
        font1Button.setTitleColor(UIColor.init(hexString: "#c1c1d1"), for: .normal)
        font2Button.setTitleColor(UIColor.init(hexString: "#c1c1d1"), for: .normal)
        font3Button.setTitleColor(UIColor.init(hexString: "#c1c1d1"), for: .normal)
        font4Button.setTitleColor(UIColor.init(hexString: "#c1c1d1"), for: .normal)
        
        if (fontIndex == 0) {
            font1Button.setTitleColor(UIColor.init(hexString: "#4e5156"), for: .normal)
            lastTextViewFont = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(Int(textSizeSlider.value)))
        } else if (fontIndex == 1) {
            font2Button.setTitleColor(UIColor.init(hexString: "#4e5156"), for: .normal)
            lastTextViewFont = UIFont(name: "BowlbyOneSC-Regular", size: CGFloat(Int(textSizeSlider.value)))
        }else if (fontIndex == 2) {
            font3Button.setTitleColor(UIColor.init(hexString: "#4e5156"), for: .normal)
            lastTextViewFont = UIFont(name: "ShadowsIntoLight", size: CGFloat(Int(textSizeSlider.value)))
        } else if (fontIndex == 3) {
            font4Button.setTitleColor(UIColor.init(hexString: "#4e5156"), for: .normal)
            lastTextViewFont = UIFont(name: "ZillaSlabHighlight-Bold", size: CGFloat(Int(textSizeSlider.value)))
        }
        
        activeTextView?.font = lastTextViewFont
        
        if let textView = activeTextView {
            let oldFrame = textView.frame
            var sizeToFit = textView.sizeThatFits(CGSize(width: oldFrame.width, height:CGFloat.greatestFiniteMagnitude))
            
            if (textView.text.count == 0) {
                sizeToFit.height = 90
            }
            
            textView.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
        }
    }
    
    //MAKR: helper methods
    
    @objc func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Image Saved", message: "Image successfully saved to Photos library", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func closeTextTool () {
        view.endEditing(true)
        doneButton.isHidden = true
        colorPickerView.isHidden = true
        canvasImageView.isUserInteractionEnabled = true
        hideToolbar(hide: false)
        isDrawing = false
        
        if (activeTextView != nil && activeTextView!.text.isEmpty) {
            activeTextView?.isHidden = true
        }
    }
    
    func openTextTool () {
        if (activeTextView == nil || !self.canvasImageView.subviews.contains(activeTextView!)) {
            isTyping = true
            textSizeSlider.value = 20
            textColor = UIColor.black
            setFontStyleButton(fontIndex: 0)
            if (colorsCollectionViewDelegate != nil) {
                colorsCollectionViewDelegate.initialColor = UIColor.black
                colorsCollectionView.reloadData()
            }
            
            let textView = KMPlaceholderTextView(frame: CGRect(x: 0, y: 0,
                                                               width: UIScreen.main.bounds.width - 40, height: 90))
            textView.textAlignment = .center
            textView.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
            textView.textColor = textColor
            textView.layer.backgroundColor = UIColor.clear.cgColor
            textView.autocorrectionType = .no
            textView.isScrollEnabled = false
            textView.delegate = self
            textView.placeholder = "Start typing here or skip by tapping ‘DONE’ and browse ‘Backgrounds’ for some inspo.."
            textView.placeholderColor = UIColor.init(hexString: "#c1c1d1")
            textView.placeholderFont = UIFont(name: "Nunito-SemiBold", size: 20)
            
            
            let view = UIView(frame:  CGRect(x: 20, y: canvasImageView.center.y,
                                             width: UIScreen.main.bounds.width - 40, height: 90))
            self.canvasImageView.addSubview(view)
            view.addSubview(textView)
//            view.backgroundColor = UIColor.red
            addGestures(view: view)
            textView.becomeFirstResponder()
            
            let oldFrame = textView.frame
            textView.frame.size = CGSize(width: oldFrame.width, height: 90)
        } else {
            activeTextView?.becomeFirstResponder()
            activeTextView?.isHidden = false
        }
    }
    
    func hideControls() {
        let controls = hiddenControls
        
        for control in controls {
            if (control == "clear") {
                clearButton.isHidden = true
            } else if (control == "crop") {
                cropButton.isHidden = true
            } else if (control == "draw") {
                drawButton.isHidden = true
            } else if (control == "save") {
                saveButton.isHidden = true
            } else if (control == "share") {
                shareButton.isHidden = true
            } else if (control == "sticker") {
                stickerButton.isHidden = true
            } else if (control == "text") {
                textButton.isHidden = true
            }
        }
    }
}
