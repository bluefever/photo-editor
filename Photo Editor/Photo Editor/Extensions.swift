//
//  Extensions.swift
//  iOSPhotoEditor
//
//  Created by Adam Podsiadlo on 20/07/2020.
//

import UIKit
import KMPlaceholderTextView

var imageCache = NSCache<AnyObject, AnyObject>()

extension KMPlaceholderTextView {
    func alignmentToString() -> String {
        if (textAlignment == .center) {
            return "center"
        } else if (textAlignment == .left) {
            return "left"
        }

        return "right"
    }
    
    func alignmentFromString(alignment: String?) {
        if (alignment == "right") {
            textAlignment = .right
        } else if (alignment == "left") {
            textAlignment = .left
        } else {
            textAlignment = .center
        }
    }
}

extension UIImage {
    func imageWithSize(size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContext(size)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size

        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }

        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage!
    }
    
    func cropToRect(rect: CGRect!) -> UIImage? {
        let scaledRect = CGRect(x: rect.origin.x * self.scale, y: rect.origin.y * self.scale, width: rect.size.width * self.scale, height: rect.size.height * self.scale);
        
        let imageRef = self.cgImage!.cropping(to: scaledRect);
        let result = UIImage(cgImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        
        return result;
    }
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    var hexString: String? {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
}

extension UIViewController {
    static let insetBackgroundViewTag = 98721
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func paintSafeAreaBottomInset(withColor color: UIColor) {
        guard #available(iOS 11.0, *) else {
            return
        }
        if let insetView = view.viewWithTag(UIViewController.insetBackgroundViewTag) {
            insetView.backgroundColor = color
            return
        }
        
        let insetView = UIView(frame: .zero)
        insetView.tag = UIViewController.insetBackgroundViewTag
        insetView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(insetView)
        view.bringSubviewToFront(insetView)
        
        insetView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        insetView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        insetView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        insetView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        insetView.backgroundColor = color
    }
}

extension CGFloat {
    init?(_ str: String) {
        guard let float = Float(str) else { return nil }
        self = CGFloat(float)
    }
}

extension String {
    func matchingStrings(regex: String) -> [[String]] {
        guard let regex = try? NSRegularExpression(pattern: regex, options: []) else { return [] }
        let nsString = self as NSString
        let results  = regex.matches(in: self, options: [], range: NSMakeRange(0, nsString.length))
        return results.map { result in
            (0..<result.numberOfRanges).map {
                result.range(at: $0).location != NSNotFound
                    ? nsString.substring(with: result.range(at: $0))
                    : ""
            }
        }
    }
}

extension UIButton {
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.6
        self.layer.shadowRadius = 4.0
        self.layer.masksToBounds = false
    }
    
    func addTopBtnShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3.0
        self.layer.masksToBounds = false
    }
    
    
    func removeShadow() {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
    func addViewShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.3
        self.layer.shadowRadius = 3.0
        self.layer.masksToBounds = false
    }
    
    func blink() {
     self.alpha = 0.2
     UIView.animate(withDuration: 1, delay: 0.0, options: .curveLinear, animations: {self.alpha = 1.0}, completion: nil)
    }
    
    func fadeIn(duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in }) {
        self.alpha = 0.0

        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.isHidden = false
            self.alpha = 1.0
        }, completion: completion)
    }

    func fadeOut(duration: TimeInterval = 0.1, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in }) {
        self.alpha = 1.0

        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
        }) { (completed) in
            self.isHidden = true
            completion(true)
        }
    }
}

extension UILabel {
    func highlight(searchedText: String) {
        let attributed: NSMutableAttributedString
        
        if let attrText = self.attributedText {
            attributed = NSMutableAttributedString(attributedString: attrText)
        } else {
            attributed = NSMutableAttributedString(string: self.text!)
        }
        
        let searchPattern = NSRegularExpression.escapedPattern(for: searchedText)
        let regex = try! NSRegularExpression(pattern: searchPattern, options: .caseInsensitive)
        
        let attrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.single.rawValue]

        for match in regex.matches(in: self.text!, range: NSRange(0..<self.text!.utf16.count)) {
            attributed.addAttributes(attrs, range: match.range)
        }
        
        self.attributedText = attributed
   }
}

extension KMPlaceholderTextView {
    func highlight(searchedText: String) {
        let attributed: NSMutableAttributedString
        
        if let attrText = self.attributedText {
            attributed = NSMutableAttributedString(attributedString: attrText)
        } else {
            attributed = NSMutableAttributedString(string: text)
        }
        
        let searchPattern = "\\b"+NSRegularExpression.escapedPattern(for: searchedText)+"\\b"
        let regex = try! NSRegularExpression(pattern: searchPattern, options: .caseInsensitive)
        
        let attrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.single.rawValue]

        for match in regex.matches(in: self.text, range: NSRange(0..<self.text.utf16.count)) {
            attributed.addAttributes(attrs, range: match.range)
            
            if (self.font.fontName == "ZillaSlabHighlight-Bold") {
                attributed.addAttributes([NSAttributedString.Key.font: UIFont(name: "ZillaSlab-Bold", size: CGFloat(self.font.pointSize))!], range: match.range)
            }
        }
        
        self.attributedText = attributed
   }
    
    func highlightAt(searchedText: String) {
        let attributed: NSMutableAttributedString
        
        if let attrText = self.attributedText {
            attributed = NSMutableAttributedString(attributedString: attrText)
        } else {
            attributed = NSMutableAttributedString(string: text)
        }
        
        let specialCharacterRegEx  = "[@]"
        let regex = try! NSRegularExpression(pattern: specialCharacterRegEx, options: .caseInsensitive)
        let attrs = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.single.rawValue]

        for match in regex.matches(in: self.text, range: NSRange(0..<self.text.utf16.count)) {
            attributed.addAttributes(attrs, range: match.range)
            
            if (self.font.fontName == "ZillaSlabHighlight-Bold") {
                attributed.addAttributes([NSAttributedString.Key.font: UIFont(name: "ZillaSlab-Bold", size: CGFloat(self.font.pointSize))!], range: match.range)
            }
        }
        
        self.attributedText = attributed
    }
    
    func clearAttributes() {
        let attrText = NSMutableAttributedString(attributedString: attributedText)
        attrText.addAttributes([NSAttributedString.Key.font: UIFont(name: self.font.fontName, size: CGFloat(self.font.pointSize))!], range: NSMakeRange(0, attrText.length))
        attrText.removeAttribute(NSAttributedString.Key.underlineStyle, range: NSMakeRange(0, attrText.length))
        self.attributedText = attrText
    }
}

extension String {
    func ranges(of substring: String, options: CompareOptions = [], locale: Locale? = nil) -> [Range<Index>] {
        var ranges: [Range<Index>] = []
        while let range = range(of: substring, options: options, range: (ranges.last?.upperBound ?? self.startIndex)..<self.endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}
