//
//  Meeting.swift
//  StartUpAgendaInterface
//
//  Created by Mark Cornelisse on 11/08/15.
//  Copyright (c) 2015 Over de muur producties. All rights reserved.
//

import Foundation

public struct Meeting: CustomStringConvertible, Equatable {
    public let title: String
    public let address: String
    public let date: NSDate
    public let beginTime: NSDate?
    public let endTime: NSDate?
    public let link: NSURL
    public let descriptionBody: String
    
    // MARK: Printable
    public var description: String {
        return "title: \(title), date: \(date)\n"
    }
}

// MARK: Equatable

public func ==(a: Meeting, b: Meeting) -> Bool {
    return (a.title == b.title) && (a.date == b.date)
}