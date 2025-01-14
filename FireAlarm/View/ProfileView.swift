import SwiftUI

struct ProfileView: View {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = true
    @State private var currentUser: User?
    @State private var showingLogoutAlert = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 60, height: 60)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(currentUser?.userName ?? "")
                                .font(.headline)
                            Text(currentUser?.userType == .admin ? "Administrator" : "Student")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Section("User Information") {
                    InfoRow(title: "User ID", value: currentUser?.userId ?? "")
                    InfoRow(title: "User Type", value: currentUser?.userType == .admin ? "Administrator" : "Student")
                    InfoRow(title: "Join Date", value: currentUser?.createTime.formatted() ?? "")
                }
                
                Section {
                    Button(role: .destructive) {
                        showingLogoutAlert = true
                    } label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("Logout")
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
        .alert("Logout", isPresented: $showingLogoutAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Logout", role: .destructive) {
                logout()
            }
        } message: {
            Text("Are you sure you want to logout?")
        }
        .onAppear {
            loadUser()
        }
    }
    
    private func loadUser() {
        if let userData = UserDefaults.standard.data(forKey: "currentUser"),
           let user = try? JSONDecoder().decode(User.self, from: userData) {
            currentUser = user
        }
    }
    
    private func logout() {
        UserDefaults.standard.removeObject(forKey: "currentUser")
        isLoggedIn = false
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Text(value)
                .foregroundColor(.gray)
        }
    }
} 

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}