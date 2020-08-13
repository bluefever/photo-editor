//
//  PhotoEditor+Controls.swift
//  Pods
//
//  Created by Mohamed Hamed on 6/16/17.
//
//

import Foundation
import UIKit

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
        
        let refreshAlert = UIAlertController(title: "Abandon your Expression", message: "Leaving mid-edit just deletes your in-progress Expression.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
            self.photoEditorDelegate?.canceledEditing()
            self.dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
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
            lastTextViewFont = UIFont(name: "sweetpurple", size: CGFloat(Int(textSizeSlider.value)))
        } else if (fontIndex == 3) {
            font4Button.setTitleColor(UIColor.init(hexString: "#4e5156"), for: .normal)
            lastTextViewFont = UIFont(name: "ZillaSlabHighlight-Bold", size: CGFloat(Int(textSizeSlider.value)))
        }
        
        activeTextView?.font = lastTextViewFont
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
    }
    
    func openTextTool () {
        hideToolbar(hide: true)
        // For V1 only one text is available, to use multiple texts remove if / else case
        if (activeTextView == nil || !self.canvasImageView.subviews.contains(activeTextView!)) {
            isTyping = true
            let textView = UITextView(frame: CGRect(x: 0, y: canvasImageView.center.y,
                                                    width: UIScreen.main.bounds.width, height: 30))
            
            textView.textAlignment = .center
            textView.font = UIFont(name: "HelveticaNeue-Medium", size: 30)
            textView.textColor = textColor
            textView.layer.backgroundColor = UIColor.clear.cgColor
            textView.autocorrectionType = .no
            textView.isScrollEnabled = false
            textView.delegate = self
            self.canvasImageView.addSubview(textView)
            addGestures(view: textView)
            textView.becomeFirstResponder()
        } else {
            activeTextView?.becomeFirstResponder()
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
