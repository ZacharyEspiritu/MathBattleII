//
//  LeaderboardDataView.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/25/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LeaderboardDataView: CCNode {
    
    weak var rankedButton, practiceButton, overallButton: CCButton!
    weak var background: CCSprite9Slice!
    weak var leaderboardGroupingNode: Clipper!
    weak var scrollView: CCScrollView!
    
    var rankedLeaderboardContent: CCNode!
    var practiceLeaderboardContent: CCNode!
    var overallLeaderboardContent: CCNode!
    
    var currentLeaderboardView: LeaderboardView!
    
    
    func didLoadFromCCB() {
        let placeholderScrollViewContent = CCBReader.load("LeaderboardScrollViewPlaceholder")
        placeholderScrollViewContent.contentSize = scrollView.contentSizeInPoints
        scrollView.contentNode = placeholderScrollViewContent
        toggleLeaderboard(newView: .Ranked)
    }
    
    // MARK: Button Functions
    
    func rankedButtonPressed() {
        toggleLeaderboard(newView: .Ranked)
    }
    
    func practiceButtonPressed() {
        toggleLeaderboard(newView: .Practice)
    }
    
    func overallButtonPressed() {
        toggleLeaderboard(newView: .Overall)
    }
    
    // MARK: Data Functions
    
    private func toggleLeaderboard(newView view: LeaderboardView) {
        if currentLeaderboardView != view {
            currentLeaderboardView = view
            
            rankedButton.selected = false
            practiceButton.selected = false
            overallButton.selected = false
            switch view {
            case .Ranked:
                rankedButton.selected = true
            case .Practice:
                practiceButton.selected = true
            case .Overall:
                overallButton.selected = true
            }
            
            loadLeaderboardContentNode(forView: view)
        }
    }
    
    private func loadLeaderboardContentNode(forView view: LeaderboardView) {
        retrieveLeaderboardDataFromFirebase()
    }
    
    private func loadRankedLeaderboardContent(data leaderboardData: ([String], [String : Int])) {
        let scrollViewContent = CCNode()
        scrollViewContent.contentSize.width = 271
        
        let orderedPlayers: [String] = leaderboardData.0
        let rankingDictionary: [String : Int]  = leaderboardData.1
        
        for index in 0..<orderedPlayers.count {
            let cell = CCBReader.load("LeaderboardScrollViewCell") as! LeaderboardScrollViewCell
            cell.positionType = CCPositionType(xUnit: CCPositionUnit.Normalized, yUnit: CCPositionUnit.Points, corner: CCPositionReferenceCorner.TopLeft)
            cell.position = CGPoint(x: 0.5, y: CGFloat(index) * cell.contentSize.height)
            cell.setData(ranking: index + 1, username: orderedPlayers[index], rating: rankingDictionary[orderedPlayers[index]]!)
            
            scrollViewContent.contentSize.height += cell.contentSize.height
            scrollViewContent.addChild(cell)
        }
        
        scrollView.contentNode = scrollViewContent
    }
    
    private func retrieveLeaderboardDataFromFirebase() {
        var orderedPlayers: [String] = []
        var rankingDictionary: [String : Int] = [:]
        // Access data from Firebase and sort the players by rating
        let ref = FIRDatabase.database().reference().child("rankedRatings")
        ref.queryOrderedByValue().observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value as? [String : Int] {
                print(data)
                orderedPlayers = data.keysSortedByValue(>)
                rankingDictionary = data
                self.loadRankedLeaderboardContent(data: (orderedPlayers, rankingDictionary))
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
}

extension Dictionary {
    // Faster because of no lookups, may take more memory because of duplicating contents
    func keysSortedByValue(isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
        return Array(self)
            .sort() {
                let (_, lv) = $0
                let (_, rv) = $1
                return isOrderedBefore(lv, rv)
            }
            .map {
                let (k, _) = $0
                return k
        }
    }
}

enum LeaderboardView {
    case Ranked
    case Practice
    case Overall
}