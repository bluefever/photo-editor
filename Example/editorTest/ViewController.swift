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
        let data = "{\n  \"layers\" : [\n    {\n      \"zIndex\" : 3,\n      \"text\" : \"Sfsdfsfsdfasdasd\\nAsdas\\nDas\\nD\\nAs\\nDs\\nAd\",\n      \"textColor\" : \"#76FECB\",\n      \"textStyle\" : \"Apple SD Gothic Neo\",\n      \"textSize\" : 15,\n      \"center\" : {\n        \"x\" : 207,\n        \"y\" : 348.5\n      }\n    },\n    {\n      \"size\" : {\n        \"width\" : 190,\n        \"height\" : 190\n      },\n      \"zIndex\" : 0,\n      \"transform\" : {\n        \"d\" : 1,\n        \"b\" : 0,\n        \"ty\" : 0,\n        \"c\" : 0,\n        \"a\" : 1,\n        \"tx\" : 0\n      },\n      \"contentUrl\" : \"https:\\/\\/media2.giphy.com\\/media\\/gkQqTVkH2x20p3TbPy\\/giphy.gif?cid=cac7b2456a3baa2939028d1324447b6b13cb6abffc003838&rid=giphy.gif\",\n      \"center\" : {\n        \"x\" : 102.00000000000006,\n        \"y\" : 67.5\n      }\n    },\n    {\n      \"size\" : {\n        \"width\" : 190,\n        \"height\" : 190\n      },\n      \"zIndex\" : 1,\n      \"transform\" : {\n        \"d\" : 0.30670854641136991,\n        \"b\" : 0.096671540211629325,\n        \"ty\" : 0,\n        \"c\" : -0.096671540211629325,\n        \"a\" : 0.30670854641136991,\n        \"tx\" : 0\n      },\n      \"contentUrl\" : \"https:\\/\\/media3.giphy.com\\/media\\/IgGcxqawkRc6y43Z6I\\/giphy.gif?cid=cac7b2456f2597cffe413427fcd40e89d6543294ac0a44d4&rid=giphy.gif\",\n      \"center\" : {\n        \"x\" : 174.5,\n        \"y\" : 166\n      }\n    },\n    {\n      \"size\" : {\n        \"width\" : 190,\n        \"height\" : 205\n      },\n      \"zIndex\" : 2,\n      \"transform\" : {\n        \"d\" : 1.7029677409116846,\n        \"b\" : -1.7293144319783356,\n        \"ty\" : 0,\n        \"c\" : 1.7293144319783356,\n        \"a\" : 1.7029677409116846,\n        \"tx\" : 0\n      },\n      \"contentUrl\" : \"https:\\/\\/media0.giphy.com\\/media\\/MaflxovRYY4y6D4Nyy\\/giphy.gif?cid=cac7b2456a3baa2939028d1324447b6b13cb6abffc003838&rid=giphy.gif\",\n      \"center\" : {\n        \"x\" : 219.99999999999994,\n        \"y\" : 520\n      }\n    }\n  ],\n  \"backgroundColor\" : \"#F2DEC9\"\n}"
        photoEditor.bgColors = bgColors
        photoEditor.bgImages = bgImages
        photoEditor.initialData = data

        
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
        
        present(photoEditor, animated: true, completion: nil)
        
        // Expression preview view
//        let preview = ExpressionPreview.init(frame: CGRect.init(x: 0, y: 0, width: 200, height: 800))
//        preview.data = data
//        self.view.addSubview(preview)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated);
        
        showPhotoEditor()
    }
}

extension ViewController: PhotoEditorDelegate {
    
    func doneEditing(expression: String) {
        print(expression)
    }
    
    func canceledEditing() {
        print("Canceled")
    }
}
