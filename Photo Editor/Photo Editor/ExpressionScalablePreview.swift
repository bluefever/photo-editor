//
//  ExpressionScalablePreview.swift
//
//  Created by Adam Podsiadlo on 27/01/2021.
//

import Foundation
import KMPlaceholderTextView

open class ExpressionScalablePreview: UIView {
    @objc open var data: String? = nil
    @objc open var bgImages: [String] = []
    
    var imported: Bool = false
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if (!imported) {
            imported = true
            importExpression()
        }
    }
    
    func pointToAspectFill(for point: Point, in bgSize: OriginalFrame) -> CGPoint {
        let aspectRatio = bgSize.width / self.frame.width
        let yOffset = ((bgSize.height / aspectRatio) - self.frame.height) / 2.0
        
        return CGPoint(
            x: (point.x / aspectRatio),
            y: (point.y / aspectRatio) - yOffset)
    }
    
    func importExpression () {
        self.clipsToBounds = true
        var imageBg: UIImageView? = nil
        let jsonData = data!.data(using: .utf8)!
        var expression: Expression? = nil
        
        do {
            expression = try JSONDecoder().decode(Expression.self, from: jsonData)
        } catch {
            print(error)
        }
        
        if var expressionData = expression {
            let bounds = self.bounds
            var scaleX = CGFloat(1)
            var scaleY = CGFloat(1)
            
            if (expressionData.originalFrame != nil) {
                scaleX = bounds.width / expressionData.originalFrame!.width
                scaleY = bounds.height / expressionData.originalFrame!.height
            }
            
            if let bgColor = expressionData.backgroundColor {
                self.backgroundColor = UIColor(hexString: bgColor)
            } else if let bgImage = expressionData.backgroundImage {
                imageBg = UIImageView.init(frame: CGRect(x:0, y:0, width: bounds.width, height: bounds.height))
                var bgUrl: String?
                
                for url in bgImages {
                    if (url.matchingStrings(regex: bgImage + ".png").count > 0) {
                        bgUrl = url
                    }
                }
                
                imageBg!.contentMode = .scaleAspectFill
                
                if let url = bgUrl {
                    imageBg!.load(url: url)
                    self.addSubview(imageBg!)
                    self.sendSubviewToBack(imageBg!)
                } else {
                    addDefaultBg()
                }
            } else {
                addDefaultBg()
            }
            
            expressionData.layers.sort{ $0.zIndex < $1.zIndex }
            
            for layer in expressionData.layers {
                var centerX = CGFloat(1)
                var centerY = CGFloat(1)
                
                if (expressionData.originalFrame != nil) {
                    centerX = layer.center.x * scaleX
                    centerY = layer.center.y * scaleY
                } else {
                    centerX = self.bounds.width / 2
                    centerY = self.bounds.height / 2
                }
                
                if let backgroundSize = expression?.backgroundSize {
                    centerX = pointToAspectFill(for: layer.center, in: backgroundSize).x
                    centerY = pointToAspectFill(for: layer.center, in: backgroundSize).y
                }
                
                if let text = layer.text {
                    addTextObject(text: text, font: layer.textStyle!, color: UIColor.init(hexString: layer.textColor!), textSize: layer.textSize! * scaleX, textAlignment: layer.textAlign,
                                  x: centerX, y: centerY, transform: layer.transform)
                } else if let gifUrl = layer.contentUrl {
                    addGifObject(contentUrl: gifUrl, x: centerX, y: centerY, size: CGSize.init(width: layer.size!.width * scaleX, height: layer.size!.height * scaleY), transform: layer.transform!)
                }
            }
        }
    }
    
    func addDefaultBg () {
        let imageView: UIImageView = UIImageView.init(frame: CGRect(x:0, y:0, width: bounds.width, height: bounds.height))
        imageView.image = UIImage(named: "default_bg", in: Bundle(for: type(of: self)), compatibleWith: nil)!
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        self.sendSubviewToBack(imageView)
    }
    
    func addGifObject (contentUrl: String, x: CGFloat, y: CGFloat, size: CGSize, transform: Transform) {
        let imageView: UIImageView = UIImageView()
        let loader = UIActivityIndicatorView.init(style: .gray)
        
        imageView.setGifFromURL(URL.init(string: contentUrl)!, customLoader: loader)
        imageView.contentMode = .scaleAspectFit
        imageView.frame.size = size
        imageView.center = CGPoint.init(x: x, y: y)
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        
        imageView.transform = CGAffineTransform.init(a: transform.a, b: transform.b, c: transform.c, d: transform.d, tx: transform.tx, ty: transform.ty)
                
        self.addSubview(imageView)
    }
    
    func addTextObject (text: String, font: String, color: UIColor, textSize: CGFloat, textAlignment: String?, x: CGFloat, y: CGFloat, transform: Transform?) {
        let textView = KMPlaceholderTextView(frame: CGRect(x: 0, y: 0, width: bounds.width - 40, height: 90))
        
        textView.text = text
        textView.font = UIFont(name: font, size: textSize)
        textView.alignmentFromString(alignment: textAlignment)
        textView.textColor = color
        textView.placeholder = "Start typing here or skip by tapping ‘DONE’ and browse ‘Backgrounds’ for some inspo.."
        textView.placeholderColor = UIColor.init(hexString: "#fff")
        textView.placeholderFont = UIFont(name: "Nunito-SemiBold", size: 20)
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false

        let sizeToFit = textView.sizeThatFits(CGSize(width: bounds.width - 40, height:CGFloat.greatestFiniteMagnitude))
        
        textView.frame =  CGRect(x: 0, y: 0, width: bounds.width - 40, height: sizeToFit.height)
        textView.setNeedsDisplay()
        
        let view = UIView.init(frame: CGRect(x: 0, y :0, width: bounds.width - 40, height: sizeToFit.height))
        
        view.center = CGPoint.init(x: x, y: y)
        view.addSubview(textView)
        if let trans = transform  {
            view.transform = CGAffineTransform.init(a: trans.a, b: trans.b, c: trans.c, d: trans.d, tx: trans.tx, ty: trans.ty)
        }
        
        self.addSubview(view)
    }
    
    func alignmentFromString (alignment: String?) -> NSTextAlignment {
        if (alignment == "left") {
            return .left
        } else if (alignment == "right") {
            return .right
        }
        
        return .center
    }
}
