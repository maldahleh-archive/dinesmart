import Foundation

extension Collection {
    func safeGet(index: Index) -> Element? {
        return index >= startIndex && index < endIndex ? self[index] : nil
    }
}
