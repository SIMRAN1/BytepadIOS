//
//  ViewController.swift
//  Bytepad
//
//  Created by Utkarsh Bansal on 17/04/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit
import SwiftyJSON
//import Onboard
import Alamofire
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating, UISearchBarDelegate{
    
    //MARK: Variables
    
    var papers = [Paper]()
    var filteredPapers = [Paper]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
  /*  let firstPage = OnboardingContentViewController(title: nil, body: "Swipe to download", image: UIImage(named: "ss1"), buttonText: nil) { () -> Void in
        // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        print( 1+1)
    }
    
    
    
    let secondPage = OnboardingContentViewController(title: "Page Title", body: "Page body goes here.", image: UIImage(named:"description2"), buttonText: nil) { () -> Void in
        // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        
    }
    
    let thirdPage = OnboardingContentViewController(title: "Page Title", body: "Page body goes here.", image: UIImage(named:"description3"), buttonText: nil) { () -> Void in
        // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        
    }*/
    var ExamType:[Int:String] = [1:"UT", 2:"PUT", 3:"ST-1",4:"ST-2"]
    
    // MARK: Outlets
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var loadingMessageLabel: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    
    //MARK: Actions
    @IBAction func retryButton(_ sender: UIButton) {
        self.loadingMessageLabel.isHidden = false
        self.loadingMessageLabel.text = "While the satellite moves into position..."
        self.activityIndicator.isHidden = false
        self.activityIndicator.startAnimating()
        self.retryButton.isHidden = true
        self.getPapersData()
        
    }
    
    // MARK: Table View
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // If in searching mode, then return the number of results else return the total number
        if searchController.isActive  {
            return filteredPapers.count
        }
        return papers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let paper: Paper
        
        if searchController.isActive  {
            paper = filteredPapers[(indexPath as NSIndexPath).row]
        } else {
            paper = papers[(indexPath as NSIndexPath).row]
        }
        
        if let cell = self.table.dequeueReusableCell(withIdentifier: "Cell") as? PapersTableCell {
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.initCell(paper.name, detail: paper.detail)
            return cell
        }
        
        return PapersTableCell()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let downloadButton = UITableViewRowAction(style: .normal, title: "Download") { action, index in
            
            var url: String
            
            if self.searchController.isActive {
                url = "http://testapi.silive.in/PaperFileUpload/"+self.category+"/"+String(self.filteredPapers[(indexPath as NSIndexPath).row].url)
            } else {
                url = "http://testapi.silive.in/PaperFileUpload/"+self.category+"/"+String(self.papers[(indexPath as NSIndexPath).row].url)
            }
            /*var urltemp = "http://testapi.silive.in/PaperFileUpload/PUT/PUT%20Even%20Sem%20%202011%20-%202012%20Solution%2FAdvance%20Computer%20Architecture%20TCS802.doc"*/
            url = url.replacingOccurrences(of: " ", with: "%20")
            let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory, in: .userDomainMask)
            
            self.table.isEditing = false
            
//            Alamofire.download(.GET, url, destination: destination).response { _, _, _, error in
//                if let error = error {
//                    print("Failed with error: \(error)")
//                } else {
//                    print("Downloaded file successfully")
//                }
//            }
//            Alamofire.download( url, to: destination).response { _, _, _, error in
//                if let error = error {
//                    print("Failed with error: \(error)")
//                } else {
//                    print("Downloaded file successfully")
//                }
//            }
            print(url)
            Alamofire.download(url, to: destination).response { response in
                print(response)
                
                if response.error == nil{
                print("Downloaded file successfully")
                }
                else{
                  print("Failed with error: \(response.error)")
                }
            }
        }
        
        
        
        UIButton.appearance().setTitleColor(Constants.Color.grey, for: UIControlState())
        
        return [downloadButton]

    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // the cells you would like the actions to appear needs to be editable
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        // you need to implement this method too or you can't swipe to display the actions
    }
    
    // MARK: Search
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filteredPapers = papers.filter { paper in
            let categoryMatch = (scope == "All") || (paper.exam == scope)
            if searchController.searchBar.text != ""{
            return  categoryMatch && paper.name.lowercased().contains(searchText.lowercased())
            }
            else {
                return categoryMatch
            }
        }
        
        table.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        let scope = searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex]
        filterContentForSearchText(searchController.searchBar.text!, scope: scope)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!, scope: searchBar.scopeButtonTitles![selectedScope])
    }
    
    // MARK: Defaults
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*let onboardingVC = OnboardingViewController(backgroundImage: nil, contents: [firstPage,secondPage,thirdPage])
       // onboardingVC.allowSkipping = true;
        onboardingVC?.skipHandler = {
            self.dismiss(animated: true, completion: nil)
        }
        
        UIButton.appearance().setTitleColor(Constants.Color.grey, for: UIControlState())
        
        onboardingVC?.skipButton.setTitleColor(UIColor.black, for: UIControlState())
        onboardingVC?.pageControl.pageIndicatorTintColor = UIColor.black
        onboardingVC?.pageControl.currentPageIndicatorTintColor = UIColor.red
//        onboardingVC.pageControl.backgroundColor = UIColor.lightGrayColor()
        onboardingVC?.shouldMaskBackground = false
        onboardingVC?.topPadding = 0
        
        let screenSize: CGRect = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        firstPage?.iconHeight = CGFloat(screenHeight+44)
        firstPage?.iconWidth = CGFloat(screenWidth)
        firstPage?.underIconPadding = CGFloat(0)

        
        self.present(onboardingVC!, animated: true, completion: nil)
        */
        self.getPapersData()
        
        searchController.searchBar.tintColor = UIColor(red:0.45, green:0.45, blue:0.45, alpha:1.0)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        table.tableHeaderView = searchController.searchBar
        searchController.searchBar.scopeButtonTitles = ["All", "ST-1", "ST-2", "PUT", "UT"]
        searchController.searchBar.delegate = self
        activityIndicator.startAnimating()
        
        
        let titleLabel = UILabel()
        let colour = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: colour, NSKernAttributeName : 3.5 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "BYTEPAD", attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: API call
    var category: String = ""
    func getPapersData(){
        Alamofire.request( "http://testapi.silive.in/api//get_list_")
            .responseJSON { response in
                
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                
                // If the network works fine
                if response.result.isFailure != true {
                    
                    self.loadingMessageLabel.isHidden = true
                    self.table.isHidden = false
                    //print(response.result)   // result of response serialization
                    
                    let json = JSON(response.result.value!)
                    
                    for item in json {
                        // Split the title on the . to remove the extention
                        let title = item.1["file_url"].string!.characters.split(separator: "/").map(String.init)[1].characters.split(separator: ".").map(String.init)[0]
                        self.category = self.ExamType[item.1["exam_type_id"].int!]!
                        let url = item.1["file_url"].string
                        let detail = item.1["file_url"].string!.characters.split(separator: "/").map(String.init)[0]
                        
                        let paper = Paper(name: title, exam: self.category, url: url!, detail: detail)
                        self.papers.append(paper)
                        
                    }
                    self.table.reloadData()
                    
                }
                    // If the network fails
                else {
                    self.retryButton.isHidden = false
                    self.loadingMessageLabel.text = "Check your internet connectivity"
                }
                
        }
    }
    

}

