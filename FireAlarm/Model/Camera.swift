import Foundation

struct Camera: Codable, Identifiable {
    let id = UUID()
    let cameraId: String
    let rtspUrl: String
    let location: String
    let createTime: Date
    let isOnline: Bool
    
    // 标准初始化方法
    init(cameraId: String, 
         rtspUrl: String, 
         location: String, 
         createTime: Date, 
         isOnline: Bool) {
        self.cameraId = cameraId
        self.rtspUrl = rtspUrl
        self.location = location
        self.createTime = createTime
        self.isOnline = isOnline
    }
    
    // 便利初始化方法 - 使用当前时间作为创建时间，默认在线状态为 true
    init(cameraId: String, 
         rtspUrl: String, 
         location: String) {
        self.init(cameraId: cameraId,
                 rtspUrl: rtspUrl,
                 location: location,
                 createTime: Date(),
                 isOnline: true)
    }
    
    enum CodingKeys: String, CodingKey {
        case cameraId
        case rtspUrl
        case location
        case createTime
        case isOnline
    }
}
