//
//  PhotoModel.swift
//  latvalley
//
//  Created by Nhat Le on 9/3/25.
//

import Vapor

final class PhotoModel: Content {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
