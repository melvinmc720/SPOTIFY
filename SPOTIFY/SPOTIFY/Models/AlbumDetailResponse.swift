//
//  AlbumDetailResponse.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/5/24.
//

import Foundation

struct AlbumDetailResponse:Codable{
    
    let album_type: String
    let artists: [Artist]
    let available_markets: [String]
    let external_urls: [String: String]
    let id: String
    let images: [APIImage]
    let label: String
    let name: String
    let tracks: TrackResponse
}

struct TrackResponse:Codable{
    let items:[AudioTrack]
}
