//
//  Extensions.swift
//  iOSPhotoEditor
//
//  Created by Adam Podsiadlo on 20/07/2020.
//

import UIKit

extension UIImageView {
    func load(url: String) {
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: URL(string: url)!) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
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
