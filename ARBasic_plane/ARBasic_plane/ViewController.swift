//
//  ViewController.swift
//  ARBasic_plane
//
//  Created by Deeksha Sharma on 5/15/23.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var plane = [OverlayPlane]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints, ARSCNDebugOptions.showWorldOrigin]
        // Create a new scene
//        let scene = SCNScene(named: "art.scnassets/ship.scn")!
//
//        // Set the scene to the view
//        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        // Run the view's session
        sceneView.session.run(configuration)
        
        tapGestureReco()
    }
    
    private func tapGestureReco() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.sceneView.addGestureRecognizer(tapGesture)
    }
                                                
    @objc func tapped(gesture: UIGestureRecognizer) {
        
        let sceneView = gesture.view as! ARSCNView
        let touchLocation = gesture.location(in: sceneView)
        
        let hitResult = sceneView.hitTest(touchLocation, types: .existingPlaneUsingExtent)
        
        if !hitResult.isEmpty {
            guard let hitResultT = hitResult.first else {
                return
            }
            addBox(hitResult: hitResultT)
            
        }
    }
    
    private func addBox(hitResult: ARHitTestResult){
        let box = SCNBox(width: 0.1, height: 0.2, length: 0.2, chamferRadius: 0)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.blue
        box.materials = [material]
        let node = SCNNode(geometry: box)
        node.position = SCNVector3(Float(hitResult.worldTransform.columns.3.x), hitResult.worldTransform.columns.3.y + Float(box.height/2), hitResult.worldTransform.columns.3.z)
        
        self.sceneView.scene.rootNode.addChildNode(node)
    }
                                                
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        if !(anchor is ARPlaneAnchor) {
            return
        }
        
        let plane = OverlayPlane(anchor: anchor as! ARPlaneAnchor)
        self.plane.append(plane)
        node.addChildNode(plane)
//        let plane = SCNPlane(width: 0.3, height: 0.3)
//        plane.firstMaterial?.diffuse.contents = UIColor.green
//        let planeNode = SCNNode(geometry: plane)
//        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        let plane = self.plane.filter { plane in
            return plane.anchor.identifier == anchor.identifier
            }.first
        
        if plane == nil {
            return
        }
        
        plane?.update(anchor: anchor as! ARPlaneAnchor)
    }
}
