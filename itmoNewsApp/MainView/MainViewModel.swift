import SwiftUI
import SwiftData

class MainViewModel: ObservableObject {
    enum State {
        case loading
        case loaded(articles: [NewsArticle])
        case error(errorString: String)
    }
    
    enum Event {
        case onAppear
        case onReload
        case onSearch(searchKey: String)
        case onTapOn(article: NewsArticle)
    }
    
    @Published var state: State = .loading
    @Published var showModal: Bool = false
    @Published var selectedArticle: NewsArticle?
    
    @Published var text: String = ""
    
    private var newsService: NewsService
    private var modelContainer: ModelContainer
    
    init(_ newsService: NewsService, modelContainer: ModelContainer) {
        self.newsService = newsService
        self.modelContainer = modelContainer
    }
    
    @MainActor
    private func fetchCached() {
        do {
            let items = try modelContainer.mainContext.fetch(FetchDescriptor<NewsItem>())
                .map {
                    $0.toModel()
                }
            print("here appending \(items.count)")
            state = .loaded(articles: items)
        } catch {
            state = .error(errorString: "cache problem :c")
        }
    }
    
    @MainActor
    private func replaceCache(with articles: [NewsArticle]) {
        modelContainer.deleteAllData()
        articles.forEach { article in
            print("here creating")
            modelContainer.mainContext.insert(NewsItem(from: article))
        }
    }
    
    @MainActor
    func handle(_ event: Event) {
        switch event {
        case .onAppear:
            fetchCached()
            newsService.fetchData { [weak self] articles, error in
                DispatchQueue.main.async {
                    if let error {
                        self?.state = .error(errorString: error.localizedDescription)
                    } else {
                        self?.state = .loaded(articles: articles)
                        self?.replaceCache(with: articles)
                    }
                }
            }
        case .onReload:
            newsService.fetchData { [weak self] articles, error in
                DispatchQueue.main.async {
                    if let error {
                        self?.state = .error(errorString: error.localizedDescription)
                    } else {
                        self?.state = .loaded(articles: articles)
                        self?.replaceCache(with: articles) 
                    }
                }
            }
        case .onSearch(let searchKey):
            if searchKey == "" {
                newsService.fetchData { [weak self] articles, error in
                    DispatchQueue.main.async {
                        if let error {
                            self?.state = .error(errorString: error.localizedDescription)
                        } else {
                            self?.state = .loaded(articles: articles)
                            self?.replaceCache(with: articles)
                        }
                    }
                }
            } else {
                newsService.search(searchKey) { [weak self] articles, error in
                    DispatchQueue.main.async {
                        if let error {
                            self?.state = .error(errorString: error.localizedDescription)
                        } else {
                            self?.state = .loaded(articles: articles)
                            self?.replaceCache(with: articles)
                        }
                    }
                }
            }
        case .onTapOn(let article):
            selectedArticle = article
            showModal = true
        }
    }
}
