//
//  CafeRealtimeService.swift
//  CafeFinder
//
//  Created by Student14 on 06/08/2026.
//
import Foundation
import FirebaseDatabase

final class CafeRealtimeService {

    static let shared = CafeRealtimeService()

    private let databaseReference: DatabaseReference

    private init() {
        databaseReference = Database.database(
            url: "https://cafefinder-e1ae1-default-rtdb.firebaseio.com"
        ).reference()
    }

    func incrementViews(for cafeID: String) {
        guard !cafeID.isEmpty else {
            print("❌ Cafe ID is empty")
            return
        }

        let viewsReference = databaseReference
            .child("cafeViews")
            .child(cafeID)

        print("Trying to increment views for:", cafeID)

        viewsReference.runTransactionBlock { currentData in
            let currentViews =
                (currentData.value as? NSNumber)?.intValue ?? 0

            currentData.value = currentViews + 1

            return TransactionResult.success(
                withValue: currentData
            )

        } andCompletionBlock: { error, committed, snapshot in

            if let error = error {
                print(
                    "❌ Realtime Database error:",
                    error.localizedDescription
                )
                return
            }

            print("✅ Transaction committed:", committed)
            print("✅ New value:", snapshot?.value ?? "nil")
        }
    }

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

                print("Views received:", views)
                completion(views)
            }
    }

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
