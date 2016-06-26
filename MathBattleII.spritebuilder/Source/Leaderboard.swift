//
//  Leaderboard.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 4/5/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LeaderboardScene: CCNode {
    
    var unsortedPlayersWithRatings: [String : Int] = [ : ]
    var sortedPlayers: [String] = []
    
    func didLoadFromCCB() {
        retrieveLeaderboardDataFromFirebase()

        let tableView = UITableView(frame: CGRectMake(0, 0, 300, 300), style: UITableViewStyle.Plain)
        tableView.registerNib(UINib(nibName: "LeaderboardTableViewCell", bundle: nil), forCellReuseIdentifier: "leaderboardTableViewCell")
        tableView.registerClass(LeaderboardTableViewCell.self, forCellReuseIdentifier: "leaderboardTableViewCell")
        tableView.dataSource = self
        CCDirector.sharedDirector().view.addSubview(tableView)
    }
    
    private func retrieveLeaderboardDataFromFirebase() {
        // Access data from Firebase and sort the players by rating
        let ref = FIRDatabase.database().reference().child("playerRatings")
        ref.queryLimitedToFirst(100).observeSingleEventOfType(.Value, withBlock: { snapshot in
            let queryResults = snapshot.value as! [String : Int]
            self.unsortedPlayersWithRatings = queryResults
            self.sortedPlayers = (queryResults as NSDictionary).keysSortedByValueUsingSelector(#selector(NSNumber.compare(_:))) as! [String]
        })
    }
}

extension LeaderboardScene: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedPlayers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "leaderboardTableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? LeaderboardTableViewCell
        if cell == nil {
            cell = LeaderboardTableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
        let index: Int = indexPath.indexAtPosition(0)
        let player: String = sortedPlayers[index]
        let rating: Int = unsortedPlayersWithRatings[player]!
        cell!.setData(overallPlacing: index, playerName: player, ranking: rating)
        
        return cell!
    }
}