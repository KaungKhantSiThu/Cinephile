import SwiftUI

struct SignUpView: View {

    @StateObject private var viewModel = SignUpViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                EmptyField(field: $viewModel.email, sfSymbolName: "envelope", placeholder: "Email Address", prompt: viewModel.confirmEmailPrompt)
                EmptyField(field: $viewModel.password, sfSymbolName: "lock", placeholder: "Password", prompt: viewModel.passwordPrompt, isSecure: true)
                EmptyField(field: $viewModel.confirmPassword, sfSymbolName: "lock", placeholder: "Confirm Password", prompt: viewModel.confirmPasswordPrompt, isSecure: true)
                
                Button {
                    withAnimation(.easeIn) {
                        viewModel.showYearSelector = true
                    }
                } label: {
                    Text(String(viewModel.birthOfYear))
                }
                .padding(8)
                .foregroundColor(.primary)
                .background(Color(.secondarySystemBackground))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray)
                )
                Text(viewModel.agePrompt)
                    .font(.caption)
                
                Button {
                
                } label: {
                    Text("Sign Up")
                }
                .foregroundColor(.white)
                .padding(.vertical, 5)
                .padding(.horizontal)
                .background(Capsule().fill(.blue))
                .opacity(viewModel.canSubmit ? 1 : 0.6)
                .disabled(!viewModel.canSubmit)
                Spacer()
            }
            .padding()
            YearPicker(birthYear: $viewModel.birthOfYear, showYearSelector: $viewModel.showYearSelector)
                .opacity(viewModel.showYearSelector ? 1: 0)
        }
    }
}

#Preview {
    SignUpView()
}
