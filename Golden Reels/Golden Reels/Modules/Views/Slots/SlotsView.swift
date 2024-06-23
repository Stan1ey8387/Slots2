import UIKit

class SlotsView: UIView {
    struct SlotsSelectedItem {
        var image: UIImage?
        var was: Bool
    }
    
    struct SlotsResultItem {
        var multiplier: Int
        var images: [UIImage]
    }
    
    private let items: [[SlotItem]]
    private let visibleSize: Int
    private var collectionsViews: [UICollectionView] = []
    private var selectedItems: [SlotsSelectedItem] = []
    private lazy var stackView = UIView.horizontalStackView(views: collectionsViews).distribution(.fillEqually)
    
    
    init(
        items: [SlotItem] = Constans.Game.items,
        visibleSize: Int = 5
    ) {
        var itemsArray: [[SlotItem]] = []
        (0..<visibleSize).forEach { _ in
            itemsArray.append(items.shuffled())
        }
        self.items = itemsArray
        self.visibleSize = max(1, visibleSize)
        super.init(frame: .zero)
        
        collectionsViews = (0..<visibleSize).map { index in
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            
            let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
            collectionView.backgroundColor(.clear)
            collectionView.tag = index
            collectionView.transform = CGAffineTransform(rotationAngle: -(CGFloat)(Double.pi))
            collectionView.isUserInteractionEnabled(false)
            collectionView.showsVerticalScrollIndicator = false
            
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.register(SlotsViewCell.self, forCellWithReuseIdentifier: SlotsViewCell.identifier)
            
            return collectionView
        }
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public methods
    
    func spin(completion: @escaping (SlotsResultItem) -> Void) {
        guard selectedItems.isEmpty else {
            return
        }
        
        SoundService.shared.playSound(named: .spin)
        
        selectedItems = (0..<visibleSize).map { _ in
            .init(image: nil, was: false)
        }
        collectionsViews.enumerated().forEach { index, collectionView in
            UIView.animate(withDuration: 0.3, delay: TimeInterval(index) / 5, animations: {
                collectionView.contentOffset.y -= 20
            }) { _ in
                let randomIndex = (100...900).randomElement() ?? 555
                collectionView.scrollToItem(at: .init(row: randomIndex, section: 0), at: .bottom, animated: true)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    if let cell =  collectionView.cellForItem(at: .init(row: randomIndex - 2, section: 0)) as? SlotsViewCell {
                        let image = cell.imageView.image
                        if let wasIndex = self.selectedItems.firstIndex(where: { $0.image == image}) {
                            self.selectedItems[wasIndex].was = true
                        }
                        self.selectedItems[index].was = self.selectedItems.contains(where: { $0.image == image })
                        self.selectedItems[index].image = image
                        
                        UIView.animate(withDuration: 0.3, animations: {
                            cell.transform = .init(scaleX: 1.2, y: 1.2)
                        }) { _ in
                            UIView.animate(withDuration: 0.3) {
                                cell.transform = .identity
                                
                                if index == self.collectionsViews.count - 1 {
                                    let multiplier = self.selectedItems.map { $0.was }.filter { $0 == true }.count
                                    completion(.init(multiplier: multiplier, images: self.selectedItems.map { $0.image }.compactMap { $0 }))
                                    self.selectedItems = []
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Private methods
    
    private func setupView() {
        image(.gameplay)
        backgroundColor(.clear)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(40)
        }
    }
}

extension SlotsView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1000
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SlotsViewCell.identifier, for: indexPath)
        (cell as? SlotsViewCell)?.setImage(items[collectionView.tag][indexPath.row % items.count].image)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sideSize = stackView.bounds.width / self.visibleSize.cgFloat
        return .init(
            width: sideSize,
            height: sideSize
        )
    }
}
