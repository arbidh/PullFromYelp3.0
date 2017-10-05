//
//  NetworkManager.swift
//  VersusSysChallenge
//
//  Created by Arbi on 9/29/17.
//  Copyright © 2017 versusSysChallenge. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

enum networkErrorType{
    
    case apiError(name:String)
    case otherError(name:String)
    
}

//in a real app i would put this in a keychain and obsuficate it
let clientID = "e9nvBTizK75NMLVq3-O1hg"
let client_secret = "qpnq5g289LO8bbk7djoklHQfnzLm1uiX9XA6AWXBTevGY36X8dzxz8zV0cF3hMi9"
let businessDetailEndpoint = "https://api.yelp.com/v3/businesses"


class NetworkManager{
    
    var accessToken:String?
    var expiryDate: Date?
    
    func checkIfTokenIsExpired()->Bool{
        
        guard let date = UserDefaults.standard.value(forKey: "tokenExpiredDate") as? Date else
        {
            return true
        }
      
        if date > Date(){
            return true
        }
        return false
        
    }
    
    func saveTokenInfo(){
        
        guard  let accessToken = self.accessToken, let tokenDate = self.expiryDate else {
            return
        }
        
        UserDefaults.standard.set(accessToken, forKey: "accessToken")
        UserDefaults.standard.set(tokenDate, forKey: "tokenExpiredDate")
        UserDefaults.standard.synchronize()
        
    }
    func getTokenInfo(){
        
        let accessToken = UserDefaults.standard.value(forKey: "accessToken") as? String
        let tokenDate = UserDefaults.standard.value(forKey: "tokenExpiredDate") as? Date
        self.accessToken = accessToken
        self.expiryDate = tokenDate
        
    }
    
    func authenticatWithYelp(success:@escaping (_ token:Token)->Void,
                             fail:@escaping (networkErrorType)->Void)
    {
        
        var tokenParam = [String:String]()
        
        tokenParam.updateValue(client_secret, forKey: "client_secret")
        tokenParam.updateValue(clientID, forKey: "client_id")
        tokenParam.updateValue("grant_type", forKey: "client_credentials")
        guard let yelpAuthURL = URL(string:"https://api.yelp.com/oauth2/token") else {
            
            return
        }
        
        DispatchQueue.global().async {
            
            if self.checkIfTokenIsExpired(){
                
                Alamofire.request(yelpAuthURL, method: .post, parameters:tokenParam, encoding:URLEncoding.default  , headers: nil).responseObject(completionHandler:{[weak self] (resp:DataResponse<Token>) in
                    if let tokenValue = resp.result.value{
                        if let accessToken = tokenValue.access_token,let timeIntv = tokenValue.expires_in {
                            self?.accessToken = accessToken
                            self?.expiryDate = NSDate(timeIntervalSince1970:timeIntv) as Date
                            self?.saveTokenInfo()
                            
                            success(tokenValue)
                        }
                    }
                    else{
                        fail(networkErrorType.apiError(name: resp.error.debugDescription))
                    }
                })
            }
            else{
                self.getTokenInfo()
            }
        }
    }
    
    func fetchComments(id:String,success:@escaping(_ comments:[ReviewsData])->Void, fail:@escaping(networkErrorType)->Void){
        
        guard let accessToken = self.accessToken else{
            print(networkErrorType.otherError(name: "AccessToken is nil"))
            return
        }
        let headers = ["Authorization":"Bearer \(accessToken)"]
        
        guard let yelpAuthURL = URL(string:"\(businessDetailEndpoint)/\(id)/reviews") else {
            return
        }
        DispatchQueue.global().async {
            Alamofire.request(yelpAuthURL, method: .get, parameters:nil, encoding:URLEncoding.default  , headers: headers).responseObject(completionHandler:{ (resp:DataResponse<BusinessCommentsModel>) in
                if let reviewsModel = resp.result.value{
                    if let reviews = reviewsModel.listOfReviews{
                        if reviews.count > 0{
                            DispatchQueue.main.async {
                                success(reviews)
                            }
                        }
                        else{
                            fail(networkErrorType.otherError(name: "Reviews data returned empty"))
                        }
                    }
                    
                }
                else{
                    fail(networkErrorType.apiError(name: resp.error.debugDescription))
                }
                fail(networkErrorType.apiError(name: resp.result.error.debugDescription))
            })
        }
    }
    
    
    func fetchBusinessDetail(id:String, success:@escaping(_ bizDetal:BusinessDetailModel)->Void, fail:@escaping(networkErrorType)->Void){
        
        guard let accessToken = self.accessToken else{
            print(networkErrorType.otherError(name: "AccessToken is nil"))
            return
        }
        let headers = ["Authorization":"Bearer \(accessToken)"]
        let urlString = "\(businessDetailEndpoint)/\(id)"
.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        guard let yelpAuthURL = URL(string:urlString!) else{
            return
        }
        DispatchQueue.global().async {
            
            Alamofire.request(yelpAuthURL, method: .get, parameters:nil, encoding:URLEncoding.default  , headers: headers).responseObject(completionHandler:{ (resp:DataResponse<BusinessDetailModel>) in
                if let businessDetail = resp.result.value{
                    DispatchQueue.main.async {
                        success(businessDetail)
                    }
                    
                }
                    
                else{
                    fail(networkErrorType.apiError(name: resp.error.debugDescription))
                }
             
            })
        }
        
    }
    
    func fetchBusinessData(tokenParam:[String:String],
                           success:@escaping(_ businessList:[Businesses])->Void,
                           fail:@escaping(networkErrorType)->Void)
    {
        
        
        guard let accessToken = self.accessToken else{
            print(networkErrorType.otherError(name: "AccessToken is nil"))
            return
        }
        let headers = ["Authorization":"Bearer \(accessToken)"]
        
        guard let yelpAuthURL = URL(string:"\(businessDetailEndpoint)/search") else {
            return
        }
        DispatchQueue.global().async {
            
            Alamofire.request(yelpAuthURL, method: .get, parameters:tokenParam, encoding:URLEncoding.default  , headers: headers).responseObject(completionHandler:{ (resp:DataResponse<BusinessModel>) in
                if let businessModel = resp.result.value{
                    
                    if let businesses = businessModel.businesses{
                        
                        if businesses.count > 0{
                            DispatchQueue.main.async {
                                success(businesses)
                            }
                            
                        }
                        else{
                            fail(networkErrorType.otherError(name: "Businesses returned empty"))
                        }
                    }
                    
                }
                else{
                    fail(networkErrorType.apiError(name: resp.error.debugDescription))
                }
                
            })
        }
    }
    
    func fetchImagesForURL(urlString:String, success:@escaping (UIImage)->Void, fail:(networkErrorType)->Void) {
        
        guard let imageURL = URL(string:urlString) else {
            return
        }
        DispatchQueue.global().async {
            
            Alamofire.request(imageURL).responseData(completionHandler: { (resp) in
                
                if let data = resp.data
                {
                    DispatchQueue.main.async {
                        if let image = UIImage(data: data){
                            
                            success(image)
                        }
                    }
                }
            })
        }
    }
    
}

