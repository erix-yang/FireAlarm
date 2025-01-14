import SwiftUI

struct MainTabView: View {
    var body: some View {
        ZStack {
            // 添加背景 logo
            Image("cid-logo")
                .resizable()
                .scaledToFit()
                .opacity(0.8) // 设置透明度为 10%
            
            // 原有的 TabView
            TabView {
                AlertListView()
                    .tabItem {
                        Image(systemName: "bell.fill")
                        Text("Alerts")
                    }
                
                CameraListView()
                    .tabItem {
                        Image(systemName: "video.fill")
                        Text("Cameras")
                    }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Profile")
                    }
            }
        }
    }
} 

#Preview {
    MainTabView()
}
