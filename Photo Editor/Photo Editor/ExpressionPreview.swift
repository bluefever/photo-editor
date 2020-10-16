//
//  ExpressionPreview.swift
//  CollectionViewWaterfallLayout
//
//  Created by Adam Podsiadlo on 11/08/2020.
//

import Foundation

open class ExpressionPreview: UIView {
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
    
    func importExpression () {
        self.clipsToBounds = true
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
                let imageView: UIImageView = UIImageView.init(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                var bgUrl: String?
                
                for url in bgImages {
                    if (url.matchingStrings(regex: bgImage + ".png").count > 0) {
                        bgUrl = url
                    }
                }
                
                imageView.contentMode = .scaleAspectFill
                
                if let url = bgUrl {
                    imageView.load(url: url)
                    self.addSubview(imageView)
                    self.sendSubviewToBack(imageView)
                } else {
                    addDefaultBg()
                }
            } else {
                addDefaultBg()
            }
            
            expressionData.layers.sort{ $0.zIndex < $1.zIndex }
            
            for layer in expressionData.layers {
                if let text = layer.text {
                    var centerX = CGFloat(1)
                    var centerY = CGFloat(1)
                    
                    if (expressionData.originalFrame != nil) {
                        centerX = layer.center.x * scaleX
                        centerY = layer.center.y * scaleY
                    } else {
                        centerX = self.bounds.width / 2
                        centerY = self.bounds.height / 2
                    }
                    
                    addTextObject(text: text, font: layer.textStyle!, color: UIColor.init(hexString: layer.textColor!), textSize: layer.textSize!,
                                  x: centerX, y: centerY, transform: layer.transform)
                } else if let gifUrl = layer.contentUrl {
                    addGifObject(contentUrl: gifUrl, x: layer.center.x * scaleX, y: layer.center.y * scaleY, size: CGSize.init(width: layer.size!.width * scaleX, height: layer.size!.height * scaleY),
                                 transform: layer.transform!)
                }
            }
        }
    }
    
    func addDefaultBg () {
        let imageView: UIImageView = UIImageView.init(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
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
    
    func addTextObject (text: String, font: String, color: UIColor, textSize: CGFloat, x: CGFloat, y: CGFloat, transform: Transform?) {
        let label = UILabel(frame: CGRect(x: 0, y: self.center.y, width: UIScreen.main.bounds.width - 40, height: 30))
        
        label.text = text
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont(name: font, size: textSize)
        label.textColor = color
        label.layer.backgroundColor = UIColor.clear.cgColor
        label.center = CGPoint.init(x: x, y: y)
        
        if let trans = transform  {
            label.transform = CGAffineTransform.init(a: trans.a, b: trans.b, c: trans.c, d: trans.d, tx: trans.tx, ty: trans.ty)
        }
        
        let sizeToFit = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width - 40, height:CGFloat.greatestFiniteMagnitude))
        label.bounds.size = CGSize(width: UIScreen.main.bounds.size.width, height: sizeToFit.height)
        label.setNeedsDisplay()
        
        self.addSubview(label)
    }
}
