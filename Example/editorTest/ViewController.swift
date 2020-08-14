//
//  ViewController.swift
//  editorTest
//
//  Created by Mohamed Hamed on 5/4/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit
import iOSPhotoEditor

class ViewController: UIViewController {
    let bgColors: [String] = ["#4282F7","#538EF7","#669AF8","#739FEE","#8CB3F9","#9EC0FA","#B2CDFB","#C4D8FB","#D9E6FD","#ECF2FE","#DCC7C6","#DFCCCB","#E3D2D1","#E6D8D6","#EADEDC","#EDE2E2","#F1E8E8","#F4EDED","#FBF9F9","#EED5BB","#EFD9C2","#F2DEC9","#F2E0CF","#F4E5D6","#4282F7","#538EF7","#669AF8","#739FEE","#8CB3F9","#9EC0FA","#B2CDFB","#C4D8FB","#D9E6FD","#ECF2FE","#DCC7C6"]
    
    let bgImages: [String] = ["https://images-na.ssl-images-amazon.com/images/I/71FcdrSeKlL._AC_SL1001_.jpg","https://i.pinimg.com/originals/bf/f5/d0/bff5d074d399bdfec6071e9168398406.jpg","https://i1.wp.com/katzenworld.co.uk/wp-content/uploads/2019/06/funny-cat.jpeg?fit=1920%2C1920&ssl=1","https://www.zooroyal.de/magazin/wp-content/uploads/2017/02/deutsche-dogge-hunderassen-760x560.jpg"]
    
    func showPhotoEditor () {
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        
        //Colors for drawing and Text, If not set default values will be used
        //photoEditor.colors = [.red, .blue, .green]
        
        //Stickers that the user will choose from to add on the image
        for i in 0...10 {
            photoEditor.stickers.append(UIImage(named: i.description )!)
        }
        let data = "{\n  \"layers\" : [\n    {\n      \"zIndex\" : 2,\n      \"text\" : \"Aasdsadasdsadasdasdsasa\",\n      \"textColor\" : \"#000000\",\n      \"textStyle\" : \"Helvetica Neue\",\n      \"textSize\" : 30,\n      \"center\" : {\n        \"x\" : 203,\n        \"y\" : 460.83333333333337\n      }\n    },\n    {\n      \"size\" : {\n        \"width\" : 190,\n        \"height\" : 170\n      },\n      \"zIndex\" : 0,\n      \"transform\" : {\n        \"d\" : 2.1506565365123502,\n        \"b\" : -0.0064925077106293356,\n        \"ty\" : 0,\n        \"c\" : 0.0064925077106293356,\n        \"a\" : 2.1506565365123502,\n        \"tx\" : 0\n      },\n      \"contentUrl\" : \"https:\\/\\/media3.giphy.com\\/media\\/PnDRNekrgtHh5jXMna\\/giphy-downsized.gif?cid=cac7b245a3b86c8eb34b20d4f4359ae405701093046d12c8&rid=giphy-downsized.gif\",\n      \"center\" : {\n        \"x\" : 207.49999999999997,\n        \"y\" : 191.5\n      }\n    },\n    {\n      \"size\" : {\n        \"width\" : 190,\n        \"height\" : 192\n      },\n      \"zIndex\" : 1,\n      \"transform\" : {\n        \"d\" : 2.1685829726971892,\n        \"b\" : -0.0020858555627954536,\n        \"ty\" : 0,\n        \"c\" : 0.0020858555627954536,\n        \"a\" : 2.1685829726971892,\n        \"tx\" : 0\n      },\n      \"contentUrl\" : \"https:\\/\\/media3.giphy.com\\/media\\/9rtpurjbqiqZXbBBet\\/giphy.gif?cid=cac7b245a3b86c8eb34b20d4f4359ae405701093046d12c8&rid=giphy.gif\",\n      \"center\" : {\n        \"x\" : 207,\n        \"y\" : 680.5\n      }\n    }\n  ]\n}"
        photoEditor.bgColors = bgColors
//        photoEditor.bgImages = bgImages
//        photoEditor.initialData = data
//
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
//
//        present(photoEditor, animated: true, completion: nil)
        
        // Expression preview view
        let preview = ExpressionPreview.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        preview.data = data
        self.view.addSubview(preview)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        showPhotoEditor()
    }
}

extension ViewController: PhotoEditorDelegate {
    
    func doneEditing(expression: String, image: UIImage) {
        print(expression)
    }
    
    func canceledEditing() {
        print("Canceled")
    }
}
