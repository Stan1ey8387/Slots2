import UIKit

class CircleProgressView: UIView {
    let circleProgressLayer: CircleProgressLayer
    
    init(
        lineWidth: CGFloat,
        backgroundColor: UIColor,
        progressColor: UIColor
    ) {
        circleProgressLayer = .init(
            frame: .zero,
            lineWidth: lineWidth,
            backgroundCGColor: backgroundColor.cgColor,
            progressCGColor: progressColor.cgColor
        )
        super.init(frame: .zero)
        layer.addSublayer(circleProgressLayer)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        circleProgressLayer.frame = bounds
    }
}


class CircleProgressLayer: CALayer {
    private var backgroundCircleLayer: CAShapeLayer!
    private var progressCircleLayer: CAShapeLayer!
    private let animationKey = "StrokeEndAnimation"

    private var progress: CGFloat = 0

    private var backgroundCGColor: CGColor {
        didSet {
            redrawСircles()
        }
    }
    public var progressCGColor: CGColor {
        didSet {
            redrawСircles()
        }
    }

    private var backgroundThemeColor: UIColor? {
        didSet {
            if let backgroundThemeColor = self.backgroundThemeColor {
                backgroundCGColor = backgroundThemeColor.cgColor
            }
        }
    }
    public var progressThemeColor: UIColor? {
        didSet {
            if let progressThemeColor = self.progressThemeColor {
                progressCGColor = progressThemeColor.cgColor
            }
        }
    }

    public override var frame: CGRect {
        didSet {
            redrawСircles()
        }
    }

    public var lineWidth: CGFloat = 0 {
        didSet {
            redrawСircles()
        }
    }

    // Inits cannot be deleted, this is a solution to the problem with "Use of unimplemented initializer"
    // The problem appears when we change the frame of the layer in run time

    public override init() {
        self.backgroundThemeColor = .red
        self.backgroundCGColor = UIColor.gray.cgColor
        self.progressThemeColor = .green
        self.progressCGColor = UIColor.blue.cgColor
        super.init()
    }

    public override init(layer: Any) {
        self.backgroundThemeColor = .red
        self.backgroundCGColor = UIColor.gray.cgColor
        self.progressThemeColor = .green
        self.progressCGColor = UIColor.blue.cgColor
        super.init(layer: layer)
    }

    public required init?(coder: NSCoder) {
        self.backgroundThemeColor = .red
        self.backgroundCGColor = UIColor.gray.cgColor
        self.progressThemeColor = .green
        self.progressCGColor = UIColor.blue.cgColor
        super.init(coder: coder)
    }

    public init(
        frame: CGRect,
        lineWidth: CGFloat,
        backgroundColor: UIColor = .red,
        progressColor: UIColor = .green
    ) {
        self.backgroundThemeColor = backgroundColor
        self.backgroundCGColor = backgroundColor.cgColor
        self.progressThemeColor = progressColor
        self.progressCGColor = progressColor.cgColor

        super.init()

        self.lineWidth = lineWidth
        self.frame = frame

        redrawСircles()
    }

    public init(
        frame: CGRect,
        lineWidth: CGFloat,
        backgroundCGColor: CGColor,
        progressCGColor: CGColor
    ) {
        self.backgroundCGColor = backgroundCGColor
        self.progressCGColor = progressCGColor
        self.backgroundThemeColor = nil

        super.init()

        self.lineWidth = lineWidth
        self.frame = frame

        redrawСircles()
    }

    public func set(progress: CGFloat) { // 0...1
        self.progress = min(1, max(0, progress))
        self.progressCircleLayer.removeAnimation(forKey: self.animationKey)

        // Set strokeEnd without animation
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.progressCircleLayer.strokeEnd = self.progress
        CATransaction.commit()
    }

    public func playAnimation(fromValue: CGFloat = 0, toValue: CGFloat) {
        guard self.progressCircleLayer.animation(forKey: self.animationKey) == nil else { return }

        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = 1
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeIn)
        animation.fillMode = .forwards
        animation.isRemovedOnCompletion = false
        self.progressCircleLayer.add(animation, forKey: self.animationKey)
    }

    public func removeAnimations() {
        self.progressCircleLayer.removeAllAnimations()
    }

    private func redrawСircles() {
        sublayers?.forEach { $0.removeFromSuperlayer() }
        backgroundCircleLayer = paintCircle(frame: frame, lineWidth: lineWidth, endProgress: 1)
        progressCircleLayer = paintCircle(frame: frame, lineWidth: lineWidth, endProgress: progress)

        update(backgroundColor: backgroundCGColor, progressColor: progressCGColor)
    }

    private func update(backgroundColor: CGColor, progressColor: CGColor) {
        backgroundCircleLayer.strokeColor = backgroundColor
        progressCircleLayer.strokeColor = progressColor
    }

    @discardableResult
    private func paintCircle(
        frame: CGRect,
        lineWidth: CGFloat,
        endProgress: CGFloat
    ) -> CAShapeLayer {
        let endProgress = min(1, max(0, endProgress))

        let center = CGPoint(x: frame.width / 2, y: frame.height / 2)
        let circleRadius = frame.width / 2
        let startAngle: CGFloat = -CGFloat.pi / 2
        let endAngle = startAngle + 2 * CGFloat.pi

        let strokeLayer = CAShapeLayer()
        let strokePath = UIBezierPath(arcCenter: center, radius: circleRadius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        strokeLayer.path = strokePath.cgPath
        strokeLayer.fillColor = UIColor.clear.cgColor
        strokeLayer.lineWidth = lineWidth
        strokeLayer.cornerRadius = 10
        strokeLayer.lineCap = .round
        strokeLayer.strokeEnd = endProgress
        self.addSublayer(strokeLayer)

        return strokeLayer
    }
}
