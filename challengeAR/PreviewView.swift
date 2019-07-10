//
//  PreviewView.swift
//  challengeAR
//
//  Created by M.Diaz Darmawan on 10/07/19.
//  Copyright © 2019 M.Diaz Darmawan. All rights reserved.
//

import AVKit

    class PreviewView: UIView {
        override class var layerClass: AnyClass {
            return AVCaptureVideoPreviewLayer.self
        }
        var videoPreviewLayer: AVCaptureVideoPreviewLayer {
            return layer as! AVCaptureVideoPreviewLayer
        }
        
    }
    
    


