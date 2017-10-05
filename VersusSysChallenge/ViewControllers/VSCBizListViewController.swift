//
//  VSCBizListViewController.swift
//  VersusSysChallenge
//
//  Created by Arbi on 9/30/17.
//  Copyright © 2017 versusSysChallenge. All rights reserved.
//

import UIKit

class VSCBizListViewController: UIViewController , VSCLocationManagerProtocol {

    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collCell: UICollectionView!
    let reuseID = "bizCellId"
    var networkManager:NetworkManager?
    var businesses:[Businesses] = []
    var businessPhotos:[String] = []
    var businessImages:[UIImageView] = []
    let screensize:CGFloat = CGFloat(UIScreen.main.bounds.size.width  / CGFloat(3.4))
    var newSize:CGSize = CGSize()
    let locationManager = VSCLocationManager()
    let tapGestureRecognizer = UITapGestureRecognizer()
    var selectedIndex:Int = 0
    var activityIndicator:UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        return spinner
    }()
    
    func fetchBusinessInfo(term:String){
        let long = locationManager.longitude
        let lat = locationManager.latitude
        let tokenParam = ["term":term,"latitude":"\(lat)","longitude":"\(long)"]
        activityIndicator.center = self.view.center
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        
        self.networkManager?.fetchBusinessData(tokenParam: tokenParam, success: { (model) in
            self.businesses = model
            self.activityIndicator.stopAnimating()
            DispatchQueue.main.async {[weak self] in
                
                self?.collCell.reloadData()
            }
            
        }, fail: { error in

            DispatchQueue.main.async {[unowned self] in
                
                self.showError(error: error)
                
            }
        })
    }

    func showError(error:networkErrorType){
        
        switch(error)
        {
        case .otherError(let name):
            if name != "nil" || !name.isEmpty{
            Utilities.displayErrorMessage(message: name, title: "OtherError", vc: self)
            }
        case .apiError(let name):
            if name != "nil" || !name.isEmpty{
            Utilities.displayErrorMessage(message: name, title: "APIError", vc: self)
            }
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collCell.delegate = self
        collCell.dataSource = self
        setupCell()
        locationManager.vscDelegate = self
        searchTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    func setupCell(){
       let nib = UINib(nibName: "VSCBizListCell", bundle: Bundle.main)
       collCell.register(nib, forCellWithReuseIdentifier: reuseID)
        
    }
    //gets all the closes location with a search term.
    @IBAction func findNearMe(_ sender: UIButton) {
        
        guard let searchTerm = searchTextField.text else{
            return
        }
        fetchBusinessInfo(term:searchTerm )
        searchTextField.resignFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func didUpdateLocation(long: Double, lat: Double) {
       // print(long)
        //print(lat)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        activityIndicator.removeFromSuperview()
        
        
        
    }
    deinit {
        networkManager = nil
    }

}
extension VSCBizListViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        //get the id of the selected Business
        
        guard let id = businesses[indexPath.row].id else{
            return
        }
        activityIndicator.startAnimating()
        networkManager?.fetchBusinessDetail(id: id, success: {[weak self] model in
            self?.activityIndicator.stopAnimating()
            if let photosURL = model.photos{
               
                self?.businessPhotos = photosURL
                self?.performSegue(withIdentifier: "showDetail", sender: self)
            }
            
        }, fail: { error in
            DispatchQueue.main.async {[unowned self] in
                self.showError(error: error)
            }
        })
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as? VSCBizDetailViewController
   
        guard let id = businesses[selectedIndex].id, let name = businesses[selectedIndex].name else{
            return
        }
        if let netManager = self.networkManager{
            destination?.networkManger = netManager
            destination?.id = id
            destination?.name = name
            if let rating = businesses[selectedIndex].rating
            {
                destination?.rating = Int(rating)
                
            }
        }
        if businessPhotos.count > 0{
            destination?.listOfPhotos = businessPhotos
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let bizCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as? VSCBizListCell
        let otherCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath)
        
        if let bizCell = bizCell{
            
            bizCell.businessLabel.text = businesses[indexPath.row].name
            guard let imageURL = businesses[indexPath.row].image_url else{
                return otherCell
            }
            activityIndicator.startAnimating()
            networkManager?.fetchImagesForURL(urlString: imageURL, success: {[weak self] img in
                self?.activityIndicator.stopAnimating()
                bizCell.businessImageView.image = img
                if let starCount = self?.businesses[indexPath.row].rating{
                    bizCell.calculateStars(number: starCount)
                }
                
            }, fail: { (error) in
                DispatchQueue.main.async {[unowned self] in
                    self.showError(error: error)
                }
                
            })
            
            return bizCell
        }
        
        return otherCell
        
    }
    
}
    
extension VSCBizListViewController:UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        newSize =  CGSize(width:screensize, height: UIScreen.main.bounds.height / 4.0 )
        
        return newSize
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right:0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension VSCBizListViewController:UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.resignFirstResponder()
        return true
    }
    
    
}


