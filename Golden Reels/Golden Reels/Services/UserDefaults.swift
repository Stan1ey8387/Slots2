import Foundation

extension UserDefaults {
    static var balance: Int {
        get {
            standard.value(forKey: "UserDefaults.balance") as? Int ?? 200
        }
        set {
            standard.set(newValue, forKey: "UserDefaults.balance")
        }
    }
    
    static var isMusicEnabled: Bool {
        get {
            standard.value(forKey: "UserDefaults.music") as? Bool ?? true
        }
        set {
            standard.set(newValue, forKey: "UserDefaults.music")
        }
    }
    
    static var isSoundsEnabled: Bool {
        get {
            standard.value(forKey: "UserDefaults.sound") as? Bool ?? true
        }
        set {
            standard.set(newValue, forKey: "UserDefaults.sound")
        }
    }
    
    
    static var endTime: Date? {
        get {
            standard.value(forKey: "UserDefaults.endTime") as? Date ?? nil
        }
        set {
            standard.set(newValue, forKey: "UserDefaults.endTime")
        }
    }
}

