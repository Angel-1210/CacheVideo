//
//  PlayerCell.swift
//  VideoSlider
//
//  Created by Dharmesh on 11/06/16.
//  Copyright © 2016 dharmesh. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation
import AFNetworking

class PlayerCell : UICollectionViewCell, AVAssetResourceLoaderDelegate, NSURLConnectionDataDelegate {
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    var playerLayer : AVPlayerLayer!
    var player : AVPlayer!
    var persistentTime : CMTime!
    var connection : NSURLConnection!
    var currentIndexPath : NSIndexPath!
    
    var cacheData : NSMutableData!
    var manager = AFHTTPSessionManager()
    
    //MARK: Memory Management Method

    deinit { //same like dealloc in ObjectiveC
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
        if playerLayer != nil {
            playerLayer.removeFromSuperlayer()
        }
    }
    
    //------------------------------------------------------
    
    //MARK: UIView Life Cycle Method
    
    override func prepareForReuse() {
        
        player?.replaceCurrentItemWithPlayerItem(nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func setupPlayerItem( mediaInfo : MediaModel, indexPath : NSIndexPath ) {
        
        self.indicator.startAnimating()
        currentIndexPath = NSIndexPath(forRow: indexPath.row, inSection: indexPath.section)
        
        let url = NSURL(string: mediaInfo.file)
        debugPrint(url)
        
        if mediaInfo.fileType == "V" {
            
            let asset = AVURLAsset(URL: url!)
            asset.resourceLoader .setDelegate(self, queue: dispatch_get_main_queue())
            
            let playerItem = AVPlayerItem(asset:asset)
            
            player = AVPlayer(playerItem: playerItem)
            
            persistentTime = player.currentTime()
            playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = UIScreen.mainScreen().bounds
            playerView.layer.addSublayer(playerLayer)
            
            let options = NSKeyValueObservingOptions()
            playerLayer.player!.addObserver(self, forKeyPath: "status", options: options, context: nil)
            
            let fileName = asset.URL.lastPathComponent
            if fileName != nil {
                
                let cacheFilePath = NSTemporaryDirectory().stringByAppendingString(fileName!)
                
                debugPrint(cacheFilePath)
                
                if (!NSFileManager.defaultManager().fileExistsAtPath(cacheFilePath)) {
                    
                    let request: NSURLRequest = NSURLRequest(URL: url!)
                   
                    let downloadTask: NSURLSessionDownloadTask = manager.downloadTaskWithRequest(request, progress: nil, destination: {(targetPath: NSURL, response: NSURLResponse) -> NSURL in
                    
                        //var documentsDirectoryURL: NSURL = try! NSFileManager.defaultManager().URLForDirectory.UserDomainMask, appropriateForURL: nil, create: false)
                        
                        var documentsDirectoryURL : NSURL!
                        do {
                        
                            documentsDirectoryURL = try NSFileManager.defaultManager().URLForDirectory( .CachesDirectory, inDomain: .UserDomainMask, appropriateForURL: nil, create: false)
                            
                        } catch let error {
                            debugPrint(error)
                        }
                        
                        
                        return documentsDirectoryURL.URLByAppendingPathComponent(response.suggestedFilename!)
                        
                        }, completionHandler: {(response: NSURLResponse, filePath: NSURL?, error: NSError?) -> Void in
                            
                            debugPrint(response)
                            debugPrint(filePath)
                            debugPrint(error)
                            
                    })
                    downloadTask.resume()
                    
                }
                
                /*let exportSession = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
                exportSession?.outputURL = NSURL(string: cacheFilePath)
                exportSession?.outputFileType = AVFileTypeMPEG4
                exportSession?.exportAsynchronouslyWithCompletionHandler({ 
                    
                    do {
                        
                        let data = NSData.init(contentsOfFile: cacheFilePath)
                        if data != nil {
                            var writingOption = NSDataWritingOptions()
                            writingOption = .DataWritingFileProtectionNone
                            let success = try data!.writeToFile(cacheFilePath, options: writingOption)
                            debugPrint(success)
                        }
                        
                    } catch let error {
                        
                        debugPrint(error)
                    }
                })*/
            }
            
        } else {
            
        }
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        
        let player = object as! AVPlayer
                
        if keyPath! == "status" {
            
            if player.status == AVPlayerStatus.ReadyToPlay {
                self.indicator.stopAnimating()
                player.play()
            } else {
                self.indicator.startAnimating()
            }
        }
    }
    
    //------------------------------------------------------
    
    //MARK: AVAssetResourceLoaderDelegate
    
    func resourceLoader(resourceLoader: AVAssetResourceLoader, shouldWaitForLoadingOfRequestedResource loadingRequest: AVAssetResourceLoadingRequest) -> Bool {
        
        if connection == nil {
            
            let interceptedURL = loadingRequest.request.URL
            let component = NSURLComponents(URL: interceptedURL!, resolvingAgainstBaseURL: true)
            component?.scheme = "http"
            
            let request = NSURLRequest(URL: (component?.URL)!)
            connection = NSURLConnection(request: request, delegate: self, startImmediately: false)
            connection.setDelegateQueue(NSOperationQueue.mainQueue())
            connection .start()
            
        }
        
        return true
    }
    
    func resourceLoader(resourceLoader: AVAssetResourceLoader, didCancelLoadingRequest loadingRequest: AVAssetResourceLoadingRequest) {
        
    }
        
    //------------------------------------------------------
    
    //MARK: NSURLConnectionDelegate
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        
        cacheData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        cacheData .appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        
        let fileName = String(currentIndexPath.section).stringByAppendingString(String(currentIndexPath.row)).stringByAppendingString(".MP4")
        let cacheFilePath = NSTemporaryDirectory().stringByAppendingString(fileName)
        
        debugPrint(fileName)
        
        cacheData.writeToFile(cacheFilePath, atomically: true)
    }
}
