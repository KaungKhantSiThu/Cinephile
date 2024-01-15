//
//  File.swift
//  
//
//  Created by Kaung Khant Si Thu on 17/12/2023.
//

import SwiftUI
import Models
import Networking
import PhotosUI
import CoreTransferable
import OSLog
import Status

private let logger = Logger(subsystem: "Account", category: "EditAccountViewModel")

@MainActor
@Observable class EditAccountViewModel {
    @Observable class FieldEditViewModel: Identifiable, Equatable {
        static func == (lhs: EditAccountViewModel.FieldEditViewModel, rhs: EditAccountViewModel.FieldEditViewModel) -> Bool {
            lhs.id == rhs.id
        }
        
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
  var avatar: URL?
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
    
    // MARK: - Profile Image
    
    enum ImageState {
        case empty
        case loading(Progress)
        case success(Image)
        case failure(Error)
    }
    
    enum TransferError: Error {
        case importFailed
    }
    
    struct ProfileImage: Transferable {
        let image: Image
        
        static var transferRepresentation: some TransferRepresentation {
            DataRepresentation(importedContentType: .image) { data in
            #if canImport(AppKit)
                guard let nsImage = NSImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(nsImage: nsImage)
                return ProfileImage(image: image)
            #elseif canImport(UIKit)
                guard let uiImage = UIImage(data: data) else {
                    throw TransferError.importFailed
                }
                let image = Image(uiImage: uiImage)
                return ProfileImage(image: image)
            #else
                throw TransferError.importFailed
            #endif
            }
        }
    }
    
    private(set) var imageState: ImageState = .empty
    
    var imageSelection: PhotosPickerItem? = nil {
        didSet {
            if let imageSelection {
                let progress = loadTransferable(from: imageSelection)
                imageState = .loading(progress)
            } else {
                imageState = .empty
            }
        }
    }
    

  func fetchAccount() async {
    guard let client else { return }
    do {
        logger.info("Fetching Account for Editing")
      let account: Account = try await client.get(endpoint: Accounts.verifyCredentials)
        logger.info("Fetched Account for Editing")
      displayName = account.displayName ?? ""
      avatar = account.avatar
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
        logger.info("Uploading new account information")
      let response = try await client?.patch(endpoint: Accounts.updateCredentials(json: data))
        
      if response?.statusCode != 200 {
          logger.error("Failed Updating account information: Response's Status code: \(response?.statusCode ?? 0, privacy: .public)")
        saveError = true
      } else {
          logger.info("Successfully updated account information")
      }
        if let imageSelection {
            if let data = await getItemImageData(item: imageSelection) {
                logger.info("Uploading new avatar image")
                let result = await uploadAvatar(data: data)
                if result {
                    logger.info("Successfully Uploaded new avatar image")
                    saveError = result
                } else {
                    logger.info("Failed Uploading new avatar image")
                    saveError = result
                }
                
            }
        }
        
      isSaving = false
    } catch {
      isSaving = false
        logger.error("Failed Updating account information: \(error.localizedDescription)")
      saveError = true
    }
  }
    
    private func uploadAvatar(data: Data) async -> Bool {
      guard let client else { return false }
      do {
        let response = try await client.mediaUpload(endpoint: Accounts.updateCredentialsMedia,
                                                     version: .v1,
                                                     method: "PATCH",
                                                     mimeType: "image/jpeg",
                                                     filename: "avatar",
                                                     data: data)
        return response?.statusCode == 200
      } catch {
        return false
      }
    }
    
    private func getItemImageData(item: PhotosPickerItem) async -> Data? {
      guard let imageFile = try? await item.loadTransferable(type: ImageFileTranseferable.self) else { return nil }

        let compressor = StatusEditor.Compressor()

      guard let compressedData = await compressor.compressImageFrom(url: imageFile.url),
              let image = UIImage(data: compressedData),
              let uploadData = try? await compressor.compressImageForUpload(image)
      else { return nil }
      
      return uploadData
    }
    
    // MARK: - Private Methods
    
    private func loadTransferable(from imageSelection: PhotosPickerItem) -> Progress {
        return imageSelection.loadTransferable(type: ProfileImage.self) { result in
            DispatchQueue.main.async {
                guard imageSelection == self.imageSelection else {
                    print("Failed to get the selected item.")
                    return
                }
                switch result {
                case .success(let profileImage?):
                    self.imageState = .success(profileImage.image)
                case .success(nil):
                    self.imageState = .empty
                case .failure(let error):
                    self.imageState = .failure(error)
                }
            }
        }
    }
}

