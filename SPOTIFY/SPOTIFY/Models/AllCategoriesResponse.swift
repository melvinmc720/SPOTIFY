//
//  AllCategoriesResponse.swift
//  SPOTIFY
//
//  Created by milad marandi on 3/18/24.
//

import Foundation


struct AllCategoriesResponse:Codable{
    
    let categories:Categories
}

struct Categories:Codable{
    let items:[Category]
}


struct Category:Codable{
    let id:String
    let name:String
    let icons:[APIImage]
}
