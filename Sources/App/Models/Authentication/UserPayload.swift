//
//  File.swift
//  latvalley
//
//  Created by Nhat Le Tien on 23/1/25.
//

import JWT

struct UserPayload: JWTPayload {
    /// Maps the longer Swift property name to the shortened
    /// keys userd in the JWT payload
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case isAdmin = "admin"
    }
    
    /// The `sub` (subject) clain the indenfifies the principal
    /// that is the subject of the JWT
    var subject: SubjectClaim
    
    /// The `exp` (expiration time) claim the identifies the expiration time
    /// on or after which the JWT MUST NOT be accepted for processing
    var expiration: ExpirationClaim
    
    /// Custom data
    /// If true, the user is an admin.
    var isAdmin: Bool
    
    /// Run any addition verification logic beyond
    /// signature verification here.
    /// Since we have an ExpirationClaim, we'll
    /// call its verify method
    func verify(using algorithm: some JWTAlgorithm) async throws {
        try expiration.verifyNotExpired()
    }
    
}
