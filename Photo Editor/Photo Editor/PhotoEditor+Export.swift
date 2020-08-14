//
//  PhotoEditor+Export.swift
//  appcenter-analytics
//
//  Created by Adam Podsiadlo on 28/07/2020.
//

import Foundation
import UIKit

struct GifImage {
    let image: UIImageView
    var url: String
    
    init(image: UIImageView, url: String) {
        self.image = image
        self.url = url
    }
}

struct Size: Codable, Hashable {
    let height: CGFloat
    let width: CGFloat
    
    init(width: CGFloat = 0, height: CGFloat = 0) {
        self.width = width
        self.height = height
    }
}

struct Point: Codable, Hashable {
    var x: CGFloat
    var y: CGFloat
    
    init(x: CGFloat = 0, y: CGFloat = 0) {
        self.x = x
        self.y = y
    }
}

struct Transform: Codable, Hashable {
    var a: CGFloat
    var b: CGFloat
    var c: CGFloat
    var d: CGFloat
    var tx: CGFloat
    var ty: CGFloat
    
    init(a: CGFloat = 0, b: CGFloat = 0, c: CGFloat = 0, d: CGFloat = 0, tx: CGFloat = 0, ty: CGFloat = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.tx = tx
        self.ty = ty
    }
}

struct ExpressionLayer: Codable, Hashable {
    var size: Size?
    var transform: Transform?
    var center: Point
    var aspectRatio: Int?
    var zIndex: Int
    var angle: Int?
    var text: String?
    var textColor: String?
    var textStyle: String?
    var textSize: CGFloat?
    var contentUrl: String?
    
    init(size: Size? = nil, center: Point = Point(), aspectRatio: Int? = nil, zIndex: Int = 0, angle: Int? = nil,
         text: String? = nil, textColor: String? = nil, textSize: CGFloat? = nil, textStyle: String? = nil, contentUrl: String? = nil, transform: Transform? = nil) {
        self.size = size
        self.center = center
        self.aspectRatio = aspectRatio
        self.zIndex = zIndex
        self.angle = angle
        self.text = text
        self.textColor = textColor
        self.textStyle = textStyle
        self.textSize = textSize
        self.contentUrl = contentUrl
        self.transform = transform
    }
}

public struct Expression: Codable, Hashable {
    var backgroundColor: String?
    var backgroundImage: String?
    var layers: [ExpressionLayer]
    
    init(backgroundColor: String? = nil, backgroundImage: String? = nil, layers: [ExpressionLayer] = []) {
        self.backgroundColor = backgroundColor
        self.backgroundImage = backgroundImage
        self.layers = layers
    }
}

extension PhotoEditorViewController {
    public func exportExpression () -> String? {
        var expression = Expression()
        
        if let imageName = imageBgName {
            expression.backgroundImage = imageName
        } else {
            expression.backgroundColor = imageBg.backgroundColor?.hexString
        }
        
        if let textView = activeTextView {
            var textLayer = ExpressionLayer()
            textLayer.textColor = textView.textColor?.hexString
            textLayer.textStyle = textView.font?.familyName
            textLayer.textSize = textView.font?.pointSize
            textLayer.zIndex = canvasImageView.subviews.index(of: textView)!
            let center = self.view.convert(textView.center, from: canvasImageView)
            textLayer.center = Point(x: center.x, y: center.y)
            textLayer.text = textView.text
            
            if (textLayer.text != nil && !textLayer.text!.isEmpty) {
                expression.layers.append(textLayer)
            }
        }
        
        for gif in gifsSources {
            var gifLayer = ExpressionLayer()
            gifLayer.contentUrl = gif.url
            gifLayer.zIndex = canvasImageView.subviews.index(of: gif.image)!
            let center = self.view.convert(gif.image.center, from: canvasImageView)
            gifLayer.center = Point(x: center.x, y: center.y)
            gifLayer.size = Size(width: gif.image.bounds.width, height: gif.image.bounds.height)
            gifLayer.transform = Transform(a: gif.image.transform.a, b: gif.image.transform.b, c: gif.image.transform.c,d: gif.image.transform.d, tx: gif.image.transform.tx, ty: gif.image.transform.ty)
            
            expression.layers.append(gifLayer)
        }
        
        var jsonData: String? = nil
        
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            
            let data = try encoder.encode(expression)
            jsonData = String(data: data, encoding: .utf8)
        } catch {
            print(error)
        }
        
        return jsonData
    }
    
    public func importExpression (data: String) {
        let jsonData = data.data(using: .utf8)!
        var expression: Expression? = nil
        
        do {
            expression = try JSONDecoder().decode(Expression.self, from: jsonData)
        } catch {
            print(error)
        }
        
        if var expressionData = expression {
            if let bgColor = expressionData.backgroundColor {
                setBackgroundColor(color: bgColor)
            } else if let bgImage = expressionData.backgroundImage {
                setBackgroundImage(image: UIImage(named: bgImage, in: Bundle(for: type(of: self)), compatibleWith: nil)!)
            } else {
                setBackgroundImage(image:  UIImage(named: "default_bg", in: Bundle(for: type(of: self)), compatibleWith: nil)!)
            }
            
            expressionData.layers.sort{ $0.zIndex < $1.zIndex }
            
            for layer in expressionData.layers {
                let center = self.view.convert(CGPoint.init(x: layer.center.x, y: layer.center.y), to: canvasImageView)
                
                if let text = layer.text {
                    addTextObject(text: text, font: layer.textStyle!, color: UIColor.init(hexString: layer.textColor!), textSize: layer.textSize!,
                                  x: center.x, y: center.y)
                } else if let gifUrl = layer.contentUrl {
                    addGifObject(contentUrl: gifUrl, x: center.x, y: center.y, size: CGSize.init(width: layer.size!.width, height: layer.size!.height),
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
        
        self.canvasImageView.addSubview(imageView)
        addGestures(view: imageView)
        gifsImages.append(imageView)
        gifsSources.append(GifImage(image: imageView, url: contentUrl))
    }
    
    func addTextObject (text: String, font: String, color: UIColor, textSize: CGFloat, x: CGFloat, y: CGFloat) {
        let textView = UITextView(frame: CGRect(x: 0, y: canvasImageView.center.y, width: UIScreen.main.bounds.width, height: 30))
        
        textColor = color
        textView.text = text
        textView.textAlignment = .center
        textView.font = UIFont(name: font, size: textSize)
        textView.textColor = color
        textView.layer.backgroundColor = UIColor.clear.cgColor
        textView.autocorrectionType = .no
        textView.isScrollEnabled = false
        textView.delegate = self
        textView.center = CGPoint.init(x: x, y: y)
        
        let sizeToFit = textView.sizeThatFits(CGSize(width: UIScreen.main.bounds.size.width, height:CGFloat.greatestFiniteMagnitude))
        textView.bounds.size = CGSize(width: UIScreen.main.bounds.size.width, height: sizeToFit.height)
        textView.setNeedsDisplay()
        
        self.canvasImageView.addSubview(textView)
        addGestures(view: textView)
        textSizeSlider.value = Float(textSize)
        activeTextView = textView
        
        setFontStyleButton(fontIndex: fontIndex(fontName: font))
    }
}
