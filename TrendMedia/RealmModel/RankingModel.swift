//
//  RankingModel.swift
//  TrendMedia
//
//  Created by Yundong Lee on 2021/11/02.
//

import Foundation
import RealmSwift
class LocalOnlyQsTask: Object {
    @Persisted (primaryKey: true) var rankingDate: String
    @Persisted var title: List<String>
    @Persisted var ranking: List<String>
    @Persisted var releaseDate: List<String>
    
    convenience init(rankingDate: String,title: List<String>, ranking: List<String>, releaseDate: List<String>) {
        self.init()
        self.rankingDate = rankingDate
        self.title = title
        self.ranking = ranking
        self.releaseDate = releaseDate
    }
}
