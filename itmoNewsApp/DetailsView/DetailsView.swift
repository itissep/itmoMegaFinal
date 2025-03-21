import SwiftUI

struct DetailsView: View {
    
    @ObservedObject var viewModel: DetailsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                if
                    let urlToImage = viewModel.model.urlToImage,
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
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .frame(height: 300)
            
            Text(viewModel.model.title ?? "empty title")
                .font(.title3)
                .bold()
                .monospaced()
            if let description = viewModel.model.description {
                Text(description)
                    .monospaced()
                    .padding(.top)
            }
            Spacer()
        }
        .padding()
    }
}
