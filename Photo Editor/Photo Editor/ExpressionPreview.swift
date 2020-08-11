//
//  ExpressionPreview.swift
//  CollectionViewWaterfallLayout
//
//  Created by Adam Podsiadlo on 11/08/2020.
//

import Foundation

open class ExpressionPreview: UIView {
    @objc open var data: String? = nil
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
            if let bgColor = expressionData.backgroundColor {
                self.backgroundColor = UIColor(hexString: bgColor)
            } else if let bgImage = expressionData.backgroundImage {
                DispatchQueue.global().async { [weak self] in
                    if let data = try? Data(contentsOf: URL(string: bgImage)!) {
                        if let image = UIImage(data: data) {
                            DispatchQueue.main.async {
                                let imageView: UIImageView = UIImageView.init(frame: CGRect(x:0, y:0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
                                imageView.image = image
                                self?.addSubview(imageView)
                                self?.sendSubviewToBack(imageView)
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
        let label = UILabel(frame: CGRect(x: 0, y: self.center.y, width: UIScreen.main.bounds.width, height: 30))
        
        label.text = text
        label.textAlignment = .center
        label.font = UIFont(name: font, size: textSize)
        label.textColor = color
        label.layer.backgroundColor = UIColor.clear.cgColor
        label.center = CGPoint.init(x: x, y: y)
        
        let sizeToFit = label.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width, height:CGFloat.greatestFiniteMagnitude))
        label.bounds.size = CGSize(width: UIScreen.main.bounds.size.width, height: sizeToFit.height)
        label.setNeedsDisplay()
        
        self.addSubview(label)
    }
}
