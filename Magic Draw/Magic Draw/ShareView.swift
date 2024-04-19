//
//  ShareView.swift
//  Magic Draw
//
//  Created by Lincoln Price on 4/1/24.
//

import SwiftUI

struct ShareView: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    
    var activityItems: [Any]
    var applicationActivities: [UIActivity]?
    var excludedActivityTypes:[UIActivity.ActivityType]?
    var callback: Callback?
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
      let controller = UIActivityViewController(
        activityItems: activityItems,
        applicationActivities: applicationActivities)
      controller.excludedActivityTypes = excludedActivityTypes
      controller.completionWithItemsHandler = callback
      return controller
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
      // nothing to do here
    }
  }

  struct ShareSheet_Previews: PreviewProvider {
    static var previews: some View {
      let theShareSheet = ShareView(
        activityItems: ["A preview string" as NSString],
        excludedActivityTypes: [UIActivity.ActivityType.airDrop])
      return theShareSheet
    }
}


