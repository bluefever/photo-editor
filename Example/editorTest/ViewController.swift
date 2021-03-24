//
//  ViewController.swift
//  editorTest
//
//  Created by Mohamed Hamed on 5/4/17.
//  Copyright © 2017 Mohamed Hamed. All rights reserved.
//

import UIKit
import iOSPhotoEditor
import FlipBook

class ViewController: UIViewController {
    let flipBook = FlipBook()
    var preview: ExpressionScalablePreview? = nil
    
    let bgColors: [String] = ["#4282F7","#538EF7","#669AF8","#739FEE","#8CB3F9","#9EC0FA","#B2CDFB","#C4D8FB","#D9E6FD","#ECF2FE","#DCC7C6","#DFCCCB","#E3D2D1","#E6D8D6","#EADEDC","#EDE2E2","#F1E8E8","#F4EDED","#FBF9F9","#EED5BB","#EFD9C2","#F2DEC9","#F2E0CF","#F4E5D6","#4282F7","#538EF7","#669AF8","#739FEE","#8CB3F9","#9EC0FA","#B2CDFB","#C4D8FB","#D9E6FD","#ECF2FE","#DCC7C6"]
    
  
    
    func showPhotoEditor () {
        let photoEditor = PhotoEditorViewController(nibName:"PhotoEditorViewController",bundle: Bundle(for: PhotoEditorViewController.self))
        photoEditor.photoEditorDelegate = self
        
        let note =       "{ \"layers\": [ { \"zIndex\": 0, \"size\": { \"width\": 190, \"height\": 300 }, \"transform\": { \"d\": 0.7963274178455895, \"b\": 0, \"ty\": 0, \"c\": 0, \"a\": 0.7963274178455895, \"tx\": 0 }, \"contentUrl\": \"https://media1.giphy.com/media/3dkxUswaLHQ7C/giphy.gif?cid=cac7b245726bi2t1n80hk636c14dlf55057gbc71x7p4ii0r&rid=giphy.gif\", \"center\": { \"x\": 1135.869592860125, \"y\": 1609.2994800512347 } }, { \"zIndex\": 1, \"size\": { \"width\": 190, \"height\": 196 }, \"transform\": { \"d\": 1, \"b\": 0, \"ty\": 0, \"c\": 0, \"a\": 1, \"tx\": 0 }, \"contentUrl\": \"https://media2.giphy.com/media/WnCTbHZRwNXS6YtGXv/giphy.gif?cid=cac7b245ni8u9satud1ev53le6iyk7qpyvsbny0c660uunro&rid=giphy.gif\", \"center\": { \"x\": 600.241564322209, \"y\": 1168.4782608695652 } } ], \"backgroundSize\": { \"width\": 1500, \"height\": 2250 }, \"thumbnailUrl\": \"https://firebasestorage.googleapis.com/v0/b/shinggg-development.appspot.com/o/images%2Fthumbnail_1614204483269.png?alt=media&token=0711b17e-fe1a-4300-a505-467ca245d5cc\", \"key\": \"639\", \"backgroundImage\": \"journal_cover_3\", \"originalFrame\": { \"width\": 414, \"height\": 896 } }"
        
        
        
        photoEditor.bgColors = bgColors
//        photoEditor.initialData = note
        photoEditor.bgImages = [""]
        photoEditor.modalPresentationStyle = UIModalPresentationStyle.fullScreen;
//        photoEditor.initialBgUrl = "https://firebasestorage.googleapis.com/v0/b/shinggg-production.appspot.com/o/backgrounds%2Fbg_98.png?alt=media&token=b0498492-9a4a-4419-8dd4-16059cfe8b1b"
        //present(photoEditor, animated: true, completion: nil)
        
        preview = ExpressionScalablePreview.init(frame: CGRect.init(x: 0, y: 0, width: 190, height: 280))
        preview!.data = note
        preview!.bgImages = ViewController.backgrounds
        self.view.addSubview(preview!)
        addButton()
    }
    
    func addButton() {
        let button:UIButton = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
        button.backgroundColor = .black
        button.setTitle("Start", for: .normal)
        button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        self.view.addSubview(button)
        
        let button2:UIButton = UIButton(frame: CGRect(x: 200, y: 400, width: 100, height: 50))
        button2.backgroundColor = .black
        button2.setTitle("Stop", for: .normal)
        button2.addTarget(self, action:#selector(self.buttonClickedStop), for: .touchUpInside)
        self.view.addSubview(button2)
        
        recordPages(index: 0)
    }
    
    func recordPages (index: Int) {
        print(index)
        if (index < 24) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.preview = ExpressionScalablePreview.init(frame: CGRect.init(x: 0, y: 0, width: 190, height: 280))
                self.preview!.data = ViewController.covers[index]
                self.preview!.bgImages = ViewController.backgrounds
                self.view.addSubview(self.preview!)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.buttonClicked()
                    self.recordPages(index: index + 1)
                }
            }
        }
    }
    
    @objc func buttonClicked() {
        flipBook.assetType = .gif
        flipBook.preferredFramesPerSecond = 8
        flipBook.gifImageScale = .default
        flipBook.startRecording(preview!) { [weak self] result in

            // Switch on result
            switch result {
            case .success(let asset):
                // Switch on the asset that's returned
                switch asset {
                case .video(let url):
                    print(url)
                    break
                case .gif(let url):
                    print(url)
                    break
                case .livePhoto(_, _):
                    break
                }
            case .failure(let error):
                // Handle error in recording
                print(error)
            }
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.flipBook.stop()
        }
    }
    
    @objc func buttonClickedStop() {
        flipBook.stop()
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
