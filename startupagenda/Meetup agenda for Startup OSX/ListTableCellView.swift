//
//  PeerTableCellView.swift
//  MultiPeerCoffeeRoom
//
//  Created by Mark Cornelisse on 30/06/15.
//  Copyright (c) 2015 Over de muur producties. All rights reserved.
//

import Cocoa

class ListTableCellView: NSTableCellView {
    @IBOutlet var nameLabel: NSTextField!
    
    var stringValue: String {
        get {
            return nameLabel.stringValue
        }
        set {
            nameLabel.stringValue = newValue
        }
    }
}
