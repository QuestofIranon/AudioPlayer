//
//  AudioPlayer+CurrentItem.swift
//  AudioPlayer
//
//  Created by Kevin DELANNOY on 29/03/16.
//  Copyright © 2016 Kevin Delannoy. All rights reserved.
//

import Foundation
import CoreMedia

public typealias TimeRange = (earliest: TimeInterval, latest: TimeInterval)

extension AudioPlayer {
    /// The current item progression or nil if no item.
    public var currentItemProgression: TimeInterval? {
        return player?.currentItem?.currentTime().ap_timeIntervalValue
    }

    /// The current item duration or nil if no item or unknown duration.
    public var currentItemDuration: TimeInterval? {
        return player?.currentItem?.duration.ap_timeIntervalValue
    }

    /// The current seekable range.
    public var currentItemSeekableRange: TimeRange? {
        if let range = player?.currentItem?.seekableTimeRanges.last?.timeRangeValue {
            let start = range.start.ap_timeIntervalValue
            let end = CMTimeRangeGetEnd(range).ap_timeIntervalValue
            
            return (start, end) as? TimeRange
        }
        if let currentItemProgression = currentItemProgression {
            // if there is no start and end point of seekable range
            // return the current time, so no seeking possible
            return (currentItemProgression, currentItemProgression)
        }
        // cannot seek at all, so return nil
        return nil
    }

    /// The current loaded range.
    public var currentItemLoadedRange: TimeRange? {
        if let range = player?.currentItem?.loadedTimeRanges.last?.timeRangeValue {
            let start = range.start.ap_timeIntervalValue
            let end = CMTimeRangeGetEnd(range).ap_timeIntervalValue
            
            return (start, end) as? TimeRange
            
        }
        return nil
    }
    
    public var currentItemLoadedAhead: TimeInterval? {
        if  let loadedRange = currentItemLoadedRange,
            let currentTime = player?.currentTime(),
                loadedRange.earliest <= currentTime.seconds {
            return loadedRange.latest - currentTime.seconds
        }
        return nil
    }
}
