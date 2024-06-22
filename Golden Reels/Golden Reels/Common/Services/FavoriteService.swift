import Foundation

protocol Favoritable: Codable & Equatable {
    static var identifier: String { get }
}

class FavoriteService<Item: Favoritable>  {
    private let key: String
    
    init() {
        self.key = Item.identifier
    }
    
    var favorites: [Item] {
        set {
            if let encoded = try? JSONEncoder().encode(newValue) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        } get {
            if let data = UserDefaults.standard.object(forKey: key) as? Data,
               let favorites = try? JSONDecoder().decode([Item].self, from: data) {
                 return favorites
            }
            
            return []
        }
    }
    
    func add(_ item: Item) {
        if favorites.isEmpty {
            favorites = [item]
        } else {
            favorites.append(item)
        }
    }
    
    func remove(_ item: Item) {
        guard let deleteIndex = favorites.firstIndex(where: { $0 == item }) else { return }
        favorites.remove(at: deleteIndex)
    }
}
