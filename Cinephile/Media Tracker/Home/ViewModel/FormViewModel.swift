import Foundation
import Combine

@MainActor
class FormViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var birthOfDate = Date()
    @Published var agreement = false
    @Published var inlineErrorForPassword = ""
    @Published var inlineErrorForEmail = ""
    @Published var inlineErrorForUsername = ""
    
    @Published var isValid = false
    
    private var cancellables = Set<AnyCancellable>()
    
    
    
    private var isUserNameValidPublisher: AnyPublisher<UsernameStatus, Never> {
        $username
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {
                if !self.validateName(candidate: $0) {
                    return UsernameStatus.invalid
                }
                
                return UsernameStatus.valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isEmailValidPublisher: AnyPublisher<EmailStatus, Never> {
        $email
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map {
                if !self.validateEmail(candidate: $0) {
                    return EmailStatus.invalid
                }
                
                return EmailStatus.valid
            }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordEmptyPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .map { $0.isEmpty }
            .eraseToAnyPublisher()
    }

    private var arePasswordsEqualPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($password, $confirmPassword)
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .map{ $0 == $1 }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordStrongPublisher: AnyPublisher<Bool, Never> {
        $password
            .debounce(for: 0.2, scheduler: RunLoop.main)
            .removeDuplicates()
            .map{ $0.count >= 8 }
            .eraseToAnyPublisher()
    }
    
    private var isPasswordValidPublisher: AnyPublisher<PasswordStatus, Never> {
        Publishers.CombineLatest3(isPasswordEmptyPublisher, isPasswordStrongPublisher, arePasswordsEqualPublisher)
            .map {
                if $0 {
                    return PasswordStatus.empty
                }
                if !$1 {
                    return PasswordStatus.weakPassword
                }
                if !$2 {
                    return PasswordStatus.repeatedPassword
                }
                return PasswordStatus.valid
            }
            .eraseToAnyPublisher()
    }
    
    private var agreementPublisher: AnyPublisher<Bool, Never> {
        $agreement
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .removeDuplicates()
            .eraseToAnyPublisher()
    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest3(isEmailValidPublisher, isPasswordValidPublisher, agreementPublisher)
            .map { $0 == .valid && $1 == .valid && $2 == true}
            .eraseToAnyPublisher()
    }
    
    init() {
        isFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isValid, on: self)
            .store(in: &cancellables)
        
        isPasswordValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { PasswordStatus in
                switch PasswordStatus {
                case .empty:
                    return "Passwords cannot be empty"
                case .weakPassword:
                    return "Passwords must be at least 8 characters"
                case .repeatedPassword:
                    return "Passwords do not match"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.inlineErrorForPassword, on: self)
            .store(in: &cancellables)
        
        isEmailValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { EmailStatus in
                switch EmailStatus {
                case .invalid:
                    return "Email is invalid"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.inlineErrorForEmail, on: self)
            .store(in: &cancellables)
        
        isUserNameValidPublisher
            .dropFirst()
            .receive(on: RunLoop.main)
            .map { status in
                switch status {
                case .valid:
                    return ""
                case .invalid:
                    return "Username is invalid"
                }
            }
            .assign(to: \.inlineErrorForUsername, on: self)
            .store(in: &cancellables)
    }
    
    private func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    private func validateName(candidate: String) -> Bool {
        let nameRegex = "(?<! )[-_a-zA-Z0-9]{2,26}"
        return NSPredicate(format: "SELF MATCHES %@", nameRegex).evaluate(with: candidate)
    }
}

enum PasswordStatus {
    case empty
    case weakPassword
    case repeatedPassword
    case valid
}

enum EmailStatus {
    case invalid
    case valid
}

enum UsernameStatus {
    case invalid
    case valid
}

enum NameEmailStatus {
    case invalid
    case valid
}
