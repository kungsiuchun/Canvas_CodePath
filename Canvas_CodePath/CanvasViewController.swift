//
//  CanvasViewController.swift
//  Canvas_CodePath
//
//  Created by SiuChun Kung on 10/8/18.
//  Copyright © 2018 SiuChun Kung. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!
    
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        trayDownOffset = 170
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
        // Do any additional setup after loading the view.
    }
    

    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let velocity = sender.velocity(in: view)
        
        if sender.state == .began {
            print("Gesture began")
            trayOriginalCenter = trayView.center
        } else if sender.state == .changed {
            print("Gesture is changing")
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }else if sender.state == .ended {
            if velocity.y > 0 {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [] ,animations: {
                    self.trayView.center = self.trayDown
                    self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: CGFloat(Double.pi))
                })
            } else {
                UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: [] ,animations: {
                    self.trayView.center = self.trayUp
                    self.arrowImageView.transform = self.arrowImageView.transform.rotated(by: CGFloat(Double.pi))
                })
            }
            print("Gesture ended")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func didPanFace(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        if sender.state == .began {
            print("Gesture began")
            let imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.isUserInteractionEnabled = true

        } else if sender.state == .changed {
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            
            let pan_gesture = UIPanGestureRecognizer(target: self, action: #selector(didPanFaceAfterSelection(sender:)))
            pan_gesture.delegate = self
            newlyCreatedFace.addGestureRecognizer(pan_gesture)
            
            let pin_gesture = UIPinchGestureRecognizer(target: self, action: #selector(didPinchFace(sender:)))
            pin_gesture.delegate = self
            newlyCreatedFace.addGestureRecognizer(pin_gesture)
            
            let rotation_gesture = UIRotationGestureRecognizer(target: self, action: #selector(didRotateFace(sender:)))
            rotation_gesture.delegate = self
            newlyCreatedFace.addGestureRecognizer(rotation_gesture)
            
            let double_gesture = UITapGestureRecognizer(target: self, action: #selector(didDoubleTap(sender:)))
            double_gesture.delegate = self
            double_gesture.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(double_gesture)
            newlyCreatedFace.isUserInteractionEnabled = true
            
            UIView.animate(withDuration: 0.4, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    @objc func didPanFaceAfterSelection(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)
        
        if sender.state == .began {
            //print("Began: newDidPan")
            newlyCreatedFace = sender.view as? UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.transform = CGAffineTransform(scaleX: 2, y: 2)
        } else if sender.state == .changed {
            //print("Changed: newDidPan")
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        } else if sender.state == .ended {
            //print("Ended: newDidPan")
            UIView.animate(withDuration: 0.4, animations: {
                self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    @objc func didPinchFace(sender: UIPinchGestureRecognizer){
        let imageView = sender.view as! UIImageView
        
        if sender.state == .began {
            //let oldTransform = imageView.transform
        } else if sender.state == .changed {
            imageView.transform = imageView.transform.scaledBy(x: sender.scale, y: sender.scale)
            sender.scale = 1
        } else if sender.state == .ended {
        }
        
    }
    
    @objc func didRotateFace(sender: UIRotationGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        
        if sender.state == .began {
            
        } else if sender.state == .changed {
            
            imageView.transform = imageView.transform.rotated(by: sender.rotation)
            sender.rotation = 0
        } else if sender.state == .ended {
            
        }
    }
    
    @objc func didDoubleTap(sender: UITapGestureRecognizer){
        let imageView = sender.view as! UIImageView
        imageView.removeFromSuperview()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
