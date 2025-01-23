//
//  UserController.swift
//  latvalley
//
//  Created by Nhat Le Tien on 17/1/25.
//
import Vapor
import JWTKit

struct UserController: RouteCollection {
    func boot(routes: RoutesBuilder) throws {
        let user = routes.grouped("user")
        user.post("create", use: createUser)
        user.post("login", use: login)
//        user.get("token", use: generateToken)
    }
    
    // This use to generart
//    func generateToken(req: Request) async throws -> [String: String] {
//        let payload = UserPayload(
//            subject: "LatValleyToken",
//            expiration: .init(value: .distantFuture),
//            isAdmin: true
//        )
//        let keyCollection = await JWTKeyCollection()
//                    .add(hmac: "TODO LatValley secret keys here", digestAlgorithm: .sha256)
//        let token = try await keyCollection.sign(payload)
//        return ["LatValleyToken": token]
//    }
    
    private func generateUserToken(
        _ payload: JWTPayload,
        kid: JWKIdentifier? = nil,
        header: JWTHeader = JWTHeader()
    ) async throws -> String {
        let privateKey = """
                    {
                        "alg" : "RS256",
                        "kty" : "RSA",
                        "kid" : "cc34c0a0-bd5a-4a3c-a50d-a2a7db7643df",
                        "use" : "sig",
                        "n"   : "pjdss8ZaDfEH6K6U7GeW2nxDqR4IP049fk1fK0lndimbMMVBdPv_hSpm8T8EtBDxrUdi1OHZfMhUixGaut-3nQ4GG9nM249oxhCtxqqNvEXrmQRGqczyLxuh-fKn9Fg--hS9UpazHpfVAFnB5aCfXoNhPuI8oByyFKMKaOVgHNqP5NBEqabiLftZD3W_lsFCPGuzr4Vp0YS7zS2hDYScC2oOMu4rGU1LcMZf39p3153Cq7bS2Xh6Y-vw5pwzFYZdjQxDn8x8BG3fJ6j8TGLXQsbKH1218_HcUJRvMwdpbUQG5nvA2GXVqLqdwp054Lzk9_B_f1lVrmOKuHjTNHq48w",
                        "e"   : "AQAB",
                        "d"   : "ksDmucdMJXkFGZxiomNHnroOZxe8AmDLDGO1vhs-POa5PZM7mtUPonxwjVmthmpbZzla-kg55OFfO7YcXhg-Hm2OWTKwm73_rLh3JavaHjvBqsVKuorX3V3RYkSro6HyYIzFJ1Ek7sLxbjDRcDOj4ievSX0oN9l-JZhaDYlPlci5uJsoqro_YrE0PRRWVhtGynd-_aWgQv1YzkfZuMD-hJtDi1Im2humOWxA4eZrFs9eG-whXcOvaSwO4sSGbS99ecQZHM2TcdXeAs1PvjVgQ_dKnZlGN3lTWoWfQP55Z7Tgt8Nf1q4ZAKd-NlMe-7iqCFfsnFwXjSiaOa2CRGZn-Q",
                        "p"   : "4A5nU4ahEww7B65yuzmGeCUUi8ikWzv1C81pSyUKvKzu8CX41hp9J6oRaLGesKImYiuVQK47FhZ--wwfpRwHvSxtNU9qXb8ewo-BvadyO1eVrIk4tNV543QlSe7pQAoJGkxCia5rfznAE3InKF4JvIlchyqs0RQ8wx7lULqwnn0",
                        "q"   : "ven83GM6SfrmO-TBHbjTk6JhP_3CMsIvmSdo4KrbQNvp4vHO3w1_0zJ3URkmkYGhz2tgPlfd7v1l2I6QkIh4Bumdj6FyFZEBpxjE4MpfdNVcNINvVj87cLyTRmIcaGxmfylY7QErP8GFA-k4UoH_eQmGKGK44TRzYj5hZYGWIC8",
                        "dp"  : "lmmU_AG5SGxBhJqb8wxfNXDPJjf__i92BgJT2Vp4pskBbr5PGoyV0HbfUQVMnw977RONEurkR6O6gxZUeCclGt4kQlGZ-m0_XSWx13v9t9DIbheAtgVJ2mQyVDvK4m7aRYlEceFh0PsX8vYDS5o1txgPwb3oXkPTtrmbAGMUBpE",
                        "dq"  : "mxRTU3QDyR2EnCv0Nl0TCF90oliJGAHR9HJmBe__EjuCBbwHfcT8OG3hWOv8vpzokQPRl5cQt3NckzX3fs6xlJN4Ai2Hh2zduKFVQ2p-AF2p6Yfahscjtq-GY9cB85NxLy2IXCC0PF--Sq9LOrTE9QV988SJy_yUrAjcZ5MmECk",
                        "qi"  : "ldHXIrEmMZVaNwGzDF9WG8sHj2mOZmQpw9yrjLK9hAsmsNr5LTyqWAqJIYZSwPTYWhY4nu2O0EY9G9uYiqewXfCKw_UngrJt8Xwfq1Zruz0YY869zPN4GiE9-9rzdZB33RBw8kIOquY3MK74FMwCihYx_LiU2YTHkaoJ3ncvtvg"
                    }
                    """
        let keyCollection = try await JWTKeyCollection().add(jwk: .init(json: privateKey))
        return try await keyCollection.sign(
            payload,
            kid: kid,
            header: header
        )
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
            throw Abort(.custom(code: 0, reasonPhrase: "Invalid request body"))
        }
        do {
            let user = try JSONDecoder().decode(UserModel.self, from: data)
            req.logger.info("User decode from request: \(user.description)")
            if var userModel = try await UserModel.query(on: req.db).all().first(where: { $0 == user }) {
                let payload = UserPayload(
                    subject: "LatValley",
                    expiration: .init(value: .distantFuture),
                    isAdmin: true
                )
                // Generate new token every time login request
                let token = try await generateUserToken(payload)
                user.token = token
                return user
            } else {
                throw Abort(.custom(code: 0, reasonPhrase: "User not found"))
            }
        } catch {
            throw Abort(.custom(code: 0, reasonPhrase: error.localizedDescription))
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
