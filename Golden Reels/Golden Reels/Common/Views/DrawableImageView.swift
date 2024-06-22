import UIKit

class DrawableImageView: UIView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    struct Dot {
        let color: UIColor
        let point: CGPoint
    }
    
    private var dots: [Dot] = []
    var dotColor = UIColor.red
    private let dotSize = CGSize(width: 32, height: 32)
    var dotsCountChangeHandler: ((Int) -> Void)?
    
    init(image: UIImage?) {
        super.init(frame: .zero)
        imageView.image = image
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(addDot(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(tapGesture)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    var saveSize: CGSize = .zero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView.bounds.size.width > saveSize.width, imageView.bounds.size.height > saveSize.height {
            saveSize = imageView.bounds.size
            print("<<<< \(imageView.bounds.size)")
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func saveImageWithDots() -> UIImage? {
        guard let imageWithDots = imageView.image, saveSize != .zero else {
            print("No image available.")
            return nil
        }

        UIGraphicsBeginImageContextWithOptions(saveSize, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else {
            print("Could not get the context.")
            return nil
        }
        
        // Draw green background
            context.setFillColor(UIColor.init(hex: 0xE125FF).cgColor)
            context.fill(CGRect(origin: .zero, size: saveSize))

            imageWithDots.draw(in: CGRect(origin: .zero, size: saveSize))

            context.setFillColor(UIColor.red.cgColor)
            context.setBlendMode(.normal)

            for dot in dots {
                context.setFillColor(dot.color.cgColor)
                context.fillEllipse(in: CGRect(x: dot.point.x - (dotSize.width / 2), y: dot.point.y - (dotSize.width / 2), width: dotSize.width, height: dotSize.height))
            }

            let finalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

        return finalImage
    }
    
    
    @objc private func addDot(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: imageView)
        dots.append(.init(color: dotColor, point: tapPoint))
        addDotToImage(at: tapPoint)
        dotsCountChangeHandler?(dots.count)
    }
    
    private func addDotToImage(at point: CGPoint) {
        UIGraphicsBeginImageContextWithOptions(imageView.frame.size, false, 0.0)
        imageView.image?.draw(in: imageView.bounds)
        
        let context = UIGraphicsGetCurrentContext()!
        context.setFillColor(dotColor.cgColor)
        context.fillEllipse(in: CGRect(x: point.x - 5, y: point.y - 5, width: dotSize.width, height: dotSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        imageView.image = newImage
    }
}

class DrawableLineImage: UIView {
    
    var lastPoint: CGPoint!
    var brushWidth: CGFloat = 3.0
    var lineColor = UIColor.red
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    var lines: [CAShapeLayer] = []
    
    init(image: UIImage?) {
        super.init(frame: .zero)
        imageView.image = image
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(drawLine(_:)))
        imageView.isUserInteractionEnabled = true
        imageView.addGestureRecognizer(panGesture)
        
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var saveSize: CGSize = .zero
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if imageView.bounds.size.width > saveSize.width, imageView.bounds.size.height > saveSize.height {
            saveSize = imageView.bounds.size
        }
    }
    
    @objc func drawLine(_ recognizer: UIPanGestureRecognizer) {
        let point = recognizer.location(in: imageView)
        
        if recognizer.state == .began {
            lastPoint = point
        } else if recognizer.state == .changed {
            let path = UIBezierPath()
            path.move(to: lastPoint)
            path.addLine(to: point)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = lineColor.cgColor
            shapeLayer.lineWidth = brushWidth
            shapeLayer.lineCap = .round
            
            imageView.layer.addSublayer(shapeLayer)
            lines.append(shapeLayer)
            
            lastPoint = point
        } else if recognizer.state == .ended {
            let path = UIBezierPath()
            path.move(to: lastPoint)
            path.addLine(to: point)
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = lineColor.cgColor
            shapeLayer.lineWidth = brushWidth
            shapeLayer.lineCap = .round
            
            imageView.layer.addSublayer(shapeLayer)
            lines.append(shapeLayer)
        }
    }
    
    func saveDrawing() -> UIImage? {
        guard saveSize != .zero else {
            return nil
        }
            UIGraphicsBeginImageContextWithOptions(saveSize, false, 0.0)
            defer { UIGraphicsEndImageContext() }

            guard let context = UIGraphicsGetCurrentContext() else { return nil }
            layer.render(in: context)

            return UIGraphicsGetImageFromCurrentImageContext()
        }
}
