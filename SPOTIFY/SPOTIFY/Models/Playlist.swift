//
//  Playlist.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import UIKit

struct playlist:Codable{
    
    let description:String?
    let external_urls:[String:String]
    let id:String
    let images:[APIImage]?
    let name:String
    let owner:User
    
}

   /*
    playlist(description: "", external_urls: ["spotify": "https://open.spotify.com/playlist/2mS1wXpy5sBsDM03SYfXut"], id: "2mS1wXpy5sBsDM03SYfXut", images: nil, name: "goodbye", owner: SPOTIFY.User(display_name: "Kiana", external_urls: ["spotify": "https://open.spotify.com/user/31qmxdnoydte7vh3xxzdnbw57gry"], id: "31qmxdnoydte7vh3xxzdnbw57gry"))
    */
