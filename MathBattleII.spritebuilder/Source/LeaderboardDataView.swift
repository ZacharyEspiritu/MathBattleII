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
    weak var dataLabel: CCLabelTTF!
    
    var rankedLeaderboardContent: CCNode!
    var practiceLeaderboardContent: CCNode!
    var overallLeaderboardContent: CCNode!
    
    var currentLeaderboardView: LeaderboardView!
    
    
    func didLoadFromCCB() {
        loadPlaceholderIntoScrollView()
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
    
    private func loadPlaceholderIntoScrollView() {
        let placeholderScrollViewContent = CCBReader.load("LeaderboardScrollViewPlaceholder")
        placeholderScrollViewContent.contentSize = scrollView.contentSizeInPoints
        scrollView.contentNode = placeholderScrollViewContent
    }
    
    private func toggleLeaderboard(newView view: LeaderboardView) {
        if currentLeaderboardView != view {
            currentLeaderboardView = view
            
            rankedButton.selected = false
            practiceButton.selected = false
            overallButton.selected = false
            
            switch view {
            case .Ranked:
                setDataLabel(withString: "Rating")
                rankedButton.selected = true
            case .Practice:
                setDataLabel(withString: "Solves")
                practiceButton.selected = true
            case .Overall:
                setDataLabel(withString: "Exp")
                overallButton.selected = true
            }
            
            loadPlaceholderIntoScrollView()
            retrieveLeaderboardDataFromFirebase(forView: view)
        }
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
        scrollViewContent.contentSize.height += 5
        scrollView.contentNode = scrollViewContent
    }
    
    private func retrieveLeaderboardDataFromFirebase(forView view: LeaderboardView) {
        var orderedPlayers: [String] = []
        var rankingDictionary: [String : Int] = [:]
        
        let ref = FIRDatabase.database().reference().child(view.rawValue)
        ref.queryOrderedByValue().observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value as? [String : Int] {
                orderedPlayers = data.keysSortedByValue(>)
                rankingDictionary = data
                self.loadRankedLeaderboardContent(data: (orderedPlayers, rankingDictionary))
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    private func setDataLabel(withString string: String) {
        dataLabel.string = string
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

enum LeaderboardView: String {
    case Ranked = "leaderboards/ranked"
    case Practice = "leaderboards/practice"
    case Overall = "leaderboards/overall"
}