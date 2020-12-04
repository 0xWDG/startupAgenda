//
//  StartUpAgendaController.swift
//  StartUpAgendaInterface
//
//  Created by Mark Cornelisse on 13/07/15.
//  Copyright (c) 2015 Over de muur producties. All rights reserved.
//

import Foundation

public let kStartUpAgendaControllerDomain = "kStartUpAgendaControllerDomain"
public let kStartUpAgendaControllerDomainErrorReason = "reason"
public let kStartUpAgendaControllerDomainErrorResponse = "response"

public class StartUpAgendaController {
    // MARK: Singleton
    public static let sharedInstance = StartUpAgendaController()
    
    // MARK: Properties
    public private(set) var meetings: [Meeting] = [Meeting]()
    
    // MARK: New in this class
    public func fetchMeetings(completion: (error: NSError?) -> ()) {
        let url = NSURL(string: "http://api.the-app-team.com/StartUp")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {data, response, error in
            if error != nil {
                print("Error fetching StartUp Meetup data: \(error)")
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completion(error: error)
                })
                return
            }
            
            let httpResp = response as! NSHTTPURLResponse
            if httpResp.statusCode == 200 {
                do {
                    let jsonResponseDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! Dictionary<String, AnyObject>
                    let fetchedMeetings = self.convertJSONDictionaryToMeetings(jsonResponseDictionary)
                    let tenHoursAgo = NSDate(timeInterval: -36000, sinceDate: NSDate())
                    var filteredMeetings = fetchedMeetings.filter({ (meeting) -> Bool in
                        if meeting.beginTime != nil {
                            return meeting.beginTime > tenHoursAgo
                        } else {
                            return meeting.date > tenHoursAgo
                        }
                        
                    })
                    filteredMeetings.sortInPlace({
                        return $0.date < $1.date
                    })
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        self.meetings = filteredMeetings
                        completion(error: nil)
                    })
                } catch {
                    // JSON Error
                    print("Error converting to StartUp data to JSON")
                    let jsonError = NSError(domain: "JSON", code: 0, userInfo: ["info": "JSON Conversion not possible"])
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        completion(error: jsonError)
                    })
                }
            } else {
                // Status code != 200
                print("Bad http response.")
                let httpError = NSError(domain: kStartUpAgendaControllerDomain, code: 2, userInfo: [kStartUpAgendaControllerDomainErrorReason: "HTTP Response code: \(httpResp.statusCode)", kStartUpAgendaControllerDomainErrorResponse: httpResp])
                NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                    completion(error: httpError)
                })
            }
        }
        task.resume()
    }
    
    func convertJSONDictionaryToMeetings(jsonDictionary: Dictionary<String, AnyObject>) -> [Meeting] {
        func stringToDate(dateString: String?) -> NSDate? {
            if dateString == nil {
                return nil
            }
            let df = NSDateFormatter()
            df.locale = NSLocale(localeIdentifier: "nl")
            df.dateStyle = NSDateFormatterStyle.ShortStyle
            df.timeStyle = NSDateFormatterStyle.NoStyle
            return df.dateFromString(dateString!)
        }
        
        func convertTimeStampToDate(timeInterval: NSTimeInterval?) -> NSDate? {
            if timeInterval == nil {
                return nil
            } else {
                return NSDate(timeIntervalSince1970: timeInterval!)
            }
        }
        
        var arrayOfMeeting = [Meeting]()
        for key in jsonDictionary.keys {
            let meetingDictionary = jsonDictionary[key]
            let title = meetingDictionary?["title"] as? String
            let date = stringToDate(meetingDictionary?["date"] as? String)
            let beginDate = convertTimeStampToDate((meetingDictionary?["begin"] as? Double))
            let endDate = convertTimeStampToDate((meetingDictionary?["end"] as? Double))
            let address = meetingDictionary?["address"] as? String
            let link = meetingDictionary?["link"] as? String
            let description = meetingDictionary?["description"] as? String
            let newMeeting = Meeting(title: title!, address: address!, date: date!, beginTime: beginDate, endTime: endDate, link: NSURL(string: link!)!, descriptionBody: description!)
            arrayOfMeeting.append(newMeeting)
        }
        return arrayOfMeeting
    }
}