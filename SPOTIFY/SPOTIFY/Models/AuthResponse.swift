//
//  AuthResponse.swift
//  SPOTIFY
//
//  Created by milad marandi on 2/7/24.
//

import Foundation

struct AuthResponse:Codable{
    
    var access_token:String
    var expires_in:Int
    var refresh_token:String?
    var scope:String
    var token_type:String
    
}

/*
 SUCCESS json {
     "access_token" = "BQAUkf1NUf8rIrXVaU9-Mps6lY1MeOJNE59XYxOm0UJgp9EW-uy8pPSXq1TASIor8yZdY1teFrLc2bGB9tKi3-doUP9EfS3iPJ0aE4v9NACbfOTiO86JqxI4Stk6EpEH4fHerLBdT8pLwdsaYidPSi33Qp8UnmOYRSu-hmELR-L4RjbT_JEMxa1XF17RSZz3JZbd1SkM5kq3oN6r8qA";
     "expires_in" = 3600;
     "refresh_token" = "AQDwbv3E9HDzxmWFm1MUFfpMU-AkG5j-vG41JYFHH1Auqgtz8oPHiIrM16gcjAUy2NSeH5sWI7YA4n-IA4A3aM2FgvcGFvA9LbWKczn7Wwz_Ira19jd8Ky85UF3LMxeHVzE";
     scope = "user-read-private";
     "token_type" = Bearer;
 }
 */
