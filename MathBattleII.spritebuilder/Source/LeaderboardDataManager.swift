//
//  LeaderboardDataManager.swift
//  MathBattleII
//
//  Created by Zachary Espiritu on 6/26/16.
//  Copyright © 2016 Zachary Espiritu. All rights reserved.
//

import Foundation

class LeaderboardDataManager {
    
    static func retrieveData() {
        let ref = FIRDatabase.database().reference().child("rankedRatings")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            print(snapshot.value)
        })
    }
}