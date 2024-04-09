//
//  SearchResult.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/18/24.
//

import Foundation

enum SearchResult{
    case artist(model:Artist)
    
    case album(model:Album)
    
    case track(model:AudioTrack)
    
    case playlist(model:playlist)
}
