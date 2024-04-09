//
//  UserProfile.swift
//  SPOTIFY
//
//  Created by milad marandi on 1/13/24.
//

import Foundation


struct UserProfile:Codable
{
      let country:String
      let display_name:String
      let email:String
      let id:String
      let images:[UserImage]
      let product:String
      let type:String
      let uri:String
}

struct UserImage:Codable{
    let url:String?
}
