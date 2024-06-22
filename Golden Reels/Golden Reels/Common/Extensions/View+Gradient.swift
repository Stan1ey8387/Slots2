import UIKit

extension UIView {
    @discardableResult
    func applyBorder(color: UIColor, width: CGFloat) -> Self {
        layer.borderColor = color.cgColor
        layer.borderWidth = width
        return self
    }
    
    func applyGradient(
        colours: [UIColor]
    ) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.5, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
    
    @discardableResult
    func addShadow(color: UIColor = .black) -> Self {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = 1
        layer.shadowOffset = .zero
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.4
        return self
    }
}
