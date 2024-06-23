import SnapKit

final class AlertView: UIView {
    init(
        money: Int,
        tapHandler: @escaping (Int) -> Void
    ) {
        super.init(frame: .zero)
        backgroundColor(.black.withAlphaComponent(0.8))
        
        let imageView = UIView.imageView(.alertViewCouins)
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().dividedBy(2)
            make.height.equalTo(imageView.snp.width).multipliedBy(283.0 / 545.0)
        }
        
        let label = UIView.boldLabel("\(money > 0 ? "+" : "") \(money)", fontSize: 23, textColor: .white)
        imageView.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        
        let button = UIView.button {
            self.removeFromSuperview()
            tapHandler(money)
        }.setupImage(.collect)
        button.alpha = 0.0
        addSubview(button)
        button.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
            make.width.equalToSuperview().dividedBy(2.2)
            make.height.equalTo(imageView.snp.width).multipliedBy(141.0 / 420.0)
        }
        
        UIView.animate(withDuration: 1.0, animations: {
            button.alpha = 1.0
        })
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

