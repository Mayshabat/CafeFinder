////
//  CafeFirestoreService.swift
//  CafeFinder
//
//  Created by Student14 on 06/08/2026.
//

import Foundation
import FirebaseFirestore

final class CafeFirestoreService {

    // MARK: - Singleton

    static let shared = CafeFirestoreService()

    // MARK: - Properties

    private let database = Firestore.firestore()
    private let collectionName = "cafes"

    // MARK: - Initializer

    private init() {}

    // MARK: - Observe Cafes

    func observeCafes(
        completion: @escaping (Result<[Cafe], Error>) -> Void
    ) -> ListenerRegistration {

        return database
            .collection(collectionName)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in

                if let error = error {
                    completion(.failure(error))
                    return
                }

                let cafes =
                    snapshot?.documents.compactMap {
                        Cafe(document: $0)
                    } ?? []

                completion(.success(cafes))
            }
    }

    // MARK: - Add Cafe

    func addCafe(
        _ cafe: Cafe,
        completion: @escaping (Error?) -> Void
    ) {

        database
            .collection(collectionName)
            .document(cafe.id)
            .setData(
                cafe.dictionary,
                completion: completion
            )
    }

    // MARK: - Update Cafe

    func updateCafe(
        _ cafe: Cafe,
        completion: @escaping (Error?) -> Void
    ) {

        database
            .collection(collectionName)
            .document(cafe.id)
            .setData(
                cafe.dictionary,
                merge: true,
                completion: completion
            )
    }

    // MARK: - Delete Cafe

    func deleteCafe(
        id: String,
        completion: @escaping (Error?) -> Void
    ) {

        database
            .collection(collectionName)
            .document(id)
            .delete(completion: completion)
    }
}
