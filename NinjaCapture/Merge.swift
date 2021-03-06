//
//  Merge.swift
//  NinjaCapture
//
//  Created by Igor Yunash on 18.01.18.
//  Copyright © 2018 Igralino. All rights reserved.
//

import Cocoa
import AVFoundation
import os.log

class Merge: NSObject {
    
    var url_list: [URL]!
    var save_url : URL!
    
    override init() {
        super.init()
    }
    
    func merge(){
        let composition = AVMutableComposition()
        let track = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID:Int32(kCMPersistentTrackID_Invalid))
        
        let sourveVideos = self.url_list
        for (index, currentVideoObject) in (sourveVideos?.enumerated())!{
            
            let videoAsset = AVAsset(url: currentVideoObject) as AVAsset
            do{
                if index == 0 {
                    try track?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), of: videoAsset.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack, at: kCMTimeZero)
                } else {
                    try track?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), of: videoAsset.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack, at: composition.duration)
                }
            }
            catch{
                os_log (error as! StaticString, type: .error)
            }
            
        }
        
        let folder = save_url.appendingPathComponent("Done")
        
        let videoURLToSave = folder.appendingPathComponent("mergeVideo-\(arc4random()%1000)-d.mov")
        do{
            try FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        }
        catch{
            os_log (error as! StaticString, type: .error)
        }
        let exporter = AVAssetExportSession(asset: composition, presetName: AVAssetExportPresetHighestQuality)
        exporter?.outputURL = videoURLToSave
        exporter?.outputFileType = AVFileType.mov
        exporter?.shouldOptimizeForNetworkUse = true
        
        let group = DispatchGroup()
        group.enter()
        
        exporter?.exportAsynchronously(completionHandler: {
            group.leave()
        })
        
        group.notify(queue: DispatchQueue.main, execute: {
            os_log("Video merging successfully finished!", type: .debug)
        })
    }
    
    //    func countFiles() -> [URL]?{
    //        let folder = FileManager.default.urls(for: .desktopDirectory, in: .userDomainMask)[0].appendingPathComponent("/Videos")
    //
    //        do{
    //            let files = try FileManager.default.contentsOfDirectory(at: folder, includingPropertiesForKeys: nil, options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles)
    //            return files
    //        }
    //        catch {
    //            os_log(error as! StaticString, type: .error)
    //            return nil
    //        }
    //    }
}
