import Foundation

struct Alert {
    let cameraId: String
    let timestamp: Date
    let severity: AlertSeverity
    let location: String
    let description: String
    let imageUrl: String

    
    enum AlertSeverity {
        case fire
        case smoke
        var image: String {
            switch self {
                case .fire: return "flame.fill"
                case .smoke: return "smoke.fill"
            }
        }
    }

    init(cameraId: String,
         timestamp: Date = Date(),
         severity: AlertSeverity,
         location: String,
         description: String,
         imageUrl: String) {
        self.cameraId = cameraId
        self.timestamp = timestamp
        self.severity = severity
        self.location = location
        self.description = description
        self.imageUrl = imageUrl
    }
    

}
