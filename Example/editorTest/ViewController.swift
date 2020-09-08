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
        let dataXSMAX = "{\"layers\":[{\"zIndex\":0,\"text\":\"Testing xs max\",\"textColor\":\"#000000\",\"textStyle\":\"HelveticaNeue-Medium\",\"textSize\":30,\"center\":{\"x\":207,\"y\":463.50000000000006}},{\"size\":{\"width\":190,\"height\":204},\"zIndex\":1,\"transform\":{\"d\":1.7434262806440555,\"b\":0.20130353044768798,\"ty\":0,\"c\":-0.20130353044768798,\"a\":1.7434262806440555,\"tx\":0},\"contentUrl\":\"https:\\/\\/media3.giphy.com\\/media\\/L0xABGZ2xQ2v5wq4ld\\/giphy.gif?cid=cac7b245f15d84b4d34caedca4432c72c5d0b9dfbed2140e&rid=giphy.gif\",\"center\":{\"x\":111.33331298828119,\"y\":167.83332824707043}},{\"size\":{\"width\":190,\"height\":124},\"zIndex\":2,\"transform\":{\"d\":-0.038622025806129265,\"b\":2.01691546498978,\"ty\":0,\"c\":-2.01691546498978,\"a\":-0.038622025806129265,\"tx\":0},\"contentUrl\":\"https:\\/\\/media0.giphy.com\\/media\\/NI4FNMb4tJEYM\\/giphy.gif?cid=cac7b245d36426c41415695caa971f445f2efa7832a95a87&rid=giphy.gif\",\"center\":{\"x\":281.33332824707014,\"y\":697.49998474121094}}],\"originalFrame\":{\"width\":414,\"height\":896}}"
        
        let dataIphone8 = "{\"layers\":[{\"zIndex\":0,\"text\":\"Testing xs max\",\"textColor\":\"#000000\",\"textStyle\":\"HelveticaNeue-Medium\",\"textSize\":30,\"center\":{\"x\":109.5,\"y\":102.33333333333331}},{\"size\":{\"width\":172.10144927536231,\"height\":92.308035714285722},\"zIndex\":1,\"transform\":{\"d\":-0.038622025806129258,\"b\":2.01691546498978,\"ty\":0,\"c\":-2.01691546498978,\"a\":-0.038622025806129258,\"tx\":0},\"contentUrl\":\"https:\\/\\/media0.giphy.com\\/media\\/NI4FNMb4tJEYM\\/giphy.gif?cid=cac7b245d36426c41415695caa971f445f2efa7832a95a87&rid=giphy.gif\",\"center\":{\"x\":89.830913267273615,\"y\":527.37257048629579}}],\"originalFrame\":{\"width\":375,\"height\":667}, \"backgroundImage\": \"bg_21\"}"
        
        photoEditor.bgColors = bgColors
//        photoEditor.bgImages = bgImages
        photoEditor.initialData = dataXSMAX
//
//        photoEditor.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
//        present(photoEditor, animated: true, completion: nil)
        
        // Expression preview view
        let preview = ExpressionPreview.init(frame: CGRect.init(x: 0, y: 0, width: 500, height: 1000))
        preview.data = dataIphone8
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
