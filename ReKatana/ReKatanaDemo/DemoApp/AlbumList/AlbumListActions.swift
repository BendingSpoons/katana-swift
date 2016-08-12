//
//  AlbumListActions.swift
//  ReKatana
//
//  Created by Mauro Bolis on 12/08/16.
//  Copyright © 2016 BendingSpoons. All rights reserved.
//

import Foundation

let moduleName = "ALBUMLIST"

let AddAlbumAction = SyncActionCreator<String>(withName: "\(moduleName)/ADD_ALBUM")
typealias AddAlbumActionType = SyncAction<String>
