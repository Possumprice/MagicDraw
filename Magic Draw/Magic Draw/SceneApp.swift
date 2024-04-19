//
//  SceneApp.swift
//  Magic Draw
//
//  Created by Lincoln Price on 4/1/24.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let persistanceController = PersistanceController.shared
    
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    if let windowScene = scene as? UIWindowScene {
        let window = UIWindow(windowScene: windowScene)
        
        window.rootViewController = UIHostingController(rootView: ContentView().environment(\.managedObjectContext, persistanceController.container.viewContext))
        
      self.window = window
      window.makeKeyAndVisible()
    }
  }
}

