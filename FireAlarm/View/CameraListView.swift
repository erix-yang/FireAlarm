import SwiftUI

struct CameraListView: View {
    @State private var cameras: [Camera] = [
        Camera(
            cameraId: "CAM001",
            rtspUrl: "rtsp://192.168.1.100:554/stream1",
            location: "Area 1",
            createTime: Date().addingTimeInterval(-86400 * 7), // 7天前
            isOnline: true
        ),
        Camera(
            cameraId: "CAM002",
            rtspUrl: "rtsp://192.168.1.101:554/stream1",
            location: "Area 2",
            createTime: Date().addingTimeInterval(-86400 * 5), // 5天前
            isOnline: false
        ),
        Camera(
            cameraId: "CAM003",
            rtspUrl: "rtsp://192.168.1.102:554/stream1",
            location: "Area 3",
            createTime: Date().addingTimeInterval(-86400 * 3), // 3天前
            isOnline: true
        ),
        Camera(
            cameraId: "CAM004",
            rtspUrl: "rtsp://192.168.1.103:554/stream1",
            location: "Area 4",
            createTime: Date().addingTimeInterval(-86400), // 1天前
            isOnline: true
        )
    ]
    @State private var showingAddCamera = false
    @State private var editMode = EditMode.inactive
    @State private var showingCameraDetail = false
    @State private var selectedCamera: Camera?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(cameras) { camera in
                    Button {
                        // 显示相机详情sheet
                        showingCameraDetail = true
                        selectedCamera = camera
                    } label: {
                        HStack(spacing: 12) {
                            // 摄像头图标和状态
                            Image(systemName: "video.fill")
                                .foregroundColor(camera.isOnline ? .green : .gray)
                                .font(.title2)
                                .overlay(alignment: .bottomTrailing) {
                                    Circle()
                                        .fill(camera.isOnline ? .green : .red)
                                        .frame(width: 12, height: 12)
                                        .offset(x: 4, y: 4)
                                }
                            
                            // 摄像头信息
                            VStack(alignment: .leading, spacing: 4) {
                                Text(camera.location)
                                    .font(.headline)
                                Text(camera.cameraId)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Text("InstalledTime：\(camera.createTime.formatted(date: .abbreviated, time: .shortened))")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            // 查看详情箭头
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
                .onDelete { indexSet in
                    cameras.remove(atOffsets: indexSet)
                }
            }
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddCamera = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .navigationTitle("Camera List")
        }
        .environment(\.editMode, $editMode)
        .sheet(isPresented: $showingAddCamera) {
            CameraEditView { newCamera in
                cameras.append(newCamera)
            }
        }
        .sheet(item: $selectedCamera) { camera in
            CameraDetailView(camera: camera)
        }
    }

    init() {
        if let data = UserDefaults.standard.data(forKey: "savedCameras"),
           let savedCameras = try? JSONDecoder().decode([Camera].self, from: data) {
            _cameras = State(initialValue: savedCameras)
        }
    }
}

struct CameraListView_Previews: PreviewProvider {
    static var previews: some View {
        CameraListView()
    }
}
