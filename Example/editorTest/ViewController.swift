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
        let data = "{\n  \"layers\" : [\n    {\n      \"zIndex\" : 0,\n      \"text\" : \"Asdasdad\",\n      \"textColor\" : \"#FDBEEA\",\n      \"textStyle\" : \"Nunito\",\n      \"textSize\" : 30,\n      \"center\" : {\n        \"x\" : 207,\n        \"y\" : 348.5\n      }\n    },\n    {\n      \"size\" : {\n        \"width\" : 190,\n        \"height\" : 190\n      },\n      \"zIndex\" : 1,\n      \"transform\" : {\n        \"d\" : 1,\n        \"b\" : 0,\n        \"ty\" : 0,\n        \"c\" : 0,\n        \"a\" : 1,\n        \"tx\" : 0\n      },\n      \"contentUrl\" : \"https:\\/\\/media1.giphy.com\\/media\\/KFVSc4k41364FiMBOI\\/giphy.gif?cid=cac7b245a2d14dfd2ca7559e9f402f7e4d2c57113ad80b86&rid=giphy.gif\",\n      \"center\" : {\n        \"x\" : 109.5,\n        \"y\" : 153.5\n      }\n    }\n  ],\n  \"backgroundImage\" : \"bg_11\"\n}"
        photoEditor.bgColors = bgColors
//        photoEditor.bgImages = bgImages
        photoEditor.initialData = data
//
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
//
        present(photoEditor, animated: true, completion: nil)
        
        // Expression preview view
//        let preview = ExpressionPreview.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
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
