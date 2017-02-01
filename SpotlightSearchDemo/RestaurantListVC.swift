//
//  RestaurantListVC.swift
//  SpotlightSearchDemo
//
//  Created by Yudiz Solutions Pvt.Ltd. on 30/01/17.
//  Copyright © 2017 Yudiz Solutions Pvt.Ltd. All rights reserved.
//

import UIKit
import CoreSpotlight
import MobileCoreServices

//Cell
class RestaurantCell: UITableViewCell {
    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblDescription:UILabel!
    @IBOutlet var imgV:UIImageView!
}

//Model
class Restaurant: NSObject {
    var name : String
    var desc : String
    var imgName : String
    init(dict: Dictionary<String,String>) {
        self.name  = dict["Title"]!
        self.desc  = dict["Description"]!
        self.imgName  = dict["Image"]!
    }
}

class RestaurantListVC: UIViewController {

    @IBOutlet var tblView:UITableView!
    
    var restaurantsArr = [Restaurant]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadRestaurants()
        addToSpotlight()
        // Do any additional setup after loading the view.
    }
    
    override func restoreUserActivityState(_ activity: NSUserActivity) {
        if activity.activityType == CSSearchableItemActionType {
            if let userInfo = activity.userInfo {
                let identifer = userInfo[CSSearchableItemActivityIdentifier] as! String
                let index = Int(identifer.components(separatedBy:".").last!)
                performSegue(withIdentifier: "toDetails", sender: index)
            }
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let vc = segue.destination as? ViewController{
            vc.resName = restaurantsArr[sender as! Int].name
        }
    }
 

}
//MARK:- Set Index data
extension RestaurantListVC{
    func addToSpotlight() {
        var searchableItems = [CSSearchableItem]()
        
        for(index,objRes) in restaurantsArr.enumerated() {
            let searchableItemAttributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            searchableItemAttributeSet.title = objRes.name
            searchableItemAttributeSet.thumbnailURL = Bundle.main.url(forResource: objRes.imgName, withExtension: ".jpeg")
            searchableItemAttributeSet.contentDescription = objRes.desc
            searchableItemAttributeSet.keywords = [objRes.name,"Restaurant"]
            
            let searchableItem = CSSearchableItem(uniqueIdentifier: "com.test.spotlight.\(index)", domainIdentifier: "Restaurant", attributeSet: searchableItemAttributeSet)
            
            searchableItems.append(searchableItem)
            
        }
        
        CSSearchableIndex.default().indexSearchableItems(searchableItems) { (error) -> Void in
            if error != nil {
                print(error?.localizedDescription ?? "failed")
            }
        }
    }
    
    func deleteSearchIndex() {
        CSSearchableIndex.default().deleteAllSearchableItems { (error) in
            if let error = error {
                print("error: \(error.localizedDescription)")
            } else {
                print("Search item successfully removed!")
            }
        }
    }
}
//MARK:- Load Data
extension RestaurantListVC {
    
    func loadRestaurants() {
        if let path = Bundle.main.url(forResource: "Restaurants", withExtension: "plist") {
            if let arrObj = NSArray(contentsOf: path) as? [[String:String]] {
                for (_,value) in arrObj.enumerated() {
                    self.restaurantsArr.append(Restaurant(dict: value))
                }
            }
        }
        tblView.reloadData()
    }
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension RestaurantListVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantsArr.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! RestaurantCell
        cell.lblTitle.text = restaurantsArr[indexPath.row].name
        cell.lblDescription.text = restaurantsArr[indexPath.row].desc
        cell.imgV.image = UIImage(named: restaurantsArr[indexPath.row].imgName)
        
        return cell
    }
}

