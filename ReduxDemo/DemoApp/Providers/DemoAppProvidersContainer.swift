//
//  DemoAppProvidersContainer.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

class DemoAppProvidersContainer: SagaProvidersContainer<RootReducer> {
  let cameraRoll: CameraRollProvider.Type! = CameraRollProvider.self
}
