//
//  BusinessModel.swift
//  VersusSysChallenge
//
//  Created by Arbi on 9/29/17.
//  Copyright © 2017 versusSysChallenge. All rights reserved.
//

import Foundation
import ObjectMapper
import AlamofireObjectMapper


struct BusinessRegion:Mappable{
    var longitude:Double?
    var latitude:Double?
    
    mutating func mapping(map: Map) {
        longitude <- map["longitude"]
        latitude <- map["latitude"]
        
    }
    init?(map: Map) {
     
    }
}



struct  BusinessModel:Mappable{
    
    var businesses:[Businesses]?
    var total:Int?
    var region:BusinessRegion?
    mutating func mapping(map: Map) {
        businesses <- map["businesses"]
        total <- map["total"]
        region <- map["region.center"]
        
    }
    init?(map: Map) {
       
    }
    
}
struct BusinessLocationInfo:Mappable{
    
    var address1:String?
    var address2:String?
    var address3:String?
    var city:String?
    var zipCode:String?
    var country:String?
    var state:String?
    var displayAddress:[String]?
    
    mutating func mapping(map: Map) {
       
        address1 <- map["address1"]
        address2 <- map["address2"]
        address3 <- map["address3"]
        city <- map["city"]
        zipCode <- map["zip_code"]
        country <- map["country"]
        state <- map["state"]
        displayAddress <- map["display_address"]
    
    }
    init?(map: Map) {
        
    }
    
}


struct Businesses:Mappable{
    
    var id:String?
    var name:String?
    var image_url:String?
    var is_closed:Bool?
    var url:String?
    var review_count:Int?
    var categories:[[String:Any]]?
    var rating:Float?
    var longitude:Double?
    var latitude:Double?
    var transactions:[String]?
    var price:String?
    var location:BusinessLocationInfo?
    var phone:String?
    var display_phone:String?
    var distance:Double?
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name <- map["name"]
        image_url <- map["image_url"]
        is_closed <- map["is_closed"]
        url <- map["url"]
        review_count <- map["review_count"]
        categories <- map["categories"]
        rating <- map["rating"]
        longitude <- map["coordinates.longitude"]
        latitude <- map["coordinates.latitude"]
        transactions <- map["transactions"]
        price <- map["price"]
        location <- map["location"]
        phone <- map["phone"]
        display_phone <- map["display_phone"]
        distance <- map["distance"]
        
    }
   
    init?(map: Map) {
        
    }

}


