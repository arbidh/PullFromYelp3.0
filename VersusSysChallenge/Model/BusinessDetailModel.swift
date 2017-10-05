//
//  BusinessDetailModel.swift
//  VersusSysChallenge
//
//  Created by Arbi Derhartunian on 10/4/17.
//  Copyright © 2017 versusSysChallenge. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper

struct BusinessDetailModel:Mappable{
    
    var id:String?
    var name:String?
    var imageURL:String?
    var is_claimed:Bool?
    var is_closed:Bool?
    var url:String?
    var price:String?
    var rating:Int?
    var review_count:Int?
    var phone:String?
    var photos:[String]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        id <- map["id"]
        name <- map["name"]
        imageURL <- map["image_url"]
        is_claimed <- map["is_claimed"]
        is_closed  <- map["is_closed"]
        url        <- map["url"]
        price      <- map["price"]
        rating     <- map["rating"]
        review_count <- map["review_count"]
        phone       <- map["phone"]
        photos      <- map["photos"]
    }
    
}
struct ReviewsUserData:Mappable{
    
    var image_url:String?
    var name:String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        image_url <- map["image_url"]
        name      <- map["name"]
    }
    
}
struct ReviewsData:Mappable{
 
    var rating:Int?
    var user:ReviewsUserData?
    var text:String?
    var timeCreated:String?
    var url:String?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        
        rating <- map["rating"]
        user   <- map["user"]
        text   <- map["text"]
        timeCreated <- map["time_created"]
        url        <- map["url"]
    }
    
    
}

struct BusinessCommentsModel:Mappable{
    
    var listOfReviews:[ReviewsData]?
    
    init?(map: Map) {
        
    }
    mutating func mapping(map: Map) {
        listOfReviews <- map["reviews"]
    }
    
}
