//
//  ViewController.swift
//  ARFaceDepthSampleApp
//
//  Created by Tao Xu on 4/4/19.
//  Copyright © 2019 Tao Xu. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController {
    
    @IBOutlet weak var depthImageView: UIImageView!
    
    @IBOutlet weak var sceneView: ARSCNView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.showsStatistics = true
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        sceneView.session.pause()
        super.viewWillDisappear(animated)
    }
}

extension ViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        let currentFrame = sceneView.session.currentFrame
        guard let pixelBuffer = currentFrame?.capturedDepthData?.depthDataMap else {
            return
        }
        // rotate the buffer
        guard let rotatedBuffer = rotate90PixelBuffer(pixelBuffer, factor: 3) else {
            return
        }
        rotatedBuffer.printDebugInfo()
        // normalize the buffer
//        rotatedBuffer.normalize()
        // generate the depth image
        let depthImage = UIImage(ciImage:CIImage(cvImageBuffer: rotatedBuffer))
        // draw image
        DispatchQueue.main.async {
            self.depthImageView.image = depthImage
        }
    }
}

