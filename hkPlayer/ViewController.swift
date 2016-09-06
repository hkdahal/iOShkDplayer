//
//  ViewController.swift
//  hkPlayer
//
//  Created by Hari Dahal on 9/3/16.
//  Copyright © 2016 Hari Dahal. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var playlists = [String]()

    @IBOutlet weak var theTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //loadFromUrl()
        //loadFromHTMLString()
        playlists = ["Hindi", "Cool Songs", "Best Songs", "Bipul Chhetri"]
        
    }
    
    
    func loadFromUrl() -> NSURLRequest{
        let url = NSURL(string: "http://hkplayer.herokuapp.com/pk-player")
        let requestObj = NSURLRequest(URL: url!)
        return requestObj
        //myWeb.loadRequest(requestObj)
    }
    
    
    func loadFromHTMLString() -> String{
        let myHTMLString:String! = " <audio controls> <source src=\"http://link.songspk.guru/link1/song1.php?songid=8217\" type=\"audio/mp3\"> </audio> "
        return myHTMLString
        //myWeb.loadHTMLString(myHTMLString, baseURL: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        cell.textLabel?.text = playlists[indexPath.row]
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("toPlayer", sender: theTable)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toPlayer"{
            let VC = segue.destinationViewController as! MyOwnController
            let indexPath: NSIndexPath = theTable.indexPathForSelectedRow!
            VC.title = playlists[indexPath.row]
            //let path = NSBundle.mainBundle().pathForResource("Bistarai", ofType:"mp3")!
            //let url = NSURL(fileURLWithPath: path)
        }
    }
    

}

