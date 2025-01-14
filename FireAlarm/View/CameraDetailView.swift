import SwiftUI
import AVKit

struct CameraDetailView: View {
    let camera: Camera
    @State private var isPlaying = false
    @StateObject private var playerViewModel = PlayerViewModel()
    @State private var relatedAlerts: [Alert] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // RTSP Stream Player Area
                ZStack(alignment: .topLeading) {
                    if isPlaying, let player = playerViewModel.player {
                        VideoPlayer(player: player)
                            .frame(height: 250)
                            // .cornerRadius(12)
                    } else {
                        Rectangle()
                            .fill(Color.black.opacity(0.1))
                            .frame(height: 250)
                            // .cornerRadius(12)
                            .overlay {
                                Button {
                                    isPlaying = true
                                    playerViewModel.setupPlayer(with: camera.rtspUrl)
                                } label: {
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 50))
                                        .foregroundColor(.blue)
                                }
                            }
                    }
                    
                    // Back Button
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .padding(8)
                            .background(.ultraThinMaterial)
                            .clipShape(Circle())
                    }
                    .padding(12)
                }
                .edgesIgnoringSafeArea(.top)
                
                // Camera Details
                VStack(alignment: .leading, spacing: 12) {
                    Group {
                        DetailInfoRow(title: "Camera ID", value: camera.cameraId)
                        DetailInfoRow(title: "Location", value: camera.location)
                        DetailInfoRow(title: "Status", value: camera.isOnline ? "Online" : "Offline")
                        DetailInfoRow(title: "Installation Date", 
                                    value: camera.createTime.formatted(date: .abbreviated, time: .shortened))
                        DetailInfoRow(title: "RTSP URL", value: camera.rtspUrl)
                    }
                    .font(.footnote)
                }
                .padding(.horizontal)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Related Alerts
                VStack(alignment: .leading, spacing: 16) {
                    Text("Recent Alerts")
                        .font(.headline)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    if relatedAlerts.isEmpty {
                        Text("No recent alerts")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        ForEach(relatedAlerts, id: \.timestamp) { alert in
                            AlertRow(alert: alert)
                                .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.vertical)
        }
        .background(Color(.systemBackground))
        .edgesIgnoringSafeArea(.top)
        .onDisappear {
            playerViewModel.stopPlayer()
        }
        .onAppear {
            loadRelatedAlerts()
        }
    }
    
    private func loadRelatedAlerts() {
        // 模拟加载相关警报
        relatedAlerts = [
            Alert(
                cameraId: camera.cameraId,
                timestamp: Date().addingTimeInterval(-3600),
                severity: .fire,
                location: camera.location,
                description: "Fire detected in monitoring area",
                imageUrl: "https://example.com/fire1.jpg"
            ),
            Alert(
                cameraId: camera.cameraId,
                timestamp: Date().addingTimeInterval(-7200),
                severity: .smoke,
                location: camera.location,
                description: "Smoke detected in monitoring area",
                imageUrl: "https://example.com/smoke1.jpg"
            )
        ]
    }
}

// 新的详情行视图
struct DetailInfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            Text(value)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// Alert Row View
struct AlertRow: View {
    let alert: Alert
    
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(alert.severity == .fire ? Color.red : Color.orange)
                .frame(width: 40, height: 40)
                .overlay {
                    Image(systemName: alert.severity.image)
                        .foregroundColor(.white)
                }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(alert.severity == .fire ? "Fire Alert" : "Smoke Alert")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Text(alert.description)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Text(alert.timestamp, style: .relative)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(8)
    }
}

// Preview
struct CameraDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CameraDetailView(camera: Camera(
            cameraId: "CAM001",
            rtspUrl: "rtsp://192.168.1.100:554/stream1",
            location: "Building A",
            createTime: Date().addingTimeInterval(-86400 * 7),
            isOnline: true
        ))
    }
} 