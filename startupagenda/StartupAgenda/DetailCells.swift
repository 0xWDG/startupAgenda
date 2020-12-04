//
//  DetailCells.swift
//  StartUpAgendaInterface
//
//  Created by Mark Cornelisse on 08/08/15.
//  Copyright (c) 2015 Over de muur producties. All rights reserved.
//

import UIKit

class TitleCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet var eventTitleLabel: UILabel!
}

class DescriptionCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var eventDescriptionLabel: UILabel!
}

protocol ButtonPressed {
    func buttonPressed()
}

class AddToCalendarButtonCell: UITableViewCell {
    // MARK: IBOutlets
    @IBOutlet var addToCalendarButton: UIButton!
    
    // MARK: Properties
    var delegate: ButtonPressed?
    
    // MARK: IBActions
    
    @IBAction func addToCalendarPressed(sender: AnyObject) {
        delegate?.buttonPressed()
    }
}