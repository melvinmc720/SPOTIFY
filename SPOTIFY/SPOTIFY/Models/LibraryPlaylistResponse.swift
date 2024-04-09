//
//  LibraryPlaylistResponse.swift
//  SPOTIFY
//
//  Created by milad marandi on 4/1/24.
//

import Foundation

struct LibraryPlaylistResponse:Codable{
    let items:[playlist]
}

/*#warning("fix this")
struct LibraryPlaylist:Codable{
    let description:String
    let external_urls:[String:String]
    let id:String
    let images:[APIImage]?
    let name:String
    let owner:User
}
*/
