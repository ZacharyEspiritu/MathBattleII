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
        toggleLeaderboard(newView: .Ranked)
        retrieveLeaderboardDataFromFirebase()
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
        scrollView.contentNode = loadRankedLeaderboardContent()
    }
    
    private func loadRankedLeaderboardContent() -> CCNode {
        let leaderboardScrollViewContent = CCNode()
        leaderboardScrollViewContent.contentSize.width = 271
        
        for index in 0..<10 {
            let leaderboardScrollViewCell = CCBReader.load("LeaderboardScrollViewCell") as! LeaderboardScrollViewCell
            leaderboardScrollViewCell.setData(ranking: index, username: "test", rating: 1000)
            leaderboardScrollViewContent.contentSize.height += leaderboardScrollViewCell.contentSize.height
            leaderboardScrollViewCell.positionType = CCPositionType(xUnit: CCPositionUnit.Normalized, yUnit: CCPositionUnit.Points, corner: CCPositionReferenceCorner.TopLeft)
            leaderboardScrollViewCell.position = CGPoint(x: 0.5, y: CGFloat(index) * leaderboardScrollViewCell.contentSize.height)
            leaderboardScrollViewContent.addChild(leaderboardScrollViewCell)
        }
        
        return leaderboardScrollViewContent
    }
    
    private func retrieveLeaderboardDataFromFirebase() {
        // Access data from Firebase and sort the players by rating
        let ref = FIRDatabase.database().reference().child("users")
        print("test")
        ref.queryOrderedByChild("rating").queryLimitedToFirst(30).observeEventType(.Value, withBlock: { snapshot in
            let playerData = snapshot.value as! NSDictionary
            let rating = playerData.objectForKey("rating")
            print(playerData)
        })
    }
}

enum LeaderboardView {
    case Ranked
    case Practice
    case Overall
}