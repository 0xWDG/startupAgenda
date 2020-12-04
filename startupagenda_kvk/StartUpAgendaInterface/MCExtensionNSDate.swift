//
//  MCExtensionNSDate.swift
//  MCTools
//
//  Created by Mark Cornelisse on 26/01/15.
//  Copyright (c) 2015 Mark Cornelisse. All rights reserved.
//

import Foundation

public func <(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedAscending
}

public func ==(a: NSDate, b: NSDate) -> Bool {
    return a.compare(b) == NSComparisonResult.OrderedSame
}

extension NSDate: Comparable { }
