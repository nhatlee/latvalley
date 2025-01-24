//
//  File.swift
//  latvalley
//
//  Created by Nhat Le Tien on 23/1/25.
//

import JWT

struct UserPayload: JWTPayload {
    enum UserRole: Codable {
        case admin
        case normal
        case guest
    }
    /// Maps the longer Swift property name to the shortened
    /// keys userd in the JWT payload
    enum CodingKeys: String, CodingKey {
        case subject = "sub"
        case expiration = "exp"
        case issuer = "iss"
        case role = "role"
    }
    
    /// The `sub` (subject) clain the indenfifies the principal
    /// that is the subject of the JWT
    var subject: SubjectClaim
    
    var issuer: IssuerClaim
    
    /// The `exp` (expiration time) claim the identifies the expiration time
    /// on or after which the JWT MUST NOT be accepted for processing
    var expiration: ExpirationClaim
    
    /// Custom data
    /// User role
    var role: UserRole
    
    /// Run any addition verification logic beyond
    /// signature verification here.
    /// Since we have an ExpirationClaim, we'll
    /// call its verify method
    func verify(using algorithm: some JWTAlgorithm) async throws {
        try expiration.verifyNotExpired()
    }
    
}
