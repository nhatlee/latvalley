//
//  File.swift
//  latvalley
//
//  Created by Nhat Le Tien on 21/1/25.
//

import Foundation
import Fluent
import FluentPostgresDriver

struct CreateUser: Migration {
    func prepare(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(Constaints.DB.userSchema)
            .id()
            .field("name", .string)
            .field("password", .string)
            .field("email", .string)
            .create()
    }
    
    func revert(on database: any Database) -> EventLoopFuture<Void> {
        database.schema(Constaints.DB.userSchema).delete()
    }
}
