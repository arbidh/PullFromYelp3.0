//
//  ViewController.swift
//  VersusSysChallenge
//
//  Created by Arbi on 9/29/17.
//  Copyright © 2017 versusSysChallenge. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let networkManager = NetworkManager()
    
    @IBOutlet weak var enterBtn: UIButton!
    //gets the token for all the requests
    func authenticate(){
        networkManager.authenticatWithYelp(success: { resp in
            
        }) { type in
            
        }
    }
    func setupView(){
        enterBtn.layer.cornerRadius = enterBtn.frame.size.height / 2
        enterBtn.layer.borderColor = UIColor.black.cgColor
        enterBtn.layer.borderWidth = 2
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVc:UINavigationController = (segue.destination as? UINavigationController)!
        let vc = destinationVc.viewControllers.first as? VSCBizListViewController
        vc?.networkManager = networkManager
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authenticate()
        setupView()
        // Do any additional setup after loading the view, typically from a nib.
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

