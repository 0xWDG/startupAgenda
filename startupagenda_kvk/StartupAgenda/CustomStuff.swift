//
//  NSDateExtension.swift
//  StartUpAgendaInterface
//
//  Created by Mark Cornelisse on 07/08/15.
//  Copyright (c) 2015 Over de muur producties. All rights reserved.
//

import UIKit

extension NSDate {
    public var formattedString: String {
        let nf = NSDateFormatter()
        nf.dateStyle = NSDateFormatterStyle.MediumStyle
        nf.timeStyle = NSDateFormatterStyle.NoStyle
        return nf.stringFromDate(self)
    }
    
    public var formattedLongString: String {
        let nf = NSDateFormatter()
        nf.dateStyle = NSDateFormatterStyle.FullStyle
        nf.timeStyle = NSDateFormatterStyle.NoStyle
        return nf.stringFromDate(self)
    }
    
    public var formattedTimeString: String {
        let nf = NSDateFormatter()
        nf.dateStyle = NSDateFormatterStyle.NoStyle
        nf.timeStyle = NSDateFormatterStyle.ShortStyle
        return nf.stringFromDate(self)
    }
}