//
//  VSCUtilities.swift
//  VersusSysChallenge
//
//  Created by Arbi Derhartunian on 10/5/17.
//  Copyright © 2017 versusSysChallenge. All rights reserved.
//

import Foundation
import UIKit


class Utilities{
    //utility funciton to display error message
    class func displayErrorMessage(message:String, title:String, vc:UIViewController){
        
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Retry", style: .default) { action in
            alertController.dismiss(animated: true, completion: nil)
            
        }
        alertController.addAction(action)
        vc.present(alertController, animated: true, completion: nil)
        
    }
    
}
