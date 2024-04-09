//
//  Settings.swift
//  SPOTIFY
//
//  Created by milad marandi on 2/11/24.
//

import Foundation

struct section{
    
    let title:String
    let option:[options]

}

struct options{
    
    let title:String
    let handler: () -> Void
    
}
