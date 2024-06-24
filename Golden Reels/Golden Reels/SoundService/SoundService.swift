import AVFoundation

enum Музыка: String {
    case фон = "background music"
}

enum Звуки: String {
    case клик = "click sound"
    case вращение = "spin slot sound"
    case выигрыш = "win sound"
}

final class СервисЗвука {
    
    static let общий = СервисЗвука()
    
    var включенаМузыка: Bool {
        return UserDefaults.isMusicEnabled
    }
    
    var включеныЗвуки: Bool {
        return UserDefaults.isSoundsEnabled
    }
    
    private var проигрывательМузыки: AVAudioPlayer?
    private var проигрывательЗвуков: AVAudioPlayer?
    
    private init() { }
    
    // Музыка
    
    func воспроизвестиМузыку() {
        guard включенаМузыка else { return }
        
        if let urlЗвука = Bundle.main.url(forResource: Музыка.фон.rawValue, withExtension: "mp3") {
            do {
                let аудиоПроигрыватель = try AVAudioPlayer(contentsOf: urlЗвука)
                self.проигрывательМузыки = nil
                self.проигрывательМузыки = аудиоПроигрыватель
                аудиоПроигрыватель.numberOfLoops = -1
                аудиоПроигрыватель.play()
            } catch {
                print("Не удалось воспроизвести звук: \(error)")
            }
        } else {
            print("Файл звука не найден: \(Музыка.фон.rawValue).mp3")
        }
    }
    
    func остановитьМузыку() {
        проигрывательМузыки?.stop()
        проигрывательМузыки = nil
    }
    
    // Звуки
    
    func воспроизвестиЗвук(название звука: Звуки) {
        guard включеныЗвуки else { return }
        
        if let urlЗвука = Bundle.main.url(forResource: звука.rawValue, withExtension: "mp3") {
            do {
                let аудиоПроигрыватель = try AVAudioPlayer(contentsOf: urlЗвука)
                self.проигрывательЗвуков = аудиоПроигрыватель
                аудиоПроигрыватель.play()
            } catch {
                print("Не удалось воспроизвести звук: \(error)")
            }
        } else {
            print("Файл звука не найден: \(звука.rawValue).mp3")
        }
    }
}
