//
//  Cafe.swift
//  CafeFinder
//
//  Created by Student14 on 04/08/2026.
//

import Foundation
import FirebaseFirestore

struct Cafe {

    // MARK: - Properties

    var id: String
    var name: String
    var city: String
    var rating: Int
    var notes: String
    var createdAt: Date
    var address: String
    var imageName: String

    // MARK: - Initializer

    init(
        id: String = UUID().uuidString,
        name: String,
        city: String,
        rating: Int,
        notes: String,
        createdAt: Date = Date(),
        address: String,
        imageName: String = "defaultCafe"
    ) {
        self.id = id
        self.name = name
        self.city = city
        self.rating = rating
        self.notes = notes
        self.createdAt = createdAt
        self.address = address
        self.imageName = imageName
    }

    // MARK: - Firestore Initializer

    init?(document: DocumentSnapshot) {

        guard
            let data = document.data(),
            let name = data["name"] as? String,
            let city = data["city"] as? String,
            let rating = data["rating"] as? Int,
            let notes = data["notes"] as? String
        else {
            return nil
        }

        self.id = document.documentID
        self.name = name
        self.city = city
        self.rating = rating
        self.notes = notes

        self.createdAt =
            (data["createdAt"] as? Timestamp)?.dateValue()
            ?? Date()

        self.address =
            data["address"] as? String
            ?? ""

        self.imageName =
            data["imageName"] as? String
            ?? "defaultCafe"
    }

    // MARK: - Firestore Dictionary

    var dictionary: [String: Any] {
        return [
            "name": name,
            "city": city,
            "rating": rating,
            "notes": notes,
            "createdAt": Timestamp(date: createdAt),
            "address": address,
            "imageName": imageName
        ]
    }
}
