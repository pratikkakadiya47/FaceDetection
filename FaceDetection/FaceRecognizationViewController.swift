//
//  ViewController.swift
//  FaceDetection
//
//  Created by Synoptek Mac 2 on 25/09/19.
//  Copyright © 2019 Synoptek Mac 2. All rights reserved.
//

import UIKit
import FaceCropper
import AVFoundation
//import OpenALPRSwift
import SafariServices
import Firebase
import GoogleMobileVision



class FaceRecognizationViewController : UIViewController, AVCapturePhotoCaptureDelegate {

    @IBOutlet weak var camaraView: UIImageView!
    @IBOutlet weak var imageview1: UIImageView!
    @IBOutlet weak var imageview2: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var captureSession: AVCaptureSession!
    var stillImageOutput: AVCapturePhotoOutput!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    
    var textDetector : GMVDetector!
    
    
    @IBAction func TakeImageBtn_clicked(_ sender: Any) {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        stillImageOutput.capturePhoto(with: settings, delegate: self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.textDetector = GMVDetector(ofType: GMVDetectorTypeText, options: nil)
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setup your camera here...
        
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .medium
        
        guard let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
            else {
                print("Unable to access back camera!")
                return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: backCamera)
            stillImageOutput = AVCapturePhotoOutput()
            
            if captureSession.canAddInput(input) && captureSession.canAddOutput(stillImageOutput) {
                captureSession.addInput(input)
                captureSession.addOutput(stillImageOutput)
                setupLivePreview()
            }
            
            //Step 9
        }
        catch let error  {
            print("Error Unable to initialize back camera:  \(error.localizedDescription)")
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation()
            else { return }
        
        let Takeimage = UIImage(data: imageData)
        var Deviceimage : UIImage = UIImage(named: "item2")!
        
        var features: [GMVTextBlockFeature] = self.textDetector.features(in: Deviceimage, options: nil) as! [GMVTextBlockFeature]
        print(features)
        
        var textBlock : GMVTextBlockFeature
        var tetxLine : GMVTextLineFeature
        
        for textBlock in features {
            
            print(NSCoder.string(for: textBlock.bounds))
            print(textBlock.value!)
            
            for textLine in textBlock.lines {
                print(textLine.value!)
            }
        }
        
        // get face on image
        if let image = Takeimage {
            image.face.crop { result in
                switch result {
                case .success(let faces):
                    for img in 1...faces.count {
                        print(img)

                        if img == 1 {
                            let face1 = faces[img - 1].rotate(radians: .pi / 2)
                            self.imageview1.image = face1
                        }
                        if img == 2 {
                             let face2 = faces[img - 1].rotate(radians: .pi / 2)
                            self.imageview2.image = face2
                        }

                        print("Get Images \(faces)")
                    }

                case .notFound:
                    let image = UIImage(data: imageData)
                    self.imageview1.image = image
                    print("Face Not Found")
                case .failure(let error):
                    print("Face Detection not Working")
                }
            }
        }
        
    }
    
    func setupLivePreview() {
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        camaraView.layer.addSublayer(videoPreviewLayer)
        
        //Step12
        
        DispatchQueue.global(qos: .userInitiated).async { //[weak self] in
            self.captureSession.startRunning()
            //Step 13
        }
        
        DispatchQueue.main.async {
            self.videoPreviewLayer.frame = self.camaraView.bounds
        }
    }
    
}


// Image Rotataion
extension UIImage {
    func rotate(radians: CGFloat) -> UIImage {
        let rotatedSize = CGRect(origin: .zero, size: size)
            .applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
            .integral.size
        UIGraphicsBeginImageContext(rotatedSize)
        if let context = UIGraphicsGetCurrentContext() {
            let origin = CGPoint(x: rotatedSize.width / 2.0,
                                 y: rotatedSize.height / 2.0)
            context.translateBy(x: origin.x, y: origin.y)
            context.rotate(by: radians)
            draw(in: CGRect(x: -origin.y, y: -origin.x,
                            width: size.width, height: size.height))
            let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return rotatedImage ?? self
        }
        return self
    }
    
    func toString() -> String? {
        let data: Data? = self.pngData()
        return data?.base64EncodedString(options: .endLineWithLineFeed)
    }
}

