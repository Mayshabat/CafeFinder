//
//  CafeRealtimeService.swift
//  CafeFinder
//
//  Created by Student14 on 06/08/2026.
//

import Foundation
import FirebaseDatabase

final class CafeRealtimeService {

    // MARK: - Singleton

    static let shared = CafeRealtimeService()

    // MARK: - Properties

    private let databaseReference: DatabaseReference

    // MARK: - Initializer

    private init() {

        databaseReference = Database.database(
            url: "https://cafefinder-e1ae1-default-rtdb.firebaseio.com"
        ).reference()
    }

    // MARK: - Increment Views

    func incrementViews(for cafeID: String) {

        guard !cafeID.isEmpty else {
            return
        }

        let viewsReference = databaseReference
            .child("cafeViews")
            .child(cafeID)

        viewsReference.runTransactionBlock { currentData in

            let currentViews =
                (currentData.value as? NSNumber)?.intValue ?? 0

            currentData.value = currentViews + 1

            return TransactionResult.success(
                withValue: currentData
            )

        } andCompletionBlock: { error, _, _ in

            if let error = error {
                print(
                    "Realtime Database error:",
                    error.localizedDescription
                )
            }
        }
    }

    // MARK: - Observe Views

    func observeViews(
        for cafeID: String,
        completion: @escaping (Int) -> Void
    ) -> DatabaseHandle {

        return databaseReference
            .child("cafeViews")
            .child(cafeID)
            .observe(.value) { snapshot in

                let views =
                    (snapshot.value as? NSNumber)?.intValue ?? 0

                completion(views)
            }
    }

    // MARK: - Remove Observer

    func removeViewsObserver(
        for cafeID: String,
        handle: DatabaseHandle
    ) {

        databaseReference
            .child("cafeViews")
            .child(cafeID)
            .removeObserver(withHandle: handle)
    }
}
