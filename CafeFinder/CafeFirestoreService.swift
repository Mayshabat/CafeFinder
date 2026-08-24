//
//  CafeFirestoreService.swift
//  CafeFinder
//


import Foundation
import FirebaseFirestore

final class CafeFirestoreService {

    // MARK: - Singleton

    // מופע יחיד של השירות לכל האפליקציה
    static let shared = CafeFirestoreService()


    // MARK: - Properties

    // חיבור למסד הנתונים של Firestore
    private let database =
        Firestore.firestore(database: "default")

    // שם האוסף שבו נשמרים בתי הקפה
    private let collectionName = "cafes"


    // MARK: - Initializer

    private init() {}


    // MARK: - Observe Cafes

    // קריאת בתי הקפה והאזנה לשינויים בזמן אמת
    func observeCafes(
        completion: @escaping (Result<[Cafe], Error>) -> Void
    ) -> ListenerRegistration {

        return database
            .collection(collectionName)
            .order(
                by: "createdAt",
                descending: true
            )
            .addSnapshotListener { snapshot, error in

                // טיפול בשגיאה במקרה שהקריאה נכשלה
                if let error = error {
                    completion(.failure(error))
                    return
                }

                // המרת המסמכים שהתקבלו לאובייקטים מסוג Cafe
                let cafes =
                    snapshot?.documents.compactMap {
                        Cafe(document: $0)
                    } ?? []

                completion(.success(cafes))
            }
    }


    // MARK: - Add Cafe

    // הוספת בית קפה חדש ל-Firestore
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

    // עדכון הנתונים של בית קפה קיים
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

    // מחיקת בית קפה לפי המזהה שלו
    func deleteCafe(
        id: String,
        completion: @escaping (Error?) -> Void
    ) {

        database
            .collection(collectionName)
            .document(id)
            .delete(
                completion: completion
            )
    }
}
