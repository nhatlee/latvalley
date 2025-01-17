//
//  UserModel.swift
//  latvalley
//
//  Created by Nhat Le Tien on 17/1/25.
//

import Vapor

struct UserModel: Content, Validatable {
    let id: Int
    var name: String
    var password: String
    var email: String
    
    func encodeResponse(for request: Vapor.Request) async throws -> Vapor.Response {
        let data = try JSONEncoder().encode(self)
        return Response.init(status: .ok, body: .init(data: data))
    }
    
    static func validations(_ validations: inout Validations) {
        validations.add("email", as: String.self, is: .email)
    }
}
