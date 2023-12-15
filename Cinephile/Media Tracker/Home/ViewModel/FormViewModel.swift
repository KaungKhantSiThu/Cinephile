import Foundation
import Combine

@MainActor
class FormViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var birthOfDate = Date()
    @Published var inlineErrorForPassword = ""
    @Published var inlineErrorForEmail = ""
    
    @Published var isValid = false
    
    private var cancellables = Set<AnyCancellable>()
    
//    private var isUserNameValid: AnyPublisher<Bool, Never> {
//        $username
//            .debounce(for: 0.8, scheduler: RunLoop.main)
//            .removeDuplicates()
//            .map {
//                self.validateName(candidate: $0)
//            }
//            .eraseToAnyPublisher()
//    }
    
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
            .map{ $0.count >= 6 }
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
    
//    private var isEmailNameValidPublisher: AnyPublisher<NameEmailStatus, Never> {
//        Publishers.CombineLatest(isEmailValid, isUserNameValid)
//            .map {
//                if !$0 {
//                    return NameEmailStatus.emailInvalid
//                }
//                if !$1 {
//                    return NameEmailStatus.nameInvalid
//                }
//                return NameEmailStatus.valid
//            }
//            .eraseToAnyPublisher()
//    }
    
    private var isFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isPasswordValidPublisher, isEmailValidPublisher)
            .map { $0 == .valid && $1 == .valid }
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
                    return "Password cannot be empty"
                case .weakPassword:
                    return "Password must be 6 characters"
                case .repeatedPassword:
                    return "Password do not match"
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
                    return "Email is Invalid"
                case .valid:
                    return ""
                }
            }
            .assign(to: \.inlineErrorForEmail, on: self)
            .store(in: &cancellables)
        
    }
    
    private func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }
    
    private func validateName(candidate: String) -> Bool {
        let nameRegex = "(?<! )[-a-zA-Z' ]{2,26}"
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
