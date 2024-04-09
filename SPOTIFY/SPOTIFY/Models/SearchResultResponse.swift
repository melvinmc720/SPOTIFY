//
//  SearchResultResponse.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/18/24.
//

import Foundation

struct SearchResultResponse:Codable{
    let albums:SearchAlbumResponse
    let artists:SearchArtistsResponse
    let playlists:SearchPlaylistsResponse
    let tracks:SearchTracksResponse
}


struct SearchAlbumResponse:Codable{
    let items:[Album]
}


struct SearchArtistsResponse:Codable{
    let items:[Artist]
}


struct SearchPlaylistsResponse:Codable{
    let items:[playlist]
}


struct SearchTracksResponse:Codable{
    let items:[AudioTrack]
}
