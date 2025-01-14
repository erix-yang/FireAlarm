import SwiftUI

struct LoginView: View {
    @State private var userId = ""
    @State private var userName = ""
    @State private var userType: UserType = .student
    @State private var isShowingMainView = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isLoading = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Logo and Title
                Image("ubc-logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.top, 50)
                
                Text("UBC-CLL Fire Detection")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                // Login Form
                VStack(spacing: 20) {
                    TextField("User ID", text: $userId)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                    
                    TextField("User Name", text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    Picker("User Type", selection: $userType) {
                        Text("Student").tag(UserType.student)
                        Text("Admin").tag(UserType.admin)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    Button(action: performLogin) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        } else {
                            Text("Login")
                                .fontWeight(.semibold)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .disabled(userId.isEmpty || userName.isEmpty || isLoading)
                }
                .padding(.horizontal, 32)
                
                Spacer()
            }
            .navigationBarHidden(true)
        }
        .alert("Error", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        .fullScreenCover(isPresented: $isShowingMainView) {
            MainTabView()
        }
    }
    
    private func performLogin() {
        isLoading = true
        
        // 模拟网络请求
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            if !userId.isEmpty && !userName.isEmpty {
                let user = User(userId: userId,
                              userType: userType,
                              userName: userName)
                // 保存用户信息到 UserDefaults
                UserDefaults.standard.set(try? JSONEncoder().encode(user), forKey: "currentUser")
                isShowingMainView = true  // 这里会触发显示 MainTabView
            } else {
                alertMessage = "enter your user ID and name"
                showingAlert = true
            }
            isLoading = false
        }
    }
} 

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
