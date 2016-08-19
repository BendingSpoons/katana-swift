//
//  RootState.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

/*
 This is the root state of the application.
 Every application will have a root state, which is basically a container of all the application state's slices
 You will probably never manage this state directly, it will be create from the invokation of other reducers.
 
 Note that in this application, as well as other simple application, this concept of "State that is used to connect slices" is available only in the root of the state. In more complex applications you can use the same approach on other levels of the state. The shape of the state is completely up to you and you can mix states in the way you prefer
 */
struct RootState: State {
  let albums: AlbumListState
}
