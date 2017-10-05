//
//  TokenModel.swift
//  VersusSysChallenge
//
//  Created by Arbi on 10/1/17.
//  Copyright © 2017 versusSysChallenge. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

struct Token:Mappable{
    
   var access_token:String?
   var token_type:String?
   var expires_in:Double?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        access_token <- map["access_token"]
        token_type   <- map["token_type"]
        expires_in   <- map["expires_in"]
    }
    
}
