//
//  UserModel.swift
//  latvalley
//
//  Created by Nhat Le Tien on 17/1/25.
//

import Vapor
import FluentKit

struct Constaints {
    struct DB {
        static let userSchema = "users"
    }
}

final class UserModel: Model, Content, Equatable {
    static func == (lhs: UserModel, rhs: UserModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.name == rhs.name &&
        lhs.email == rhs.email &&
        lhs.password == rhs.password
    }
    /// Name of the table or collection
    static var schema = Constaints.DB.userSchema
    
    /// Unique identifier for this user
    @ID(key: .id)
    var id: UUID?
    
    // The user name
    @Field(key: "name")
    var name: String
    
    // The user password
    @Field(key: "password")
    var password: String
    
    @Field(key: "email")
    var email: String
    
    @Field(key: "user_token")
    var token: String?
    
    init() {}
    
    init(
        id: UUID? = UUID(),
        name: String,
        password: String,
        email: String,
        token: String? = nil
    ) {
        self.id = id
        self.name = name
        self.password = password
        self.email = email
        self.token = token
    }
    
    
    func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
        let data = try JSONEncoder().encode(self)
        return Response.init(status: .ok, body: .init(data: data))
    }
}

extension UserModel: Validatable {
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
    }
}
