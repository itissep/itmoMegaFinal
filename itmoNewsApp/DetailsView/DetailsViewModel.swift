import SwiftUI

class DetailsViewModel: ObservableObject {
    
    @Published var model: NewsArticle
    
    init(_ model: NewsArticle) {
        self.model = model
    }
}
