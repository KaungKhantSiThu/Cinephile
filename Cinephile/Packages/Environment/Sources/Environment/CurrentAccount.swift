//
//  CurrentAccount.swift
//
//
//  Created by Kaung Khant Si Thu on 14/12/2023.
//

import Combine
import Foundation
import Models
import Networking
import Observation

@MainActor
@Observable public class CurrentAccount {
    private static var accountsCache: [String: Account] = [:]
    
    public private(set) var account: Account?
    public private(set) var lists: [List] = []
    public private(set) var tags: [Tag] = []
    public private(set) var genres: [Genre] = []
    public private(set) var followRequests: [Account] = []
    public private(set) var isUpdating: Bool = false
    public private(set) var updatingFollowRequestAccountIds = Set<String>()
    public private(set) var isLoadingAccount: Bool = false
    
    private var client: Client?
    
    public static let shared = CurrentAccount()
    
//    public var sortedLists: [List] {
//        lists.sorted { $0.title.lowercased() < $1.title.lowercased() }
//    }
    
    public var sortedTags: [Tag] {
        tags.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    public var sortedGenres: [Genre] {
        genres.sorted { $0.name.lowercased() < $1.name.lowercased() }
    }
    
    private init() {}
    
    public func setClient(client: Client) {
        self.client = client
        guard client.isAuth else { return }
        Task(priority: .userInitiated) {
            await fetchUserData()
        }
    }
    
    private func fetchUserData() async {
        await withTaskGroup(of: Void.self) { group in
            group.addTask { await self.fetchCurrentAccount() }
            group.addTask { await self.fetchConnections() }
            group.addTask { await self.fetchFollowedTags() }
            group.addTask { await self.fetchFollowedGenres() }
            group.addTask { await self.fetchFollowerRequests() }
        }
    }
    
    public func fetchConnections() async {
        guard let client else { return }
        do {
            let connections: [String] = try await client.get(endpoint: Instances.peers)
            client.addConnections(connections)
        } catch {}
    }
    
    public func fetchCurrentAccount() async {
        guard let client, client.isAuth else {
            account = nil
            return
        }
        account = Self.accountsCache[client.id]
        if account == nil {
            isLoadingAccount = true
        }
        account = try? await client.get(endpoint: Accounts.verifyCredentials)
        isLoadingAccount = false
        Self.accountsCache[client.id] = account
    }
    
    
    public func fetchFollowedTags() async {
        guard let client, client.isAuth else { return }
        do {
            tags = try await client.get(endpoint: Accounts.followedTags)
        } catch {
            tags = []
        }
    }
    
    public func fetchFollowedGenres() async {
        guard let client, client.isAuth else { return }
        do {
            genres = try await client.get(endpoint: Genres.followedGenres)
        } catch {
            genres = []
        }
    }
    
    public func followTag(id: String) async -> Tag? {
        guard let client else { return nil }
        do {
            let tag: Tag = try await client.post(endpoint: Tags.follow(id: id))
            tags.append(tag)
            return tag
        } catch {
            return nil
        }
    }
    
    public func unfollowTag(id: String) async -> Tag? {
        guard let client else { return nil }
        do {
            let tag: Tag = try await client.post(endpoint: Tags.unfollow(id: id))
            tags.removeAll { $0.id == tag.id }
            return tag
        } catch {
            return nil
        }
    }
    
    public func followGenre(id: Genre.ID) async -> Genre? {
        guard let client else { return nil }
        do {
            let genre: Genre = try await client.post(endpoint: Genres.follow(id: id))
            genres.append(genre)
            return genre
        } catch {
            return nil
        }
    }
    
    public func unfollowGenre(id: Genre.ID) async -> Genre? {
        guard let client else { return nil }
        do {
            let genre: Genre = try await client.post(endpoint: Genres.unfollow(id: id))
            genres.removeAll { $0.id == genre.id }
            return genre
        } catch {
            return nil
        }
    }
    
    public func updateGenres(ids: [Genre.ID]) async -> [Genre]? {
        
        var removedGenres: [Genre.ID] = []
        var addedGenres: [Genre.ID] = []
        
        // Find removed genres
        for genre in self.genres {
            if !ids.contains(where: { $0 == genre.genreId }) {
                removedGenres.append(genre.genreId)
            }
        }

        // Find added genres
        for id in ids {
            if !genres.contains(where: { $0.genreId == id }) {
                addedGenres.append(id)
            }
        }
        
//        print("Removed genres:")
//        for id in removedGenres {
//            print(id)
//        }
//
//        print("Added genres:")
//        for id in addedGenres {
//            print(id)
//        }
        
        if !addedGenres.isEmpty {
            let _ = await followGenres(ids: addedGenres)
        }
        
        if !removedGenres.isEmpty {
            let _ = await unfollowGenres(ids: removedGenres)
        }
        
        // the followed genres list didn't change
        return genres
    }
    
    public func followGenres(ids: [Genre.ID]) async -> [Genre]? {
        guard let client else { return nil }
        do {
            let array: [Genre] = try await client.post(endpoint: Genres.followGenres(json: GenreIDData(genreIds: ids)))
            genres.append(contentsOf: array)
            return array
        } catch {
            return nil
        }
    }
    
    public func unfollowGenres(ids: [Genre.ID]) async -> [Genre]? {
        guard let client else { return nil }
        do {
            let array: [Genre] = try await client.post(endpoint: Genres.unfollowGenres(json: GenreIDData(genreIds: ids)))
            genres = genres.filter { genre in
                !array.contains {
                    $0.id == genre.id
                }
            }
            return array
        } catch {
            return nil
        }
    }
    
    
    public func fetchFollowerRequests() async {
        guard let client else { return }
        do {
            followRequests = try await client.get(endpoint: FollowRequests.list)
        } catch {
            followRequests = []
        }
    }
    
    public func acceptFollowerRequest(id: String) async {
        guard let client else { return }
        do {
            updatingFollowRequestAccountIds.insert(id)
            defer {
                updatingFollowRequestAccountIds.remove(id)
            }
            _ = try await client.post(endpoint: FollowRequests.accept(id: id))
            await fetchFollowerRequests()
        } catch {}
    }
    
    public func rejectFollowerRequest(id: String) async {
        guard let client else { return }
        do {
            updatingFollowRequestAccountIds.insert(id)
            defer {
                updatingFollowRequestAccountIds.remove(id)
            }
            _ = try await client.post(endpoint: FollowRequests.reject(id: id))
            await fetchFollowerRequests()
        } catch {}
    }
}

