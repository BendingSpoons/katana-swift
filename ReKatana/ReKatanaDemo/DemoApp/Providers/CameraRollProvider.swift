//
//  CameraRollProvider.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

private let cameraRollPhotoListMock = [
  (name: "gold.png", size: CGSize(width: 100, height: 100)),
  (name: "direction.png", size: CGSize(width: 100, height: 100)),
  (name: "attack.png", size: CGSize(width: 100, height: 100)),
  (name: "vacation.png", size: CGSize(width: 100, height: 100)),
  (name: "farm.png", size: CGSize(width: 100, height: 100)),
  (name: "vein.png", size: CGSize(width: 100, height: 100)),
  (name: "pocket.png", size: CGSize(width: 100, height: 100)),
  (name: "hospital.png", size: CGSize(width: 100, height: 100)),
  (name: "uncle.png", size: CGSize(width: 100, height: 100)),
  (name: "veil.png", size: CGSize(width: 100, height: 100)),
  (name: "rabbits.png", size: CGSize(width: 100, height: 100)),
  (name: "shame.png", size: CGSize(width: 100, height: 100))
]


/*
 This is just a mock of something that is able to get photos from the camera roll.
 Here we will use the standard input/output to create a fake photo instance.
 
 It is important to remeber that we are making I/O here just because it is a mock.
 In a real iOS app you would show an image picker, and that would require to change the application navigaiton state, the UI and so on. Remember: This is just a mock
 */
enum CameraRollProvider {
  static func getPhotoFromCameraRoll() -> Photo {
    let question = cameraRollPhotoListMock.reduce("Pick a photo:") { prev, current in
      let idx = cameraRollPhotoListMock.index(where: { $0 == current })! // bang is safe here ;)
      return prev + "\n\(idx)) name: \(current.name), size: \(current.size)"
    }
    
    let photo = aksQuestion(question, error: "Invalid Choice", until: { (str: String) -> (name: String, size: CGSize)? in
      if let idx = Int(str) {
        if idx >= 0 && idx < cameraRollPhotoListMock.count {
          return cameraRollPhotoListMock[idx]
        }
      }
      
      return nil
    })
    
    return Photo(id: NSUUID().uuidString, name: photo.name, resolution: photo.size)
  }
  
}
