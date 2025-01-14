import SwiftUI
import AVKit

struct AlertDetailView: View {
    let alert: Alert
    @State private var showingStream = false
    @State private var camera: Camera?
    @State private var isLoading = false
    @State private var errorMessage: String?
    
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // Alert Image
                AsyncImage(url: URL(string: alert.imageUrl)) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                            .cornerRadius(12)
                            .onTapGesture {
                                if camera != nil {
                                    showingStream = true
                                }
                            }
                    case .failure:
                        Image(systemName: "photo.fill")
                            .foregroundColor(.gray)
                            .frame(height: 300)
                    case .empty:
                        ProgressView()
                            .frame(height: 300)
                    @unknown default:
                        EmptyView()
                    }
                }
                .overlay {
                    if isLoading {
                        ProgressView()
                            .background(.ultraThinMaterial)
                            .cornerRadius(12)
                    }
                }
                
                // Alert Details
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Circle()
                            .fill(alert.severity == .fire ? Color.red : Color.orange)
                            .frame(width: 24, height: 24)
                            .overlay {
                                Image(systemName: alert.severity.image)
                                    .foregroundColor(.white)
                                    .font(.caption)
                            }
                        
                        Text(alert.severity == .fire ? "Fire Alert" : "Smoke Alert")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Text(alert.timestamp, style: .relative)
                            .foregroundColor(.gray)
                    }
                    
                    Divider()
                    
                    DetailRow(title: "Location", value: alert.location)
                    DetailRow(title: "Camera ID", value: alert.cameraId)
                    DetailRow(title: "Description", value: alert.description)
                    
                    if let camera = camera {
                        DetailRow(title: "Camera Status", value: camera.isOnline ? "Online" : "Offline")
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(12)
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
            }
            .padding()
        }
        .navigationTitle("Alert Details")
        .background(Color(.systemGroupedBackground))
        .onAppear {
            loadCameraDetails()
        }
        .fullScreenCover(isPresented: $showingStream) {
            if let camera = camera {
                RTSPPlayerView(rtspUrl: camera.rtspUrl)
            }
        }
        .alert("Error", isPresented: .constant(errorMessage != nil)) {
            Button("OK") {
                errorMessage = nil
            }
        } message: {
            if let error = errorMessage {
                Text(error)
            }
        }
    }
    
    private func loadCameraDetails() {
        isLoading = true
        // Load camera details from UserDefaults or your data source
        if let savedCameras = UserDefaults.standard.data(forKey: "savedCameras"),
           let cameras = try? JSONDecoder().decode([Camera].self, from: savedCameras) {
            camera = cameras.first { $0.cameraId == alert.cameraId }
            if camera == nil {
                errorMessage = "Camera not found"
            }
        }
        isLoading = false
    }
}

// Helper view for detail rows
struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(value)
                .font(.body)
        }
    }
}

// RTSP Player View using AVPlayer
struct RTSPPlayerView: View {
    let rtspUrl: String
    @Environment(\.dismiss) private var dismiss
    @StateObject private var playerViewModel = PlayerViewModel()
    
    var body: some View {
        ZStack {
            if let player = playerViewModel.player {
                VideoPlayer(player: player)
                    .ignoresSafeArea()
            } else {
                ProgressView()
            }
            
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.white)
                    }
                    .padding()
                    
                    Spacer()
                }
                Spacer()
            }
        }
        .onAppear {
            playerViewModel.setupPlayer(with: rtspUrl)
        }
        .onDisappear {
            playerViewModel.stopPlayer()
        }
    }
}

// View Model for handling AVPlayer
class PlayerViewModel: ObservableObject {
    @Published var player: AVPlayer?
    
    func setupPlayer(with rtspUrl: String) {
        guard let url = URL(string: rtspUrl) else { return }
        player = AVPlayer(url: url)
        player?.play()
    }
    
    func stopPlayer() {
        player?.pause()
        player = nil
    }
} 


#Preview {
    NavigationView {
        AlertDetailView(alert: Alert(
            cameraId: "CAM001",
            timestamp: Date().addingTimeInterval(-3600), // 1 hour ago
            severity: .fire,
            location: "Area 1",
            description: "Fire Detected",
            imageUrl: "https://th.bing.com/th/id/OIP.zSkaQTUwQjgX9BvUx882IwHaD4?w=345&h=181&c=7&r=0&o=5&dpr=2&pid=1.7"
        ))
    }
}
