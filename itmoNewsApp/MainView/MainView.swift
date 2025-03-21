import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewModel: MainViewModel
    
    @State var showModal: Bool = false
    
    
    
    var body: some View {
        ScrollView {
            HStack {
                TextField("Search", text: $viewModel.text)
                    .monospaced()
                Button {
                    viewModel.handle(.onSearch(searchKey: viewModel.text))
                } label: {
                    Text("go")
                }
            }
            .padding()

            switch viewModel.state {
            case .loading:
                Spacer()
                    .frame(height: 200)
                Text("loading ...")
                    .foregroundStyle(Color.accentColor)
                    .monospaced()
                ProgressView()
                    .tint(Color.accentColor)
            case .loaded(let articles):
                if articles.isEmpty {
                    Spacer()
                    Text("there is no articles :c")
                        .foregroundStyle(Color.accentColor)
                        .monospaced()
                    Button("reload") {
                        viewModel.handle(.onReload)
                    }
                    .buttonStyle(.plain)
                    .foregroundStyle(Color.accentColor)
                    Spacer()
                } else {
                    VStack {
                        ForEach(articles, id: \.url) { item in
                            ZStack {
                                if
                                    let urlToImage = item.urlToImage,
                                    let url = URL(string: urlToImage)
                                {
                                    AsyncImage(
                                        url: url) { image in
                                            image
                                                .resizable()
                                        } placeholder: {
                                            Color.accentColor
                                        }
                                    
                                } else {
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundStyle(Color.accentColor)
                                }
                                
                                Color.black.opacity(0.4)
                                HStack {
                                    Spacer()
                                        .frame(width: 100)
                                    VStack(alignment: .leading) {
                                        Spacer()
                                        Text(item.title ?? "empty title")
                                            .font(.title3)
                                            .bold()
                                            .monospaced()
                                            .foregroundStyle(Color.white)
                                        if let description = item.description {
                                            Text(description)
                                                .monospaced()
                                                .foregroundStyle(Color.white)
                                                .padding(.top)
                                        }
                                    }
                                }.padding()
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .frame(height: 300)
                            .padding(.horizontal)
                            .onTapGesture {
                                viewModel.handle(.onTapOn(article: item))
                            }
                        }
                    }
                }
            case .error(let errorString):
                Spacer()
                Text("There is an error!")
                    .font(.title)
                    .foregroundStyle(Color.accentColor)
                    .monospaced()
                Text("\(errorString)")
                    .foregroundStyle(Color.accentColor)
                    .monospaced()
                Button("reload") {
                    viewModel.handle(.onReload)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color.accentColor)
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showModal) {
            DetailsView(viewModel: DetailsViewModel(viewModel.selectedArticle!))
        }
        .onAppear {
            viewModel.handle(.onAppear)
        }
    }
}
