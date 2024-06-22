import UIKit

class LaucnScreen: UIViewController {
    
    private let finishHandler: (() -> Void)
    
    private lazy var laucnScreenCenterImage = UIView.imageView("LaucnScreenCenterImage")
    
    init(finishHandler: @escaping () -> Void) {
        self.finishHandler = finishHandler
        super.init(nibName: nil, bundle: nil)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var timer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateLabel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        UIView.animate(
            withDuration: 1.0,
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: {
                self.laucnScreenCenterImage.alpha = 1.0
            }, completion: { _ in
                
            }
        )
    }
    
    private func setupView() {
        view.image("LaucnScreenbg")
        
        laucnScreenCenterImage.alpha = 0.0
        view.addSubview(laucnScreenCenterImage)
        laucnScreenCenterImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
        }
    }
    
    private func animateLabel() {
        var counter = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.03, repeats: true) { timer in
            if counter <= 100 {
                counter += 2
            } else {
                timer.invalidate()
                self.finishHandler()
            }
        }
    }
}
