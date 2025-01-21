//
//  UserController.swift
//  latvalley
//
//  Created by Nhat Le Tien on 17/1/25.
//
import Vapor

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let user = routes.grouped("user")
        user.post("create", use: createUser)

        user.post("login", use: login)

    }
    
    func createUser(req: Request) async throws -> UserModel {
        do {
            let user = try req.content.decode(UserModel.self)
            req.logger.info("\(user)")
            let eventLoop = user.create(on: req.db).map { user }
            return try await eventLoop.get()
        } catch {
            req.logger.error("\(String(reflecting: error))")
            throw Abort(.custom(code: 0, reasonPhrase: error.localizedDescription))
        }
    }
    
    func login(req: Request) async throws -> UserModel {
        req.logger.info("\(req.description)")
        guard let data = req.body.data else {
            throw Abort(.custom(code: 0, reasonPhrase: "User not found"))
        }
        do {
            let user = try JSONDecoder().decode(UserModel.self, from: data)
            if let userModel = try await UserModel.query(on: req.db).all().first(where: { $0 == user }) {
                return userModel
            } else {
                throw Abort(.custom(code: 403, reasonPhrase: "Not found"))
            }
        } catch {
            throw Abort(.custom(code: 403, reasonPhrase: error.localizedDescription))
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
