//
//  MasterViewController.swift
//  StartupAgenda
//
//  Created by Mark Cornelisse on 07/08/15.
//  Copyright (c) 2015 Over de muur producties. All rights reserved.
//

import UIKit

import StartUpAgendaInterface

class MasterViewController: UITableViewController {
    // MARK: Properties
    var agendaController = StartUpAgendaController.sharedInstance
    
    // MARK: New in this class

    private func updateContents(completion: (()->())?) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        agendaController.fetchMeetings { (error) -> () in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if error != nil {
                print("Error fetching data from server.")
                let title = "Error connecting"
                let message = "Something went wrong connecting to the service. Please try again."
                let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
                let reloadAction = UIAlertAction(title: "Reconnect", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                    self.updateContents(nil)
                })
                alertController.addAction(reloadAction)
                self.presentViewController(alertController, animated: true, completion: { () -> Void in
                    print("Just experessing how I feel.")
                })
            }
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
            completion?()
        }
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        updateContents { () -> () in
            self.refreshControl?.endRefreshing()
        }
    }
    
    // MARK: Inherited From Super
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateContents(nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let meeting = agendaController.meetings[indexPath.row] as Meeting
            (segue.destinationViewController as! DetailViewController).detailItem = meeting
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agendaController.meetings.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! AgendaItemCell

        let meeting = agendaController.meetings[indexPath.row] as Meeting
        cell.titleLabel!.text = meeting.title
        cell.dateLabel!.text = meeting.date.formattedString
        cell.locationLabel!.text = meeting.address
        return cell
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
}

