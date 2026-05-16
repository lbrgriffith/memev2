//
//  MemeStore.swift
//  meme_ex_1
//
//  Process-wide store for sent memes. Replaces stashing the array on AppDelegate,
//  which never belonged there even in 2016.
//

import Foundation

@MainActor
final class MemeStore {
    static let shared = MemeStore()
    private init() {}

    private(set) var memes: [Meme] = []

    func append(_ meme: Meme) {
        memes.append(meme)
    }

    func replace(at index: Int, with meme: Meme) {
        guard memes.indices.contains(index) else { return }
        memes[index] = meme
    }

    func remove(at index: Int) {
        guard memes.indices.contains(index) else { return }
        memes.remove(at: index)
    }
}
