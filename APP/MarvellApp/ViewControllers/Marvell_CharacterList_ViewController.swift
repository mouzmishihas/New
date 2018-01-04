//
//  Marvell_CharacterList_ViewController.swift
//  MarvellApp
//
//  Created by Salama on 1/4/18.
//  Copyright © 2018 Salama. All rights reserved.
//

import UIKit

class Marvell_CharacterList_ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    @IBOutlet weak var mainTableView: UITableView!
    var mainCharacterDetailsArray = [CharacterDetailModel]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        // Customise Navigation Bar
       let menu_button_ = UIBarButtonItem(image: UIImage(named: "icn-nav-search"),
                                          style: UIBarButtonItemStyle.plain ,
                                       target: self, action: #selector(OnSearchBarClicked(sender:)))
        
        self.navigationItem.rightBarButtonItem = menu_button_
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.red
        
        let logo = UIImage(named: "icn-nav-marvel")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.isNavigationBarHidden = false
        parseData()
     }
    
    // Method to handle `serach bar click
    @objc func OnSearchBarClicked(sender: UIBarButtonItem) -> Void
    {
        let marvel_search_ViewController = UIStoryboard(name:"Main", bundle:nil).instantiateViewController(withIdentifier: "searchViewControllerIdentifier") as! Marvell_SearchViewController
        
        self.navigationController?.pushViewController(marvel_search_ViewController, animated:false)
    }
    
    
    // UITableview Delegate and Datasource
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
      {
         return mainCharacterDetailsArray.count
      }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
       
        let cell:Marvell_Character_Listing_Cell = tableView.dequeueReusableCell(withIdentifier: "MainCellIdentifier") as!
        Marvell_Character_Listing_Cell
       
        if(mainCharacterDetailsArray.count > indexPath.row){
            
            //cell.characterImageView.image = UIImage(named: "bg-cell-title")
            let imageUrl = mainCharacterDetailsArray[indexPath.row].characterImagePath
            if(imageUrl != "")
            {
               cell.characterImageView.downloadImageFrom(link: imageUrl, contentMode: UIViewContentMode.scaleAspectFill)
            }
          cell.characterNameLabel.text = mainCharacterDetailsArray[indexPath.row].characterTitle
        }
      
        return cell
    }
    
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 200
    }
    
    
    
    // API to parse and fetch data
    func parseData()
    {
        
        mainCharacterDetailsArray = []
        
        let url = URL(string: "http://gateway.marvel.com/v1/public/comics?ts=1&apikey=ba33fa5c1fc7921c901485292d1810ea&hash=ab865a30badc439080b4eafd2529cca7")
        
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
                        let title = eachDict["title"] as! String
                        let fullImagePath = imagePath + "." + (imageDict["extension"] as! String)
                        self.mainCharacterDetailsArray.append(CharacterDetailModel(CharImagePath: fullImagePath, CharTitle: title))
                    }
                    
                    OperationQueue.main.addOperation({
                        self.mainTableView.reloadData()
                    })
                    
                }
                catch let error as NSError
                {
                    print(error)
                }
            }
        }).resume()
    }
    
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

}



//Model Class
class CharacterDetailModel {
    var characterImagePath:String
    var characterTitle:String
    
    
    init(CharImagePath:String, CharTitle:String)
    {
        self.characterImagePath = CharImagePath
        self.characterTitle = CharTitle
    }
}
