import UIKit

struct SlotItem {
    let image: UIImage
}

extension Constans {
    enum Game {
        static let items: [SlotItem] = [
            .init(image: .item1),
            .init(image: .item2),
            .init(image: .item3),
            .init(image: .item4),
            .init(image: .item5),
            .init(image: .item6),
            .init(image: .item7),
            .init(image: .item8),
            .init(image: .item9),
        ]
    }
}
