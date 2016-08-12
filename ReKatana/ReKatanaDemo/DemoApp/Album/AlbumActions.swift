//
//  AlbumListActions.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

let moduleName = "ALBUMLIST"

/*
 This is an action that manages a sync operation.
 Actually SyncActionCreator returns an action creator. An action creator is basically a function that returns the action. You can specify a name of the actin. It will be used for debugging and internally to determinate things like which reducer invoke in the ReduceCombiner.
 
 Scoping the action name with the module name is a best pratice to avoid naming collisions
 */
let AddAlbumAction = SyncActionCreator<String>(withName: "\(moduleName)/ADD_ALBUM")

/*
 It is a best pratice to define the action type after the action creator.
 The action type is used as a shortcut when you need to use the action as parameter (e.g., in the reducer)
 */
typealias AddAlbumActionType = SyncAction<String>
