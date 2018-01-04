//
//  Marvell_SearchViewController.swift
//  MarvellApp
//
//  Created by Salama on 1/4/18.
//  Copyright © 2018 Salama. All rights reserved.
//

import UIKit

class Marvell_SearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {

    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var characterSearchBar: UISearchBar!
    var mainCharacterDetailsArray = [CharacterDetailModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationItem.hidesBackButton = true
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // UITableview Delegate and Datasource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return mainCharacterDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        let cell:SearchTableViewCell = tableView.dequeueReusableCell(withIdentifier: "searchTableViewCell") as!
        SearchTableViewCell
        
        if(mainCharacterDetailsArray.count > indexPath.row){
            
            //cell.characterImageView.image = UIImage(named: "bg-cell-title")
            let imageUrl = mainCharacterDetailsArray[indexPath.row].characterImagePath
            if(imageUrl != "")
            {
                cell.searchImageView.downloadImageFrom(link: imageUrl, contentMode: UIViewContentMode.scaleAspectFit)
            }
            cell.searchTextLabel.text = mainCharacterDetailsArray[indexPath.row].characterTitle
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 100
    }
    
  
    
    // API Function to fetch and parse data
    func parseData(searchFilter:String)
    {
        
        mainCharacterDetailsArray = []
        
//        let url = URL(string: "http://gateway.marvel.com/v1/public/comics?ts=1&apikey=ba33fa5c1fc7921c901485292d1810ea&hash=ab865a30badc439080b4eafd2529cca7")
        
        let baseurl =  "http://gateway.marvel.com/v1/public/characters?ts=1"
        let searchFilter = "&nameStartsWith=" + searchFilter
        let hash = "&apikey=ba33fa5c1fc7921c901485292d1810ea&hash=ab865a30badc439080b4eafd2529cca7"
        
        let url = URL(string: baseurl+searchFilter+hash)
        
        URLSession.shared.dataTask(with: url!, completionHandler: {
            (data, response, error) in
            if(error != nil){
                print("error")
            }
            else
            {
                do{
                    let fetchedData = try JSONSerialization.jsonObject(with: data!, options:.allowFragments) as! [String : Any]
                    
                    
                    let dataDict:[String:AnyObject] = fetchedData["data"] as! [String:AnyObject]
                    let resultArray:[[String:AnyObject]] = dataDict["results"] as! [[String:AnyObject]]
                    
                    for eachDict in resultArray
                    {
                        let imageDict = eachDict["thumbnail"] as! [String:AnyObject]
                        let imagePath = imageDict["path"] as! String
                        let title = eachDict["name"] as! String
                        let fullImagePath = imagePath + "." + (imageDict["extension"] as! String)
                        self.mainCharacterDetailsArray.append(CharacterDetailModel(CharImagePath: fullImagePath, CharTitle: title))
                    }
                    
                    OperationQueue.main.addOperation({
                        self.searchTableView.reloadData()
                    })
                    
                }
                catch let error as NSError
                {
                    print(error)
                }
            }
        }).resume()
    }
    
    
    
    // search bar delegate
      func searchBarSearchButtonClicked(_ searchBar: UISearchBar)
      {
          if (searchBar.text != "")
          {
             parseData(searchFilter: searchBar.text!)
           }
        
        searchBar.resignFirstResponder()
      }
 
   
      func searchBarCancelButtonClicked(_ searchBar: UISearchBar)
      {
        searchBar.resignFirstResponder()
        self.navigationController?.popViewController(animated: false)
      }

    

}
