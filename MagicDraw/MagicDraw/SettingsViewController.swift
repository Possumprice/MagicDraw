//
//  SettingsController.swift
//  MagicDraw
//
//  Created by Lincoln Price on 3/20/24
//

import UIKit
import Foundation

protocol SettingsViewControllerDelegate: class {
  func settingsViewControllerFinished(_ settingsViewController: SettingsViewController)
}

class SettingsViewController: UIViewController {
  
  weak var delegate: SettingsViewControllerDelegate?
  
  var width: CGFloat = 5.0
  var opacity: CGFloat = 1.0
  var red:CGFloat = 0.0
  var green: CGFloat = 0.0
  var blue: CGFloat = 0.0
  
  @IBOutlet weak var redSlider: UISlider!
  @IBOutlet weak var greenSlider: UISlider!
  @IBOutlet weak var blueSlider: UISlider!
  @IBOutlet weak var sizeSlider: UISlider!
  @IBOutlet weak var opacitySlider: UISlider!
  

  @IBOutlet weak var previewImageView: UIImageView!
  
  @IBOutlet weak var sizeLabel: UILabel!
  @IBOutlet weak var opacityLabel: UILabel!
  @IBOutlet weak var redLabel: UILabel!
  @IBOutlet weak var greenLabel: UILabel!
  @IBOutlet weak var blueLabel: UILabel!

  
  
  //presets all labels and sliders with correct values
  override func viewDidLoad() {
    super.viewDidLoad()
    
    sizeSlider.value = Float(width)
    
    opacitySlider.value = Float(opacity)
    redSlider.value = Float(red * 255.0)
    greenSlider.value = Float(green * 255.0)
    blueSlider.value = Float(blue * 255.0)
    
    sizeLabel.text = String(format: "%.1f", width)
    opacityLabel.text = String(format: "%.1f", opacity)
    redLabel.text = Int(redSlider.value).description
    greenLabel.text = Int(greenSlider.value).description
    blueLabel.text = Int(blueSlider.value).description
    
    drawPreview()
  }
  
  //method draws a single point with the width and opacity
  func drawPreview() {
      UIGraphicsBeginImageContext(previewImageView.frame.size)
      
      guard let image = UIGraphicsGetCurrentContext() else {
          return
      }
      
      image.setLineWidth(width)
      image.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacity).cgColor)
      image.setLineCap(.round)
      
      image.move(to: CGPoint(x: 50, y: 50))
      image.addLine(to: CGPoint(x: 50, y: 50))
      image.strokePath()
      
      previewImageView.image = UIGraphicsGetImageFromCurrentImageContext()
      UIGraphicsEndImageContext()
  }
  
  @IBAction func closePressed(_ sender: Any) {
      delegate?.settingsViewControllerFinished(self)
  }
  
  @IBAction func sizeChange(_ sender: UISlider) {
      width = CGFloat(sender.value)
      sizeLabel.text = String(format: "%.1f", opacity)
      drawPreview()
  }
  
  
  @IBAction func opacityChanged(_ sender: UISlider) {
    opacity = CGFloat(sender.value)
    opacityLabel.text = String(format: "%.1f", opacity)
    drawPreview()
  }
  
  @IBAction func colorChanged(_ sender: UISlider) {
    red = CGFloat(redSlider.value / 255.0)
    green = CGFloat(greenSlider.value / 255.0)
    blue = CGFloat(blueSlider.value / 255.0)
    
    redLabel.text = Int(redSlider.value).description
    greenLabel.text = Int(greenSlider.value).description
    blueLabel.text = Int(blueSlider.value).description
    
    drawPreview()
  }
  

}
