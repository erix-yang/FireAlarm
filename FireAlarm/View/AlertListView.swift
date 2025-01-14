import SwiftUI

struct AlertListView: View {
    @State private var alerts: [Alert] = [
        Alert(
            cameraId: "CAM001",
            timestamp: Date().addingTimeInterval(-3600), // 1 hour ago
            severity: .fire,
            location: "Area 1",
            description: "Fire Detected",
            imageUrl: "https://th.bing.com/th/id/OIP.zSkaQTUwQjgX9BvUx882IwHaD4?w=345&h=181&c=7&r=0&o=5&dpr=2&pid=1.7"
        ),
        Alert(
            cameraId: "CAM002",
            timestamp: Date().addingTimeInterval(-1800), // 30 minutes ago
            severity: .smoke,
            location: "Area 1",
            description: "Fire Detected",
            imageUrl: "https://th.bing.com/th/id/OIP.K-wbEaKEnj0cMNsxQSg_WQHaEh?w=298&h=181&c=7&r=0&o=5&dpr=2&pid=1.7"
        ),
        Alert(
            cameraId: "CAM003",
            timestamp: Date(),
            severity: .fire,
            location: "Area 2",
            description: "Smoke Detected",
            imageUrl: "https://th.bing.com/th/id/OIP.75R_khDu0d9moa982vuC1gHaE7?w=273&h=181&c=7&r=0&o=5&dpr=2&pid=1.7"
        )
    ]
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(alerts, id: \.cameraId) { alert in
                        NavigationLink(destination: AlertDetailView(alert: alert)) {
                            AlertCard(alert: alert)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Alert List")
            .background(Color(.systemGroupedBackground))
        }
    }
}

struct AlertCard: View {
    let alert: Alert
    @State private var isPressed = false
    
    var body: some View {
        HStack(spacing: 16) {
            // Alert type icon
            Circle()
                .fill(alert.severity == .fire ? Color.red : Color.orange)
                .frame(width: 50, height: 50)
                .overlay {
                    Image(systemName: alert.severity.image)
                        .foregroundColor(.white)
                        .font(.title2)
                }
                .shadow(color: alert.severity == .fire ? .red.opacity(0.3) : .orange.opacity(0.3),
                        radius: 5, x: 0, y: 3)
            
            // Alert information
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(alert.location)
                        .font(.headline)
                    Spacer()
                    Text(alert.timestamp, style: .relative)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(alert.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Camera: \(alert.cameraId)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            // Alert image
            AsyncImage(url: URL(string: alert.imageUrl)) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()
                case .failure:
                    Image(systemName: "photo.fill")
                        .foregroundColor(.gray)
                case .empty:
                    ProgressView()
                        .tint(.gray)
                @unknown default:
                    Image(systemName: "photo.fill")
                        .foregroundColor(.gray)
                }
            }
            .frame(width: 70, height: 70)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1),
                       radius: 5, x: 0, y: 2)
        )
        .padding(.horizontal, 4)
        .scaleEffect(isPressed ? 0.98 : 1.0)
        .animation(.spring(response: 0.3), value: isPressed)
    }
}

struct AlertListView_Previews: PreviewProvider {
    static var previews: some View {
        AlertListView()
    }
}
