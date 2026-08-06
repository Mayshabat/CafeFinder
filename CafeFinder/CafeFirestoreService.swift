//
//  CafeFirestoreService.swift
//  CafeFinder
//
//  Created by Student14 on 06/08/2026.
//

import Foundation
import FirebaseFirestore

final class CafeFirestoreService {

    static let shared = CafeFirestoreService()

    private let database = Firestore.firestore()
    private let collectionName = "cafes"

    private init() {}

    func observeCafes(
        completion: @escaping (Result<[Cafe], Error>) -> Void
    ) -> ListenerRegistration {

        return database.collection(collectionName)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in

                if let error = error {
                    completion(.failure(error))
                    return
                }

                let cafes = snapshot?.documents.compactMap {
                    Cafe(document: $0)
                } ?? []

                completion(.success(cafes))
            }
    }

    func addCafe(
        _ cafe: Cafe,
        completion: @escaping (Error?) -> Void
    ) {
        database.collection(collectionName)
            .document(cafe.id)
            .setData(cafe.dictionary, completion: completion)
    }

    func updateCafe(
        _ cafe: Cafe,
        completion: @escaping (Error?) -> Void
    ) {
        database.collection(collectionName)
            .document(cafe.id)
            .setData(cafe.dictionary, completion: completion)
    }

    func deleteCafe(
        id: String,
        completion: @escaping (Error?) -> Void
    ) {
        database.collection(collectionName)
            .document(id)
            .delete(completion: completion)
    }
}
