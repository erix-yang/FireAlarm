import SwiftUI

struct CameraEditView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var cameraId = ""
    @State private var rtspUrl = ""
    @State private var location = ""
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var onSave: (Camera) -> Void
    
    private func validateInput() -> Bool {
        if !rtspUrl.lowercased().starts(with: "rtsp://") {
            errorMessage = "RTSP Url is not correct"
            showingError = true
            return false
        }
        return true
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("CameraName", text: $cameraId)
                    TextField("RtspUrl", text: $rtspUrl)
                    TextField("Location", text: $location)
                }
            }
            .navigationBarItems(
                leading: Button("Cancel") {
                    dismiss()
                },
                trailing: Button("Confirm") {
                    if validateInput() {
                        let newCamera = Camera(
                            cameraId: cameraId,
                            rtspUrl: rtspUrl,
                            location: location
                        )
                        onSave(newCamera)
                        dismiss()
                    }
                }
                .disabled(cameraId.isEmpty || rtspUrl.isEmpty || location.isEmpty)
            )
        }
        .alert("Wrong", isPresented: $showingError) {
            Button("Confirm", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
    }
}

struct CameraEditView_Previews: PreviewProvider {
    static var previews: some View {
        CameraEditView { _ in }
    }
}
