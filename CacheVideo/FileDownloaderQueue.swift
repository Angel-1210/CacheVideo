//
//  FileDownloaderQueue.swift
//  CacheVideo
//
//  Created by Dharmesh on 02/08/16.
//  Copyright © 2016 dharmesh. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

class FileDownloaderQueue : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableMediaList : UITableView!
    
    var mediaList : [MediaModel]! = []
    
    var queue : NSOperationQueue!
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")
        
        let data = mediaList[indexPath.row]
        
        cell?.textLabel?.text = data.file
        
        return cell!
    }
    
    //------------------------------------------------------
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //------------------------------------------------------
    
    //MARK: UIView Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        
        tableMediaList.delegate = self
        tableMediaList.dataSource = self
        
        let manager = AFHTTPSessionManager()
        let reachability = AFNetworkReachabilityManager()
        
        //request
        manager.requestSerializer.cachePolicy = .ReturnCacheDataElseLoad
        
        AFNetworkActivityIndicatorManager.sharedManager().enabled = true
        
        if reachability.reachable {
            debugPrint("Reachable")
        } else {
            debugPrint("Not Reachable")
        }
        
        let acceptableContentsType : NSMutableSet = NSMutableSet()
        acceptableContentsType.addObject("text/html")
        acceptableContentsType.addObject("application/json")
        manager.responseSerializer.acceptableContentTypes = NSSet(set: acceptableContentsType) as? Set<String>
        
        let dataTask = manager.GET("http://gurpreetnamdhari.com/nCommon/demo_api.php", parameters: nil, success: { (dataTask : NSURLSessionDataTask, response : AnyObject?) in
            
            let messageModel = MessageMediaModel(fromDictionary: response! as! NSDictionary)
            
            if (messageModel.status == "1") {
                
                debugPrint(messageModel.toDictionary())
                self.mediaList = messageModel.data
                self.tableMediaList.reloadData()
                
                for objectList in self.mediaList {
                    
                    self.queue.addOperationWithBlock({
                        
                        let configuration: NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()
                        
                        let manager: AFURLSessionManager = AFURLSessionManager(sessionConfiguration: configuration)
                        
                        let URL: NSURL = NSURL(string: objectList.file)!
                        
                        let request: NSURLRequest = NSURLRequest(URL: URL, cachePolicy: .ReloadIgnoringCacheData, timeoutInterval: 240)
                        
                        /*manager.setDownloadTaskDidWriteDataBlock({ (session : NSURLSession, downloadTask :NSURLSessionDownloadTask, bytesWritten : Int64, totalBytesWritten : Int64, totalBytesExpectedToWrite : Int64) in
                        
                            let written: Int64 = bytesWritten
                            let total: Int64 = totalBytesExpectedToWrite
                            
                            let percentageCompleted: CGFloat = CGFloat(written / total)
                            
                            debugPrint(percentageCompleted)
                       })*/

                        
                        let downloadTask: NSURLSessionDownloadTask = manager.downloadTaskWithRequest(request, progress: { (progress : NSProgress) in
                            
                                debugPrint(Double(progress.completedUnitCount / progress.totalUnitCount))
                            
                            }, destination: {(targetPath: NSURL, response: NSURLResponse) -> NSURL in
                            
                            var documentsDirectoryURL : NSURL!
                           
                            do {
                                documentsDirectoryURL = try NSFileManager.defaultManager().URLForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomain: NSSearchPathDomainMask.UserDomainMask, appropriateForURL: nil, create: false)
                                
                            } catch let error {
                                debugPrint(error)
                            }
                            
                            return documentsDirectoryURL.URLByAppendingPathComponent(response.suggestedFilename!)
                            }, completionHandler: {(response: NSURLResponse?, filePath: NSURL?, error: NSError?) -> Void in
                                
                                debugPrint(filePath)
                        })
                      
                        let progressU = manager.downloadProgressForTask(downloadTask)
                        debugPrint(progressU)
                        
                        downloadTask.resume()
                    })
                }
                
            } else {
                
                debugPrint(messageModel.message)
            }
            
        }) { (dataTask : NSURLSessionDataTask?, error : NSError) in
            
            debugPrint(error)
        }
        
        dataTask?.resume()
    }
    
    //------------------------------------------------------
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //------------------------------------------------------
}
