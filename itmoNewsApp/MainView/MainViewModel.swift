import SwiftUI

class MainViewModel: ObservableObject {
    enum State {
        case loading
        case loaded(articles: [NewsArticle])
        case error(errorString: String)
    }
    
    enum Event {
        case onReload
        case onSearch(searchKey: String)
        case onTapOn(article: NewsArticle)
    }
    
    @Published var state: State = .loading
    @Published var showModal: Bool = false
    @Published var selectedArticle: NewsArticle?
    
    private var newsService: NewsService
    
    init(_ newsService: NewsService) {
        self.newsService = newsService
    }
    
    func handle(_ event: Event) {
        switch event {
        case .onReload:
            newsService.fetchData { [weak self] articles, error in
                DispatchQueue.main.async {
                    if let error {
                        self?.state = .error(errorString: error.localizedDescription)
                    } else {
                        self?.state = .loaded(articles: articles)
                    }
                }
            }
        case .onSearch(let searchKey):
            print("searched")
        case .onTapOn(let article):
            selectedArticle = article
            showModal = true
        }
    }
}
