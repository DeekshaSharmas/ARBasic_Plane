//
//  OverlayPlane.swift
//  ARBasic_plane
//
//  Created by Deeksha Sharma on 5/16/23.
//

import Foundation
import SceneKit
import ARKit

class OverlayPlane : SCNNode{
    var anchor: ARPlaneAnchor
    var planeGeomentry: SCNPlane!
    
    init(anchor: ARPlaneAnchor) {
        self.anchor = anchor
        super.init()
        setup()
    }
    
    private func setup() {
        self.planeGeomentry = SCNPlane(width: CGFloat(self.anchor.planeExtent.width), height: CGFloat(self.anchor.planeExtent.height))
        
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "rug1.png")
        
        self.planeGeomentry.materials = [material]
        
        let planeNode = SCNNode(geometry: self.planeGeomentry)
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeomentry,options: nil))
        planeNode.physicsBody?.categoryBitMask = BodyType.plane.rawValue
        
        planeNode.position = SCNVector3Make(anchor.center.x,0, anchor.center.z)
        planeNode.transform = SCNMatrix4MakeRotation(Float(-Double.pi/2.0), 1.0, 0.0, 0.0)
        
        self.addChildNode(planeNode)
    }
    
    func update(anchor: ARPlaneAnchor){
        self.planeGeomentry.width = CGFloat(anchor.planeExtent.width)
        self.planeGeomentry.height = CGFloat(anchor.planeExtent.height)
        
        self.position = SCNVector3Make(anchor.center.x,0, anchor.center.z)
        
        let planeNode = self.childNodes.first!
        
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: SCNPhysicsShape(geometry: self.planeGeomentry,options: nil))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
