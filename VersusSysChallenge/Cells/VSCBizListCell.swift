//
//  VSCBizListCell.swift
//  VersusSysChallenge
//
//  Created by Arbi on 9/30/17.
//  Copyright © 2017 versusSysChallenge. All rights reserved.
//

import Foundation
import UIKit


class VSCBizListCell:UICollectionViewCell{
    @IBOutlet weak var businessImageView: UIImageView!
    @IBOutlet weak var businessLabel: UILabel!
    
    var imageViews:[UIImageView] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        populateImages()
        businessImageView.isUserInteractionEnabled = true
        
    }
    func populateImages(){
        
        for _ in 0..<5{
            let image = UIImageView(image: UIImage(named:"star"))
            imageViews.append(image)
        }
        
    }
    func removeStackView(){
        for views in self.subviews{
            
            if views is UIStackView{
                
                views.removeFromSuperview()
            }
        }
    }
    deinit {
        removeStackView()
        imageViews.removeAll()
    }
    //calucates stars, this would be better generic, but
    //I used it in 2 places. In real app i would move it to utilites
    //also i am rounding the number of starts since i dont have half
    //stars
    func calculateStars(number:Float){
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        removeStackView()
        
        for i in 0..<Int(number){
            
            stackView.addArrangedSubview(imageViews[i])
            
        }
        if stackView.arrangedSubviews.count > 5{
            return
        }
        
        if self.subviews.contains(stackView){
            return
        }
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            
            stackView.centerXAnchor.constraint(equalTo: businessImageView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo:businessLabel.topAnchor),
            stackView.topAnchor.constraint(equalTo: businessImageView.bottomAnchor, constant: 5),
            stackView.heightAnchor.constraint(equalToConstant: 20),
            Int(number) > 3 ? stackView.widthAnchor.constraint(equalTo: businessImageView.widthAnchor, multiplier: 0.90, constant: 0) :
                stackView.widthAnchor.constraint(equalTo: businessImageView.widthAnchor, multiplier: 0.50, constant: 0)
            ])
        }
    
    
}
