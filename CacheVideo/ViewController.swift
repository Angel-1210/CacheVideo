//
//  ViewController.swift
//  CacheVideo
//
//  Created by Dharmesh on 25/07/16.
//  Copyright © 2016 dharmesh. All rights reserved.
//

import UIKit
import Foundation
import AFNetworking

class ViewController : UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, GIDSignInUIDelegate {
    
    @IBOutlet weak var signInButton: GIDSignInButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var mediaList : [MediaModel]! = []
    
    //MARK: Memory Management Method
    
    override func didReceiveMemoryWarning() {
        
    }
    
    //------------------------------------------------------
    
    deinit { //same like dealloc in ObjectiveC
        
    }
    
    //------------------------------------------------------
    
    //MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    func collectionView(collectionView: UICollectionView,   numberOfItemsInSection section: Int) -> Int {
        return mediaList.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PlayerCell", forIndexPath: indexPath) as! PlayerCell
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen .mainScreen().scale
        
        let mediaInfo = mediaList[indexPath.row]
        cell.setupPlayerItem(mediaInfo, indexPath: indexPath)
        
        return cell
    }
    
    //------------------------------------------------------
    @IBAction func signInTapped(sender: AnyObject) {
        
        GIDSignIn.sharedInstance().signIn()
    }
    
    //MARK: Google Sign In
    
    // pressed the Sign In button
    func signInWillDispatch(signIn: GIDSignIn!, error: NSError!) {
        
    }
    
    // Present a view that prompts the user to sign in with Google
    func signIn(signIn: GIDSignIn!,
                presentViewController viewController: UIViewController!) {
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func signIn(signIn: GIDSignIn!,
                dismissViewController viewController: UIViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //------------------------------------------------------
    
    //MARK: UIView Life Cycle Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        GIDSignIn.sharedInstance().uiDelegate = self
        

        let manager = AFHTTPSessionManager()
        let reachability = AFNetworkReachabilityManager()
        
        //request
        manager.requestSerializer.cachePolicy = .ReturnCacheDataElseLoad
        
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
                self.collectionView.reloadData()
                
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

