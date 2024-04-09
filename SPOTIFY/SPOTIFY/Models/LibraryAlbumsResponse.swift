//
//  LibraryAlbumsResponse.swift
//  SPOTIFY
//
//  Created by kiana mehdiof on 4/8/24.
//

import Foundation
struct LibraryAlbumsResponse:Codable{
    let items:[SavedAlbum]
}

struct SavedAlbum:Codable{
    let added_at:String
    let album:Album
}
