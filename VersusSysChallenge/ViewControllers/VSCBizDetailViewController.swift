//
//  VSCBizDetailViewController.swift
//  VersusSysChallenge
//
//  Created by Arbi Derhartunian on 10/3/17.
//  Copyright © 2017 versusSysChallenge. All rights reserved.
//

import UIKit

class VSCBizDetailViewController: UIViewController {

    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var reviewTextViewExtra: UITextView!
    @IBOutlet weak var reviewTextView: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    
    var listOfPhotos:[String] = []
    var listOfReviews:[ReviewsData] = []
    var imageViews:[UIImageView] = []
    var networkManger:NetworkManager?
    let cellID = "bizDetailCell"
    var newSize:CGSize = CGSize()
    let screensize:CGFloat = CGFloat(UIScreen.main.bounds.size.width)
    var id:String = ""
    var name:String = ""
    var rating:Int = 0
    let itemHeight:CGFloat = 350
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        listOfPhotos.removeAll()
        listOfReviews.removeAll()
        imageViews.removeAll()
        
    }
    deinit {
        removeStackView()
        networkManger = nil
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        
    }
    func setupCell(){
        
        let nib = UINib(nibName: "VSCBizDetailCell", bundle: Bundle.main)
        colView.register(nib, forCellWithReuseIdentifier: cellID)
        
    }
    func populateImages(){
        
        for _ in 0..<5{
            let image = UIImageView(image: UIImage(named:"star"))
            imageViews.append(image)
        }
        
    }
    
    func removeStackView(){
        for views in self.view.subviews{
            
            if views is UIStackView{
                
                views.removeFromSuperview()
            }
        }
    }
    //same calculate for stars with different constraints
    func calculateStars(number:Int){
        
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 0
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        
        removeStackView()
      
        
        for i in 0..<number{
            stackView.addArrangedSubview(imageViews[i])
            
        }
        if stackView.arrangedSubviews.count > 5{
            return
        }
        if self.view.subviews.contains(stackView){
            return
        }
        self.view.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo:colView.leadingAnchor),
          
           stackView.topAnchor.constraint(equalTo: self.view.topAnchor,constant:100),
            stackView.heightAnchor.constraint(equalToConstant: 40),
            Int(number) > 3 ? stackView.widthAnchor.constraint(equalTo: colView.widthAnchor, multiplier: 0.50, constant: 0) :
                stackView.widthAnchor.constraint(equalTo: colView.widthAnchor, multiplier: 0.30, constant: 0)
            ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        colView.frame = CGRect(x:colView.frame.origin.x, y:colView.frame.origin.y,width: 400, height:600)
        colView.contentSize = CGSize(width: 400, height: 600)
        colView.delegate = self
        colView.dataSource = self
        setupCell()
        
        populateImages()
        calculateStars(number: rating)
        //fetches reviews,I usually get 3 but i am populating 2
        //I do this logic since not all the time its 3 comments
        networkManger?.fetchComments(id: id, success: {[unowned self]
            reviews in
            
    
            self.nameLabel.text = self.name
            
            if reviews.count == 0{
                Utilities.displayErrorMessage(message:
                    "could not load reviews for this business", title: "Error", vc: self)
                return
                
            }
        
            if reviews.count == 1
            {
                if let firstReview = reviews.first?.text, let name = reviews.first?.user?.name{
                    self.reviewTextView.text = "name:\(name)\t\(firstReview)"
                }
            }
            else{
                if let firstReview = reviews.first?.text, let name = reviews.first?.user?.name{
                    self.reviewTextView.text = "name:\(name)\t\(firstReview)"
                }
                if let secondReview = reviews[1].text, let name = reviews[1].user?.name{
                    self.reviewTextViewExtra.text = "name:\(name)\t\(secondReview)"
                }
            }
            self.colView.reloadData()
        }, fail: { (error) in
            DispatchQueue.main.async {[unowned self] in
                self.checkForErrors(error: error)
            }

        })
  
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colView.reloadData()
    }
    //check for erros and calles the displayError from Utilities
    func checkForErrors(error:networkErrorType){
        switch(error)
        {
            
        case .apiError(let name):
            if name != "nil"{
                Utilities.displayErrorMessage(message: name, title: "APIError", vc: self)
            }
        case .otherError(let name):
            if name != "nil"{
                Utilities.displayErrorMessage(message: name, title: "Error", vc: self)
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

extension VSCBizDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfPhotos.count
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let detailBizCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? VSCBizDetailCell
        
        let otherCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        
        
        if let detailCell = detailBizCell{
            
            let urlString = listOfPhotos[indexPath.row]
            networkManger?.fetchImagesForURL(urlString: urlString, success: { (image) in
                
                detailCell.bizImageView.image = image
                
                
            }, fail: { error in
                DispatchQueue.main.async {[unowned self] in
                   
                        self.checkForErrors(error: error)
                    
                }
                
            })
            
            return detailCell
        }
        return otherCell
        
    }
    
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let index = scrollView.contentOffset.x / colView.frame.width
        let fracPart = index.truncatingRemainder(dividingBy: 1)
        let item = Int(fracPart >= 0.5 ? ceil(index) : floor(index))
        
        let indexPath = IndexPath(item: item, section: 0)
        colView.scrollToItem(at: indexPath, at: .left, animated: true)
        
    }
    
   
    
}
extension VSCBizDetailViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        newSize =  CGSize(width:colView.bounds.size.width, height:itemHeight)
        return newSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top:0, left: 0, bottom: 0, right:0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
