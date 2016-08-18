//
//  sagaProviderContainers.swift
//  ReKatana
//
//  Created by Mauro Bolis on 11/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation
@testable import Katana

enum InformationProvider {
  static func getBaseURL() -> String {
    return "http://base.url"
  }
}

final class AppSagaProviderContainer: SagaProvidersContainer<AppReducer> {
  var informationProvider: InformationProvider.Type?
  
  required init(store: Store<AppReducer>) {
    super.init(store: store)
    
    self.informationProvider = InformationProvider.self
  }
}
