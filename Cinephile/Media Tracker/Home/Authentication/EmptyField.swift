import SwiftUI

struct EmptyField: View {
    
    @Binding var field: String
    
    var sfSymbolName: String
    var placeholder: String
    var prompt: String
    
    var isSecure = false
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: sfSymbolName)
                    .foregroundColor(.gray)
                    .font(.headline)
                    .frame(width: 20)
                
                if isSecure {
                    SecureField(placeholder, text: $field)
                } else {
                    TextField(placeholder, text: $field)
                }
            }
            .autocapitalization(.none)
            .padding()
            .background(Color(.secondarySystemBackground))
            .overlay(RoundedRectangle(cornerRadius: 8).stroke())
            
            Text(prompt)
        }
    }
}

#Preview {
    EmptyField(field: .constant(""), sfSymbolName: "envelope", placeholder: "Email Address", prompt: "Enter a valid email address")
}
