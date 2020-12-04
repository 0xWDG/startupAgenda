//
//  PeerViewController.swift
//  MultiPeerCoffeeRoom
//
//  Created by Mark Cornelisse on 30/06/15.
//  Copyright (c) 2015 Over de muur producties. All rights reserved.
//

import Cocoa
import StartUpAgendaInterfaceOSX

let kRowSelected = "kRowSelected"
let kRow = "row"

class ListViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    // MARK: Properties
    var agendaController = StartUpAgendaController.sharedInstance
    
    // MARK: Outlets
    @IBOutlet weak var tableView: NSTableView!
    
    // MARK: Inherited from super
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.presentingViewController
        
        agendaController.fetchMeetings { (error) -> () in
            self.tableView.reloadData()
        }
    }
    
    // MARK: NS Table View Data Source
    
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return agendaController.meetings.count
    }
    
    // MARK: NS Table View Delegate
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let meeting = agendaController.meetings[row]
        let currentTableCellView = tableView.makeViewWithIdentifier("ListTableCellView", owner: nil) as! ListTableCellView
        currentTableCellView.stringValue = meeting.title
        
        return currentTableCellView
    }
    
    func tableView(tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 50.0
    }
    
    // MARK: Notifications
    
    func tableViewSelectionDidChange(notification: NSNotification) {
        NSNotificationCenter.defaultCenter().postNotificationName(kRowSelected, object: self, userInfo: [kRow : NSNumber(integer: self.tableView.selectedRow)])
    }
}