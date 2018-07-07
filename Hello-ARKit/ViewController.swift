//
//  ViewController.swift
//  Hello-ARKit
//
//  Created by Saul Moreno Abril on 01/07/2018.
//  Copyright © 2018 Saul Moreno Abril. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView = ARSCNView(frame: self.view.bounds);
        self.view.addSubview(sceneView);
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        //let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let scene = SCNScene();
        
        // Set the scene to the view
        sceneView.scene = scene
        
        // Add box
        let box = SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.0)
        let material = SCNMaterial()
        material.name = "main";
        material.diffuse.contents = UIImage(named: "brick.jpg")
        let node = SCNNode(geometry: box)
        node.geometry?.materials = [material]
        node.position = SCNVector3(-0.2, 0, -1)
        
        scene.rootNode.addChildNode(node);
        
        let sphere = SCNSphere(radius: 0.1)
        let sphereMaterial = SCNMaterial()
        sphereMaterial.diffuse.contents = UIImage(named: "earth.jpg")
        let sphereNode = SCNNode(geometry: sphere);
        sphereNode.geometry?.materials = [sphereMaterial]
        sphereNode.position = SCNVector3(0.2, 0, -1)
        
        scene.rootNode.addChildNode(sphereNode)
        
        // Add text
        let textGeometry = SCNText(string: "Hello World", extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(0, 0.5, -2)
        
        // Center in the middle
        let (min, max) = textNode.boundingBox
        let dx = min.x + 0.5 * (max.x - min.x)
        let dy = min.y + 0.5 * (max.y - min.y)
        let dz = min.z + 0.5 * (max.z - min.z)
        textNode.pivot = SCNMatrix4MakeTranslation(dx, dy, dz)
        
        textNode.scale = SCNVector3(0.01, 0.01, 0.01);
        scene.rootNode.addChildNode(textNode)
        
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(recognizedTap))
        self.sceneView.addGestureRecognizer(tapGestureRecognizer)

    }
    
    @objc func recognizedTap(recognizer:UIGestureRecognizer) {
        let sceneView = recognizer.view as! SCNView
        let touchLocation = recognizer.location(in: sceneView)
        let hitResults = sceneView.hitTest(touchLocation, options: [:])
        
        guard let node = hitResults.first?.node else {
            return;
        }
        let material = node.geometry?.material(named: "main");
        material?.diffuse.contents = UIColor.random();

    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
