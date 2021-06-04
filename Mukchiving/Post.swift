//
//  Post.swift
//  Mukchiving
//
//  Created by 임수정 on 2021/05/19.
//

import Foundation

struct Post: Codable {
//    let post_id: String
//    let user_id: String
    let title: String
    let memo: String
//    let imgs: UIImage
    let location: String
    let score: Float
    let created_at: Date // or String
}
