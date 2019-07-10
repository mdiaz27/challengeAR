//
//  ViewController.swift
//  challengeAR
//
//  Created by M.Diaz Darmawan on 10/07/19.
//  Copyright © 2019 M.Diaz Darmawan. All rights reserved.
//

import AVKit

class ViewController: UIViewController {

    
    let captureSession = AVCaptureSession()
    var previewView = PreviewView()
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var photoOutput = AVCapturePhotoOutput()
    var outputImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        askCameraPermission { (granted) in
            if granted {
                DispatchQueue.main.sync {
                    self.setupView()
                    DispatchQueue.global().async {
                        //start to configuring the session
                        self.configuringSession()
                    }
                }
                
            }
            
        }
        
        
    }
    
    func setupView() {
        view.backgroundColor = .black
    
        
        let xPosition = (UIScreen.main.bounds.width / 2.0) - 40
        let yPosition = UIScreen.main.bounds.height - 170.0
        let buttonRect = CGRect(x: xPosition, y: yPosition, width: 80, height: 80)
        let buttonShoot = UIButton(frame: buttonRect)
        
        buttonShoot.backgroundColor = UIColor.white
        buttonShoot.layer.cornerRadius = buttonShoot.frame.width / 2.0
        buttonShoot.layer.masksToBounds = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(buttonShootDidTap))
        buttonShoot.addGestureRecognizer(tap)
        
        view.addSubview(buttonShoot)
    
    
            
        outputImageView.frame = CGRect(x: (xPosition / 2) - 25, y: yPosition + 10, width: 50, height: 50)
        outputImageView.layer.borderColor = UIColor.gray.cgColor
        outputImageView.layer.borderWidth = 1
        outputImageView.layer.masksToBounds = true
        outputImageView.contentMode = .scaleAspectFill
        
        view.addSubview(outputImageView)
        
        previewView.frame = CGRect(x: 0, y:0, width: UIScreen.main.bounds.width, height: 650)
        view.addSubview(previewView)
        
        
        
    }
            
            
    
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureSession.stopRunning()
    }
    func askCameraPermission(completion: @escaping ((Bool)-> Void)) {
        AVCaptureDevice.requestAccess(for: .video) { (granted) in
            if  !granted {
                let alert = UIAlertController(title: "message", message: "give us permission", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "ok", style: .default, handler: { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    completion (false)
                })
                alert.addAction(alertAction)
                self.present(alert, animated: true, completion: nil)
            } else {completion(true)}
            
            
        }
    }
    
    @objc func buttonShootDidTap() {
        let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        photoOutput.capturePhoto(with: settings, delegate: self)
    }
    





func configuringSession() {
    //start to preparing to begin the configuration
    captureSession.beginConfiguration()
    
    //preparing the camera device
    guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {return}
    
    //preparing the input for session
    guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice), captureSession.canAddInput(videoDeviceInput)
        else {return}
    captureSession.addInput(videoDeviceInput)
    
    //commit configuration of the session
    captureSession.commitConfiguration()
    
    //preparing the output of the session
    guard captureSession.canAddOutput(photoOutput) else {return}
    captureSession.sessionPreset = .photo
    captureSession.addOutput(photoOutput)
    
    
    
    
    
    //start to setup live preview and start the session
    DispatchQueue.main.async {
        self.previewView.videoPreviewLayer.session = self.captureSession
        self.captureSession.startRunning()
    }
    
    
    }
    
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    // handle photo that captured on session
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        guard let imageData = photo.fileDataRepresentation() else {return}
        let image = UIImage(data: imageData)
        outputImageView.image = image
        
}
}
