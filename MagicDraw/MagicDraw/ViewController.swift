//
//  ViewController.swift
//  MagicDraw
//
//  Created by Lincoln Price on 3/17/24
//

import UIKit

class ViewController: UIViewController {
  
  var last = CGPoint.zero // stores last drawn point on the canvas
  var color = UIColor.black
  var width:CGFloat = 5.0 //stores stroke width
  var opacity:CGFloat = 1.0 //stores stroke opacity
  var cont = false //says if stroke is continuous
  
  @IBOutlet weak var mainImageView: UIImageView! //holds drawing so far
  @IBOutlet weak var tempImageView: UIImageView! //holds line currently drawing
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //make sure it actually touched
    guard let touch = touches.first else {
      return
    }
    
    //set to false since touch hasn't moved yet
    cont = false
    
    //save touch location in lastpoint to keep track of it
    last = touch.location(in: view)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    
    //set to true bc moving now
    cont = true
    let current = touch.location(in: view)
    
    //draw the line
    drawLine(from: last, to: current)
    
    //last point becomes current point
    last = current
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    //check if in middle of continuous line
    if !cont {
      //draw a single point if not
      drawLine(from: last, to: last)
    }
    
    //Merge tempimage into main image, done to preserve opacity
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.draw(in: view.bounds, blendMode: .normal, alpha: 1.0)
    tempImageView?.image?.draw(in: view.bounds, blendMode: .normal, alpha: opacity)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    tempImageView.image = nil
    
  }
  
  //this will likely be where we putting machine learning calls
  func drawLine(from point1: CGPoint, to point2: CGPoint) {
    
    //set up drawing context with the image currently in tempimage, should be empty
    UIGraphicsBeginImageContext(view.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    tempImageView.image?.draw(in: view.bounds)
    
    //draw line from point1 to point2
    context.move(to: point1)
    context.addLine(to: point2)
    
    //set parameters for pen stroke
    context.setLineCap(.round)
    context.setStrokeColor(color.cgColor)
    context.setLineWidth(width)
    context.setBlendMode(.normal)
    
    //adds the path
    context.strokePath()
    
    //get image representation of context and set it to tempimage
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = opacity
    UIGraphicsEndImageContext()
  }
  
  //triggered by tapping pen settings, sets itself as the delegate and passes values for pen
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    guard let drawController = segue.destination as? UINavigationController, let settingViewController = drawController.topViewController as? SettingsViewController else {
      return
    }
    
    settingViewController.delegate = self
    settingViewController.width = width
    settingViewController.opacity = opacity
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    color.getRed(&red, green: &green, blue: &blue, alpha: nil)
    
    settingViewController.red = red
    settingViewController.blue = blue
    settingViewController.green = green
  }
  
  
  
  // MARK: - Actions
  
  @IBAction func resetPressed(_ sender: Any) {
    mainImageView.image = nil
  }
  
  /*
   @IBAction func sharePressed(_ sender: Any) {
   guard let image = mainImageView.image else {
   return
   }
   let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
   present(activity, animated: true)
   }
   */
  
  
  
  
  /*
   @IBAction func pencilPressed(_ sender: UIButton) {
   guard let pencil = Pencil(tag: sender.tag) else {
   return
   }
   color = pencil.color
   if pencil == .eraser {
   opacity = 1.0
   }
   }
   */
  
}

// MARK: - SettingsViewControllerDelegate

extension ViewController: SettingsViewControllerDelegate {
  func settingsViewControllerFinished(_ settingsViewController: SettingsViewController) {
    width = settingsViewController.width
    opacity = settingsViewController.opacity
    color = UIColor(red: settingsViewController.red,
                    green: settingsViewController.green,
                    blue: settingsViewController.blue,
                    alpha: opacity)
    dismiss(animated: true)
  }
}

