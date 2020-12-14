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
    @IBAction func onTopTextButtonTapped(_ sender: UIButton) {
        switch(sender.tag) {
        case 0:
            selectTextSize()
            break
        case 1:
            selectTextStyle()
            break
        case 2:
            selectTextColor()
            break
        default:
            return
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        if(self.isTyping) {
            closeTextTool()
        }
        
        let refreshAlert = UIAlertController(title: "Abandon your Note?", message: "Leaving now will delete this note forever.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Abandon", style: .default, handler: { (action: UIAlertAction!) in
            self.photoEditorDelegate?.canceledEditing()
//            self.dismiss(animated: true, completion: nil)
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "Keep Editing", style: .cancel, handler: { (action: UIAlertAction!) in
            refreshAlert.dismiss(animated: true, completion: nil)
        }))
        
//        present(refreshAlert, animated: true, completion: nil)
        
    }
    
    @IBAction func cropButtonTapped(_ sender: UIButton) {
        let controller = CropViewController()
        controller.delegate = self
        controller.image = image
        let navController = UINavigationController(rootViewController: controller)
//        present(navController, animated: true, completion: nil)
    }
    
    @IBAction func stickersButtonTapped(_ sender: Any) {
        addGifsStickersViewController()
    }
    
    @IBAction func drawButtonTapped(_ sender: Any) {
        isDrawing = true
        canvasImageView.isUserInteractionEnabled = false
        doneButton.isHidden = false
        colorPickerView.isHidden = false
        topTextControl.isHidden = false
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
        
//        present(activity, animated: true, completion: nil)
        
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
        
        let snapshot = self.toImage()
        let thumbnail = snapshot.cropToRect(rect: CGRect(x: Double(snapshot.size.width) * 0.1 / 2, y:Double(snapshot.size.height) * 0.5 / 2, width: Double(snapshot.size.width) * 0.9, height: Double(snapshot.size.height) * 0.5))
        
        photoEditorDelegate?.doneEditing(expression: exportExpression()!, image: thumbnail!)
//        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backgroundButtonPressed(_ sender: Any) {
        addBackgroundViewController()
    }
    
    @IBAction func onStylePressed(sender: UIButton) {
        setFontStyleButton(fontIndex: sender.tag)
    }
    
    @IBAction func onAlignPressed(sender: UIButton) {
        if let textView = activeTextView {
            if (textView.textAlignment == .center) {
                styleAlignButton.setImage((UIImage(named: "icon_align_right", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
                textView.textAlignment = .right
            } else if (textView.textAlignment == .left) {
                styleAlignButton.setImage((UIImage(named: "icon_align_center", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
                textView.textAlignment = .center
            } else if (textView.textAlignment == .right) {
                styleAlignButton.setImage((UIImage(named: "icon_align_left", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
                textView.textAlignment = .left
            }
        }
    }
    
    func setAlignButton(align: NSTextAlignment) {
        if (align == .center) {
            styleAlignButton.setImage((UIImage(named: "icon_align_center", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        } else if (align == .left) {
            styleAlignButton.setImage((UIImage(named: "icon_align_left", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        } else if (align == .right) {
            styleAlignButton.setImage((UIImage(named: "icon_align_right", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        }
    }
    
    func setFontStyleButton (fontIndex: Int) {
        styleFont1Button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        styleFont1Button.setTitleColor(UIColor.white, for: .normal)
        
        styleFont2Button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        styleFont2Button.setTitleColor(UIColor.white, for: .normal)
        
        styleFont3Button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        styleFont3Button.setTitleColor(UIColor.white, for: .normal)
        
        styleFont4Button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        styleFont4Button.setTitleColor(UIColor.white, for: .normal)
        
        styleFont5Button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        styleFont5Button.setTitleColor(UIColor.white, for: .normal)
        
        styleFont6Button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        styleFont6Button.setTitleColor(UIColor.white, for: .normal)
        
        
        if (fontIndex == 0) {
            styleFont1Button.backgroundColor = UIColor.white
            styleFont1Button.setTitleColor(UIColor.black, for: .normal)
            lastTextViewFont = UIFont(name: "HelveticaNeue-Medium", size: CGFloat(Int(textSizeSlider.value)))
        } else if (fontIndex == 1) {
            styleFont2Button.backgroundColor = UIColor.white
            styleFont2Button.setTitleColor(UIColor.black, for: .normal)
            lastTextViewFont = UIFont(name: "BowlbyOneSC-Regular", size: CGFloat(Int(textSizeSlider.value)))
        } else if (fontIndex == 2) {
            styleFont3Button.backgroundColor = UIColor.white
            styleFont3Button.setTitleColor(UIColor.black, for: .normal)
            lastTextViewFont = UIFont(name: "Cheria", size: CGFloat(Int(textSizeSlider.value)))
        } else if (fontIndex == 3) {
            styleFont4Button.backgroundColor = UIColor.white
            styleFont4Button.setTitleColor(UIColor.black, for: .normal)
            lastTextViewFont = UIFont(name: "SundayMorningRegular", size: CGFloat(Int(textSizeSlider.value)))
        } else if (fontIndex == 4) {
            styleFont5Button.backgroundColor = UIColor.white
            styleFont5Button.setTitleColor(UIColor.black, for: .normal)
            lastTextViewFont = UIFont(name: "FastInMyCar", size: CGFloat(Int(textSizeSlider.value)))
        } else if (fontIndex == 5) {
            styleFont6Button.backgroundColor = UIColor.white
            styleFont6Button.setTitleColor(UIColor.black, for: .normal)
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
            textView.superview?.frame.size = CGSize(width: oldFrame.width, height: sizeToFit.height)
        }
    }
    
    //MAKR: helper methods
    
    @objc func image(_ image: UIImage, withPotentialError error: NSErrorPointer, contextInfo: UnsafeRawPointer) {
        let alert = UIAlertController(title: "Image Saved", message: "Image successfully saved to Photos library", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
//        self.present(alert, animated: true, completion: nil)
    }
    
    func closeTextTool () {
        endEditing(true)
        doneButton.isHidden = true
        colorPickerView.isHidden = true
        topTextControl.isHidden = true
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
            setAlignButton(align: .left)
            if (colorsCollectionViewDelegate != nil) {
                colorsCollectionViewDelegate.initialColor = UIColor.black
                colorsCollectionView.reloadData()
            }
            
            let textView = KMPlaceholderTextView(frame: CGRect(x: 0, y: 0,
                                                               width: UIScreen.main.bounds.width - 40, height: 90))
            textView.textAlignment = .left
            textView.font = UIFont(name: "HelveticaNeue-Medium", size: 20)
            textView.textColor = textColor
            textView.layer.backgroundColor = UIColor.clear.cgColor
            textView.autocorrectionType = .no
            textView.isScrollEnabled = false
            textView.delegate = self
            textView.placeholder = "Start typing here or skip by tapping ‘DONE’ and browse ‘Backgrounds’ for some inspo.."
            textView.placeholderColor = UIColor.init(hexString: "#fff")
            textView.placeholderFont = UIFont(name: "Nunito-SemiBold", size: 20)
            
            
            let view = UIView(frame:  CGRect(x: 20, y: canvasImageView.center.y - topToolbar.frame.height,
                                             width: UIScreen.main.bounds.width - 40, height: 90))
            self.canvasImageView.addSubview(view)
            view.addSubview(textView)
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
    
    func selectTextSize() {
        topTextSizeButton.setImage((UIImage(named: "size_on", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        topTextStyleButton.setImage((UIImage(named: "text_off", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        topTextColorButton.setImage((UIImage(named: "color_off", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        bottomSizeContainer.isHidden = false
        bottomStyleContainer.isHidden = true
//        bottomColorContainer.isHidden = true
        topTextSizeButton.addShadow()
        topTextStyleButton.removeShadow()
        topTextColorButton.removeShadow()
    }
    
    func selectTextStyle() {
        topTextSizeButton.setImage((UIImage(named: "size_off", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        topTextStyleButton.setImage((UIImage(named: "text_on", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        topTextColorButton.setImage((UIImage(named: "color_off", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        bottomSizeContainer.isHidden = true
        bottomStyleContainer.isHidden = false
//        bottomColorContainer.isHidden = true
        topTextSizeButton.removeShadow()
        topTextStyleButton.addShadow()
        topTextColorButton.removeShadow()
    }
    
    func selectTextColor() {
        topTextSizeButton.setImage((UIImage(named: "size_off", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        topTextStyleButton.setImage((UIImage(named: "text_off", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        topTextColorButton.setImage((UIImage(named: "color_on", in: Bundle(for: type(of: self)), compatibleWith: nil)!), for: .normal)
        bottomSizeContainer.isHidden = true
        bottomStyleContainer.isHidden = true
//        bottomColorContainer.isHidden = false
        topTextSizeButton.removeShadow()
        topTextStyleButton.removeShadow()
        topTextColorButton.addShadow()
    }
}
