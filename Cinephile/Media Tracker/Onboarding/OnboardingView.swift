import SwiftUI

struct OnboardingView: View {
    @AppStorage("currentPage") var currentPage = 1
    var totalPage = 3
    
    var body: some View {
        ZStack {
            if currentPage == 1 {
                ScreenView(image: "movie", title: "Watch Movie", details: "Here is the link to join the Trello board as a member so that you can create tasks.", totalPage: totalPage)
            }
            
            if currentPage == 2 {
                ScreenView(image: "movie", title: "Delete Movie", details: "Here is the link to join the Trello board as a member so that you can create tasks.", totalPage: totalPage)
            }
            
            if currentPage == 3 {
                ScreenView(image: "movie", title: "Record Movie", details: "Here is the link to join the Trello board as a member so that you can create tasks.", totalPage: totalPage)
            }
        }
    }
}

#Preview {
    OnboardingView()
}

struct ScreenView: View {
    
    @AppStorage("currentPage") var currentPage = 1
    @State var image: String
    @State var title: String
    @State var details: String
    @State var totalPage: Int
    
    var body: some View {
        VStack {
            HStack {
                if currentPage == 1 {
                    Text("Welcome Cinephile")
                        .font(.title)
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                        .kerning(1.4)
                } else {
                    Button(action: {currentPage -= 1}, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(.black.opacity(0.4))
                            .cornerRadius(10)
                    })
                }
                
                Spacer()
                
                Button(action: {
                    currentPage = 4
                }, label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })
            }
            .padding()
            .foregroundColor(.black)
            
            Spacer(minLength: /*@START_MENU_TOKEN@*/0/*@END_MENU_TOKEN@*/)
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 16)
                .frame(height: 300)
            
            Spacer(minLength: 80)
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .kerning(1.2)
                .padding(.top)
                .padding(.bottom, 5)
                .foregroundColor(.pink)
            
            Text(details)
                .font(.body)
                .fontWeight(.regular)
                .kerning(1.2)
                .padding([.leading, .trailing])
                .multilineTextAlignment(.center)
            
            Spacer(minLength: 0)
            
            HStack {
                switch currentPage {
                case 1 :
                    Color(.systemPink).frame(height: 8 / UIScreen.main.scale)
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                case 2:
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                    Color(.systemPink).frame(height: 8 / UIScreen.main.scale)
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                case 3:
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                    Color(.systemPink).frame(height: 8 / UIScreen.main.scale)
                default:
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                    Color.gray.frame(height: 8 / UIScreen.main.scale)
                }
            }
            
            Button(action: {
                if currentPage <= totalPage {
                    currentPage += 1
                } else {
                    currentPage = 1
                }
            }, label: {
                if currentPage == 3 {
                    Text("Get Start")
                        .fontWeight(.semibold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(.pink)
                        .cornerRadius(40)
                        .padding(.horizontal, 20)
                } else {
                    Text("Next")
                        .fontWeight(.semibold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(.pink)
                        .cornerRadius(40)
                        .padding(.horizontal, 20)
                }
            })
        }
    }
}
