//
//  GameViewController.swift
//  PlanetaryDemo
//
//  Created by Jacob Martin on 11/11/15.
//  Copyright (c) 2015 Jacob Martin. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit


class GameViewController: UIViewController {

    let camera:SCNCamera = SCNCamera()
    let cameraNode = SCNNode()
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // create a new scene
        let scene = SCNScene()
        
        
       
        scene.background.contents = ["skyboxRT", "skyboxLF", "skyboxUP", "skyboxDN", "skyboxBK", "skyboxFT"]
        
        // create and add a camera to the scene
        
        camera.zFar = 10000000    // zFar must be less than DBL_Max or skybox texture will not be visible, so thisis arbitrary
        
        cameraNode.camera = camera
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 1000.0)
        
        
        // create the planet object
       
        //let planetNode = Planetoid.planetWithParameters(1000.0, elevation: 50.5,seaLevel: 5.5,segmentCount: 400)
       let planetNode = Planetoid.planetWithParameters(100.0, elevation: 8, seaLevel: 7.5,segmentCount:700)
        planetNode.position = SCNVector3(x: 0, y: 0, z: 0)
        scene.rootNode.addChildNode(planetNode)
        
        
        let moonNode = Planetoid.planetWithParameters(20.0, elevation: 12, seaLevel: 7.5,segmentCount: 20)
        var moonPosition = planetNode.position
        moonPosition.x += 200.0;
        moonNode.position = moonPosition
       moonNode.pivot = SCNMatrix4MakeTranslation(-400.0, 0, 0)
        
        let animation = CABasicAnimation(keyPath: "rotation")
        animation.toValue = NSValue(SCNVector4: SCNVector4(x: Float(0), y: Float(1), z: Float(0), w: Float(M_PI)*2))
        animation.duration = 200
        
        animation.repeatCount = MAXFLOAT //repeat forever
        moonNode.addAnimation(animation, forKey: nil)

        
        scene.rootNode.addChildNode(moonNode)
        
 //        create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = SCNLightTypeOmni
        lightNode.position = SCNVector3(x: 0, y: 10000, z: 10000)
        scene.rootNode.addChildNode(lightNode)
        
        
        
        cameraNode.constraints = nil
        let targetNode = SCNLookAtConstraint(target: moonNode);
        targetNode.gimbalLockEnabled = true;
        
        
        cameraNode.constraints = [targetNode];
        // get its material
        
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        scnView.jitteringEnabled = true
        scnView.antialiasingMode = SCNAntialiasingMode.Multisampling2X
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = UIColor.blackColor()
    /*
        if let path = NSBundle.mainBundle().pathForResource("tech", ofType: "plist") {
            if let dico1 = NSDictionary(contentsOfFile: path)  {
                let dico = dico1 as! [String : AnyObject]
                //println(dico)
                let technique = SCNTechnique(dictionary:dico)
                technique?.setValue(NSValue(CGSize: CGSizeApplyAffineTransform(self.view.frame.size, CGAffineTransformMakeScale(2.0, 2.0))), forKeyPath: "size_screen")
                scnView.technique = technique
            }
        }
        
  */
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
        scnView.addGestureRecognizer(tapGesture)
    }
    
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            cameraNode.constraints = nil
            let targetNode = SCNLookAtConstraint(target: result.node!);
            targetNode.gimbalLockEnabled = true;
            
            cameraNode.constraints = [targetNode];
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.redColor()
            
            SCNTransaction.commit()
        }
    }

}
