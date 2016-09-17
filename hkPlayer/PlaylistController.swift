//
//  PlaylistController.swift
//  hkPlayer
//
//  Created by Hari Dahal on 9/6/16.
//  Copyright © 2016 Hari Dahal. All rights reserved.
//

import UIKit
import AVFoundation

class PlaylistController: MyOwnController, UITableViewDelegate, UITableViewDataSource {
    
    var playlists = [Playlist]()
    
    @IBOutlet weak var theTable: UITableView!
    
    // GENERAL STUFFS ***
    override func viewDidLoad() {
        super.viewDidLoad()
        playlists = (self.myCategory?.playlists!)!
        //playlists = ["Hindi", "Cool Songs", "Best Songs", "Bipul Chhetri"]
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // TABLE STUFFS ***
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = playlists[(indexPath as NSIndexPath).row].name
        cell.accessoryType = UITableViewCellAccessoryType.disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "playlistToPlayer", sender: theTable)
    }
    
    // SEGUE STUFFS ***
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "playlistToPlayer"{
            let VC = segue.destination as! MyOwnController
            let indexPath: IndexPath = theTable.indexPathForSelectedRow!
            VC.title = playlists[(indexPath as NSIndexPath).row].name
            VC.myPlaylist = playlists[(indexPath as NSIndexPath).row]
        }
    }
    

}
