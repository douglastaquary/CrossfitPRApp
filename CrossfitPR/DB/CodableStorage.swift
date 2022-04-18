//
//  CodableStorage.swift
//  CrossfitPR
//
//  Created by Douglas Taquary on 09/04/22.
//

import Foundation

class CodableStorage {

    //static let shared = CodableStorage()
    
    private let storage: DiskStorage //= DiskStorage(path: URL(fileURLWithPath: NSTemporaryDirectory()))
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    init(storage: DiskStorage,
        decoder: JSONDecoder = .init(),
        encoder: JSONEncoder = .init()
    ) {
        self.storage = storage
        self.decoder = decoder
        self.encoder = encoder
    }

    func fetch<T: Decodable>(for key: String) throws -> T {
        let data = try storage.fetchValue(for: key)
        return try decoder.decode(T.self, from: data)
    }

    func save<T: Encodable>(_ value: T, for key: String) throws {
        let data = try encoder.encode(value)
        try storage.save(value: data, for: key)
    }
}
