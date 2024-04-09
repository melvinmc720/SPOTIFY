//
//  Artist.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import Foundation

struct Artist:Codable{
    let id:String
    let name:String
    let type:String
    let images:[APIImage]?
    let external_urls:[String: String]
}
