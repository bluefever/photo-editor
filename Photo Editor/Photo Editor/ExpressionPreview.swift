//
//  ExpressionPreview.swift
//  CollectionViewWaterfallLayout
//
//  Created by Adam Podsiadlo on 11/08/2020.
//

import Foundation

open class ExpressionPreview: UIImageView {
    @objc open var data: String? = nil
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        importExpression()
    }
    
    public func importExpression () {
        let jsonData = data!.data(using: .utf8)!
        var expression: Expression? = nil
        
        do {
            expression = try JSONDecoder().decode(Expression.self, from: jsonData)
        } catch {
            print(error)
        }
        
        if var expressionData = expression {
            if let bgColor = expressionData.backgroundColor {
                self.backgroundColor = UIColor(hexString: bgColor)
            } else if let bgImage = expressionData.backgroundImage {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: URL(string: bgImage)!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                self?.image = image
                            }
                        }
                    }
                }
            }
            
            expressionData.layers.sort{ $0.zIndex < $1.zIndex }
            
            for layer in expressionData.layers {
                if let text = layer.text {
                    addTextObject(text: text, font: layer.textStyle!, color: UIColor.init(hexString: layer.textColor!), textSize: layer.textSize!,
                                  x: layer.center.x, y:layer.center.y)
                } else if let gifUrl = layer.contentUrl {
                    addGifObject(contentUrl: gifUrl, x: layer.center.x, y: layer.center.y, size: CGSize.init(width: layer.size!.width, height: layer.size!.height),
                                 transform: layer.transform!)
                }
            }
        }
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
    
    func addTextObject (text: String, font: String, color: UIColor, textSize: CGFloat, x: CGFloat, y: CGFloat) {
        let textView = UITextView(frame: CGRect(x: 0, y: self.center.y, width: UIScreen.main.bounds.width, height: 30))
        
        textView.text = text
        textView.textAlignment = .center
        textView.font = UIFont(name: font, size: textSize)
        textView.textColor = color
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.center = CGPoint.init(x: x, y: y)
        
        let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width, height:CGFloat.greatestFiniteMagnitude))
        textView.bounds.size = CGSize(width: UIScreen.main.bounds.size.width, height: sizeToFit.height)
        textView.setNeedsDisplay()
        
        self.addSubview(textView)
    }
}
