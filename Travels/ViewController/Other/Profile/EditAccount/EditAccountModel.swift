//
//  EditAccountModel.swift
//  Travels
//
//  Created by Anna on 08.06.2025.
//

import Foundation
protocol EditAccountModelProtocol: AnyObject {
    func updateAccount(name: String?, phone: String?, password: String?, completion: @escaping (Result<Void, Error>) -> Void)
}

final class EditAccountModel: EditAccountModelProtocol {
    func updateAccount(name: String?, phone: String?, password: String?, completion: @escaping (Result<Void, Error>) -> Void) {
        let components = (name ?? "").split(separator: " ", maxSplits: 1)
        let firstName = String(components.first ?? "")
        let lastName = components.count > 1 ? String(components[1]) : ""

        let userRequest = UserRequest(
            firstName: firstName,
            lastName: lastName,
            phone: phone ?? "",
            password: password
        )

        NetworkManager.shared.updateUserProfile(request: userRequest, completion: completion)
    }

}
