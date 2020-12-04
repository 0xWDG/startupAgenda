//
//  DetailsViewController.swift
//  StartUpAgendaInterface
//
//  Created by Mark Cornelisse on 13/07/15.
//  Copyright (c) 2015 Over de muur producties. All rights reserved.
//

import Cocoa
import StartUpAgendaInterfaceOSX

class DetailsViewController: NSViewController {
    // IBOutlets
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var descriptionLabel: NSTextField!
    @IBOutlet weak var urlLabel: NSTextField!
    @IBOutlet weak var addressLabel: NSTextField!
    
    // MARK: Properties
    let agendaController = StartUpAgendaController.sharedInstance
    weak var tableView: NSTableView!
    
    // MARK: Inherited from super.
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let empty = ""
        titleLabel.stringValue = empty
        dateLabel.stringValue = empty
        descriptionLabel.stringValue = empty
        urlLabel.stringValue = empty
        addressLabel.stringValue = empty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserverForName(kRowSelected, object: nil, queue: nil) { (notification) -> Void in
            let number = notification.userInfo![kRow] as? NSNumber
            let meeting = self.agendaController.meetings[number!.integerValue]
            // Format date to a string
            let df = NSDateFormatter()
            df.locale = NSLocale.currentLocale()
            df.dateStyle = NSDateFormatterStyle.MediumStyle
            df.timeStyle = NSDateFormatterStyle.NoStyle
            // Spit out to textFields
            self.dateLabel.stringValue = df.stringFromDate(meeting.date)
            self.titleLabel.stringValue = meeting.title
            self.descriptionLabel.stringValue = meeting.descriptionBody
            self.addressLabel.stringValue = meeting.address
            self.urlLabel.stringValue = meeting.link.absoluteString
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}