//
//  DetailViewController.swift
//  StartupAgenda
//
//  Created by Mark Cornelisse on 07/08/15.
//  Copyright (c) 2015 Over de muur producties. All rights reserved.
//

import UIKit
import EventKit

import StartUpAgendaInterface

class DetailViewController: UITableViewController, ButtonPressed {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    var detailItem: Meeting? {
        didSet {
            // Update the view.
            self.tableView.reloadData()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Meeting = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail.title
            }
        }
    }
    
    private func addToCalendarBitch() {
        let eventStore = EKEventStore()
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: { (success, accessError) -> Void in
            if accessError != nil {
                print("Calendar Access Error: \(accessError)")
                return
            }
            let event = EKEvent(eventStore: eventStore)
            
            event.title = self.detailItem!.title
            if self.detailItem!.beginTime != nil {
                event.startDate = self.detailItem!.beginTime!
            } else {
                event.startDate = self.detailItem!.date
            }
            if self.detailItem!.endTime != nil {
                event.endDate = self.detailItem!.endTime!
            } else {
                event.endDate = self.detailItem!.date
            }
            if event.startDate == event.endDate {
                event.allDay = true
            } else {
                event.allDay = false
            }
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.saveEvent(event, span: EKSpan.ThisEvent, commit: true)
                print("Added to calendar sir")
                
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    let title = "Success"
                    let message = "\(self.detailItem!.title) added to default calender"
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: { () -> Void in
                        print("Mission Accomplished")
                    })
                })
            } catch {
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    let title = "Error Saving"
                    let message = "Unable to add to calendar"
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                    let cancelAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Cancel, handler: nil)
                    alertController.addAction(cancelAction)
                    self.presentViewController(alertController, animated: true, completion: { () -> Void in
                        print("Just experessing how I feel.")
                    })
                })
            }
        })
    }
    
    // MARK: Inherited from super.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 200
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Button Pressed
    func buttonPressed() {
        print("Add to calendar bitch")
        addToCalendarBitch()
    }

    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch (indexPath.row) {
        case 0:
            let titleCell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as! TitleCell
            titleCell.eventTitleLabel.text = detailItem!.title
            return titleCell
        case 1:
            let descriptionCell = tableView.dequeueReusableCellWithIdentifier("DescriptionCell", forIndexPath: indexPath) as! DescriptionCell
            var dateString = detailItem!.date.formattedLongString
            if detailItem!.beginTime != nil {
                dateString += "\n"
                dateString += detailItem!.beginTime!.formattedTimeString
            }
            if detailItem!.endTime != nil {
                dateString += " - "
                dateString += detailItem!.endTime!.formattedTimeString
            }
            descriptionCell.dateLabel.text = dateString
            descriptionCell.dateLabel.invalidateIntrinsicContentSize()
            descriptionCell.eventDescriptionLabel.text = detailItem!.descriptionBody
            return descriptionCell
        case 2:
            let addToCalendarButtonCell = tableView.dequeueReusableCellWithIdentifier("AddToCalendarButtonCell", forIndexPath: indexPath) as! AddToCalendarButtonCell
            addToCalendarButtonCell.delegate = self
            return addToCalendarButtonCell
        default:
            return UITableViewCell()
        }
    }
}

