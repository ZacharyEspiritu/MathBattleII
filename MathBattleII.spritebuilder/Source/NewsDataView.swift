//
//  NewsDataView.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/25/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class NewsDataView: CCNode {
    
    weak var scrollViewGroupingNode: CCNode!
    var scrollView: CCScrollView!
    
    func didLoadFromCCB() {
        scrollView = CCScrollView(contentNode: CCNode())
        scrollView.contentSizeType = CCSizeType(widthUnit: CCSizeUnit.Normalized, heightUnit: CCSizeUnit.Normalized)
        scrollView.contentSize = CGSize(width: 1, height: 1)
        scrollView.horizontalScrollEnabled = false
        scrollViewGroupingNode.addChild(scrollView)
        
        retrieveNewsDataFromFirebase()
    }
    
    // MARK: Data Functions
    
    private func retrieveNewsDataFromFirebase() {
        let ref = FIRDatabase.database().reference().child("news")
        ref.queryOrderedByKey().observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let data = snapshot.value as? [String : NSDictionary] {
                var sortedKeys: [Int] = []
                for key in data.keys {
                    sortedKeys.append(Int(key)!)
                }
                sortedKeys = sortedKeys.sort(>)
                self.loadNewsData(sortedKeys: sortedKeys, newsData: data)
            }
        })
    }
    
    private func loadNewsData(sortedKeys sortedKeys: [Int], newsData: [String : NSDictionary]) {
        let scrollViewContent = CCNode()
        scrollViewContent.contentSize.width = 320
        scrollViewContent.contentSize.height = 12
        
        for index in 0..<sortedKeys.count {
            let data = newsData[String(sortedKeys[index])] as! [String : String]
            let header: String = data["header"]!
            let detail: String = data["detail"]!
            let cell = CCBReader.load("NewsScrollViewCell") as! NewsScrollViewCell
            cell.setData(pipeIndex: index, header: header, detail: detail)
            cell.contentSize.height = cell.headerLabel.contentSize.height + cell.detailLabel.contentSize.height + 39
            
            cell.positionType = CCPositionType(xUnit: CCPositionUnit.Normalized, yUnit: CCPositionUnit.Points, corner: CCPositionReferenceCorner.TopLeft)
            cell.position = CGPoint(x: 0.5, y: scrollViewContent.contentSize.height)
            
            scrollViewContent.contentSize.height += cell.contentSize.height
            scrollViewContent.addChild(cell)
        }
        scrollViewContent.contentSize.height += 22
        scrollView.contentNode = scrollViewContent
    }
}