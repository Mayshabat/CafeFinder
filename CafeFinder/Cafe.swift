//
//  Cafe.swift
//  CafeFinder
//
//  Created by Student14 on 04/08/2026.
import Foundation
import FirebaseFirestore

struct Cafe {
    var id: String
    var name: String
    var city: String
    var rating: Int
    var notes: String
    var createdAt: Date

    init(
        id: String = UUID().uuidString,
        name: String,
        city: String,
        rating: Int,
        notes: String,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.name = name
        self.city = city
        self.rating = rating
        self.notes = notes
        self.createdAt = createdAt
    }

    init?(document: DocumentSnapshot) {
        guard let data = document.data(),
              let name = data["name"] as? String,
              let city = data["city"] as? String,
              let rating = data["rating"] as? Int,
              let notes = data["notes"] as? String else {
            return nil
        }

        self.id = document.documentID
        self.name = name
        self.city = city
        self.rating = rating
        self.notes = notes
        self.createdAt =
            (data["createdAt"] as? Timestamp)?.dateValue() ?? Date()
    }

    var dictionary: [String: Any] {
        [
            "name": name,
            "city": city,
            "rating": rating,
            "notes": notes,
            "createdAt": Timestamp(date: createdAt)
        ]
    }
}
