//
//  File.swift
//  
//
//  Created by Kaung Khant Si Thu on 17/12/2023.
//

import SwiftUI
import Models
import Networking
import OSLog

private let logger = Logger(subsystem: "Account", category: "EditAccountViewModel")

@MainActor
@Observable class EditAccountViewModel {
  @Observable class FieldEditViewModel: Identifiable {
    let id = UUID().uuidString
    var name: String = ""
    var value: String = ""

    init(name: String, value: String) {
      self.name = name
      self.value = value
    }
  }

  public var client: Client?

  var displayName: String = ""
  var note: String = ""
  var postPrivacy = Models.Visibility.pub
  var isSensitive: Bool = false
  var isBot: Bool = false
  var isLocked: Bool = false
  var isDiscoverable: Bool = false
  var fields: [FieldEditViewModel] = []

  var isLoading: Bool = true
  var isSaving: Bool = false
  var saveError: Bool = false

  init() {}

  func fetchAccount() async {
    guard let client else { return }
    do {
        logger.info("Fetching Account for Editing")
      let account: Account = try await client.get(endpoint: Accounts.verifyCredentials)
        logger.info("Fetched Account for Editing")
      displayName = account.displayName ?? ""
      note = account.source?.note ?? ""
      postPrivacy = account.source?.privacy ?? .pub
      isSensitive = account.source?.sensitive ?? false
      isBot = account.bot
      isLocked = account.locked
      isDiscoverable = account.discoverable ?? false
      fields = account.source?.fields.map { .init(name: $0.name, value: $0.value.asRawText) } ?? []
      withAnimation {
        isLoading = false
      }
    } catch {
        logger.error("Failed to Fetch Account for Editing: \(error.localizedDescription)")
    }
  }

  func save() async {
    isSaving = true
    do {
      let data = UpdateCredentialsData(displayName: displayName,
                                       note: note,
                                       source: .init(privacy: postPrivacy, sensitive: isSensitive),
                                       bot: isBot,
                                       locked: isLocked,
                                       discoverable: isDiscoverable,
                                       fieldsAttributes: fields.map { .init(name: $0.name, value: $0.value) })
        logger.info("Updating account information")
      let response = try await client?.patch(endpoint: Accounts.updateCredentials(json: data))
      if response?.statusCode != 200 {
          logger.error("Failed Updating account information: Response's Status code: \(response?.statusCode ?? 0, privacy: .public)")
        saveError = true
      } else {
          logger.info("Successfully updated account information")
      }
      isSaving = false
    } catch {
      isSaving = false
        logger.error("Failed Updating account information: \(error.localizedDescription)")
      saveError = true
    }
  }
}
