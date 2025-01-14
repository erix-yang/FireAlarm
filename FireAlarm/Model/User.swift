import Foundation

// 用户结构体
struct User: Codable {
    let userId: String
    let userType: UserType
    let userName: String
    let createTime: Date
    
    // 初始化方法
    init(userId: String, userType: UserType, userName: String, createTime: Date = Date()) {
        self.userId = userId
        self.userType = userType
        self.userName = userName
        self.createTime = createTime
    }
}


// 定义用户类型枚举
enum UserType: Codable {
    case admin
    case student
}
