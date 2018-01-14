//
//  DownloadViewController.swift
//  BytePad
//
//  Created by Utkarsh Bansal on 17/04/16.
//  Copyright © 2016 Software Incubator. All rights reserved.
//

import UIKit
import QuickLook

class DownloadViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, QLPreviewControllerDataSource {
    
    var items = [(name:String,detail:String,url:String)]()

    @IBOutlet weak var downloadsTable: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print(items[(indexPath as NSIndexPath).row].url)
        
//        performSegueWithIdentifier("DocumentViewSegue", sender: items[indexPath.row].url)
        
        let previewQL = QLPreviewController() // 4
        previewQL.dataSource = self // 5
        previewQL.currentPreviewItemIndex = (indexPath as NSIndexPath).row // 6
        show(previewQL, sender: nil) // 7
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = self.downloadsTable.dequeueReusableCell(withIdentifier: "Download Cell") as? DownloadsTableCell {
            
            cell.initCell(items[(indexPath as NSIndexPath).row].name, detail:items[(indexPath as NSIndexPath).row].detail, fileURL: items[(indexPath as NSIndexPath).row].url)

            return cell
        }
        
        return DownloadsTableCell()
        
    }
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        
        let titleLabel = UILabel()
        let colour = UIColor(red:1.00, green:1.00, blue:1.00, alpha:0.6)
        let attributes: [String : AnyObject] = [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: colour, NSKernAttributeName : 3.5 as AnyObject]
        titleLabel.attributedText = NSAttributedString(string: "BYTEPAD", attributes: attributes)
        titleLabel.sizeToFit()
        self.navigationItem.titleView = titleLabel
        
        items.removeAll()
        
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print("Hello"+String(describing: documentsUrl))
        
        // now lets get the directory contents (including folders)
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl[0], includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions())
   print("HI")
            print(directoryContents)
            
            for  file in directoryContents {
                print(file.lastPathComponent)
                print(file.absoluteURL)
                print(file.baseURL)
                print((file as NSURL).filePathURL)
                let fileName = file.absoluteString
                let fileArray = fileName.components(separatedBy: "_")
                let finalFileName = fileArray[fileArray.count-1]
                
                // Save the data in the list as a tuple
                self.items.append((file.lastPathComponent,"",file.absoluteString))
            }
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        downloadsTable.reloadData()
    }
    
    // MARK: Preview
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return items.count
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        let url:URL = URL(string: items[index].url)!
        print(url)
        return url as QLPreviewItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
