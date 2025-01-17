//
//  UserController.swift
//  latvalley
//
//  Created by Nhat Le Tien on 17/1/25.
//
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let user = routes.grouped("users")
        user.post(use: create)
        user.post("login", use: login)
//        user.group(":id") { user in
//            user.post(use: login)
//            user.post(use: delete)
//        }
    }
    
    func create(req: Request) async throws -> UserModel {
        let user = try req.content.decode(UserModel.self)
        return user
    }
    
    func login(req: Request) async throws -> UserModel {
        req.logger.info("\(req.description)")
//        try UserModel.validate(query: req)
        guard let data = req.body.data else {
            throw Abort(.custom(code: 0, reasonPhrase: "User not found"))
        }
        do {
            let json = try JSONDecoder().decode(UserModel.self, from: data)
            return UserModel(
                id: json.id,
                name: json.name,
                password: json.password,
                email: json.email
            )
        } catch {
            throw Abort(.badRequest)
        }
    }
    
    func delete(req: Request) async throws -> HTTPStatus {
        //TODO
        /*
         guard let todo = try await Todo.find(req.parameters.get("id"), on: req.db) else {
                     throw Abort(.notFound)
                 }
                 try await todo.delete(on: req.db)
         */
        return .ok
    }
    
}
