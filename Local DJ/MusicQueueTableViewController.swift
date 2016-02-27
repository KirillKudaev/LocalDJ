//
//  MusicQueueTableViewController.swift
//  Local DJ
//
//  Created by Kirill Kudaev, Jami Wissman on 1/26/16.
//  Copyright © 2016 Kirill Kudaev, Jami Wissman. All rights reserved.
//

import UIKit

class MusicQueueTableViewController: UITableViewController,  SPTAudioStreamingPlaybackDelegate {
    
    let clientID = "6be42602926140ffbedb14f2d2f4029b"
    
    
    var songQueue: Array<AnyObject> = []
    var songNumber:UInt!
    var session = globalSession
    var player:SPTAudioStreamingController!
    var featuredPlaylists:SPTFeaturedPlaylistList!
    
    let playlistURI = NSURL(string: "spotify:user:spotify:playlist:4hOKQuZbraPDIfaGbM3lKI")
    

    @IBAction func playSongButton(sender: AnyObject) {
        playUsingSession(session)
    }

    @IBAction func nextSongButton(sender: AnyObject) {
        playNext()
    }
   
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //self.view.backgroundColor = UIColor.blackColor()
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 101
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cellID:NSString = "PlayCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID as String, forIndexPath: indexPath) as! PlayMusicTableViewCell
            return cell
        }
        else{
            let cellID:NSString = "SongCell"
            let cell = tableView.dequeueReusableCellWithIdentifier(cellID as String, forIndexPath: indexPath) as! SongTableViewCell
            SPTRequest.requestItemAtURI(self.playlistURI, withSession: session, callback: { (error:NSError!, playlistObj:AnyObject!) -> Void in
                let playlist = playlistObj as! SPTPlaylistSnapshot
                self.songQueue = playlist.firstTrackPage.items
                
                cell.songTitleLabel.text = self.songQueue[indexPath.row - 1].name
                var artistsArray:Array<AnyObject> = self.songQueue[indexPath.row - 1].artists
                cell.songArtistLabel.text = artistsArray[0].name
                
                let album:SPTPartialAlbum = self.songQueue[indexPath.row - 1].album
                let albumArt:SPTImage = album.smallestCover
                
                if let url = albumArt.imageURL {
                    if let data = NSData(contentsOfURL: url) {
                        cell.songAlbumCoverImageView.image = UIImage(data: data)
                    }        
                }
                
            })
            
            cell.upButton.tag = indexPath.row
            cell.downButton.tag = indexPath.row
            
            cell.upButton.addTarget(self, action: "upVote:", forControlEvents: .TouchUpInside)
            
            //To deselect the opposite button (doesn't work yet)
            //cell.upButton.addTarget(cell.downButton, action: "upVoteOppositeButton:", forControlEvents: .TouchUpInside)
            
            cell.downButton.addTarget(self, action: "downVote:", forControlEvents: .TouchUpInside)
            
            //To deselect the opposite button (doesn't work yet)
            //cell.downButton.addTarget(cell.upButton, action: "downVoteOppositeButton:", forControlEvents: .TouchUpInside)
            
            return cell
        }
    }
    
    
    func playUsingSession(sessionObj:SPTSession!){
        if player == nil {
            player = SPTAudioStreamingController(clientId: clientID)
        }
        
        player?.loginWithSession(sessionObj, callback: { (error:NSError!) -> Void in
            if error != nil {
                print("Enabling playback error \(error)")
                return
            }
            
            SPTRequest.requestItemAtURI(self.playlistURI, withSession: sessionObj, callback: { (error:NSError!, playlistObj:AnyObject!) -> Void in
                let playlist = playlistObj as! SPTPlaylistSnapshot
                
                self.songQueue = playlist.firstTrackPage.items
                
                for track:SPTPlaylistTrack in self.songQueue as! [SPTPlaylistTrack]{
                    self.player.queueURI(track.playableUri, clearQueue: false, callback: { (error:NSError!) -> Void in
                        if (error != nil){
                            print("Error queueing playlist \(error)")
                            return
                        }
                    })
                }
                
            
                self.player.queuePlay({ (error:NSError!) -> Void in
                    if(error != nil){
                        print("Error playing queue \(error)")
                        return
                    }
                })
                
            })

        })
    }
    
    func playNext(){
        if player == nil {
            player = SPTAudioStreamingController(clientId: clientID)
        }
        self.player.skipNext { (error:NSError!) -> Void in
            if (error != nil){
                print("Error playing next song \(error)")
                return
            }
        }
    }
    
    @IBAction func upVote(sender: UIButton){
        // no more error but still doesn't work :(
        let temp = songQueue[sender.tag - 1]
        songQueue[sender.tag - 1] = songQueue[sender.tag]
        songQueue[sender.tag] = temp
        self.tableView.reloadData()
        
        if sender.titleColorForState(UIControlState.Normal)!.isEqual(UIColor.greenColor()) {
            sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        } else {
            sender.setTitleColor(UIColor.greenColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func downVote(sender: UIButton){
        
        if sender.titleColorForState(UIControlState.Normal)!.isEqual(UIColor.redColor()) {
            sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        } else {
            sender.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func upVoteOppositeButton(sender: UIButton){
        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    @IBAction func downVoteOppositeButton(sender: UIButton){
        sender.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }
    
    
    func audioStreaming(audioStreaming: SPTAudioStreamingController!, didStartPlayingTrack trackUri: NSURL!) {
        //code for when track starts playing
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
