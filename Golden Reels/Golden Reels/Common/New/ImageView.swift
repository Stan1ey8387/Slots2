import UIKit

extension UIView {
    static func imageView(_ name: String) -> UIImageView {
        if name == "" {
            return UIImageView(image: nil)
        }
        
        return UIImageView(image: .init(named: name))
    }
    
    static func imageView(_ image: UIImage?) -> UIImageView {
        return UIImageView(image: image)
    }
}

extension UIImageView {
    @discardableResult
    func setColor(_ color: UIColor) -> Self {
        let image = self.image
        self.image = image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
        return self
    }
    
    @discardableResult
    func contentMode(_ value: ContentMode) -> Self {
        self.contentMode = value
        return self
    }
}

extension UIImage {
    func flipHorizontally() -> UIImage? {
        UIGraphicsBeginImageContext(self.size)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else {
            return nil
        }
        
        // Переместить начало координат в центр изображения, чтобы сделать переворот относительно центра
        context.translateBy(x: self.size.width / 2, y: self.size.height / 2)
        // Инвертировать координаты по горизонтали
        context.scaleBy(x: -1.0, y: 1.0)
        // Вернуть начало координат обратно
        context.translateBy(x: -self.size.width / 2, y: -self.size.height / 2)
        
        context.draw(cgImage, in: CGRect(origin: .zero, size: self.size))
        
        let flippedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return flippedImage
    }
}

extension UIImage {
    func rotate(byDegrees degrees: CGFloat) -> UIImage? {
        let radians = degrees * .pi / 180
        return rotate(byRadians: radians)
    }
    
    func rotate(byRadians radians: CGFloat) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: radians)).size
        // Корректируем новый размер, чтобы не было дробных пикселей
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContext(newSize)
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else {
            return nil
        }
        
        // Перемещаем начало координат к центру нового изображения
        context.translateBy(x: newSize.width / 2, y: newSize.height / 2)
        // Поворачиваем контекст
        context.rotate(by: radians)
        // Рисуем исходное изображение в центре контекста
        context.draw(cgImage, in: CGRect(x: -self.size.width / 2, y: -self.size.height / 2, width: self.size.width, height: self.size.height))
        
        let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return rotatedImage
    }
}
