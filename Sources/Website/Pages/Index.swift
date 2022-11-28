import ComputeUI

struct IndexPage: View {
    
    var body: some View {
        ScrollView {
            HTMLTitle("Home | Server Side Swift")
            VStack(alignment: .leading) {
                Text("Hello, World")
                    .font(.largeTitle)
                Text("Welcome to Server Side Swift Conf 2022")
                    .font(.subheadline)
                    .padding(.bottom, 20)
                Link("About Us", destination: .path("/about"))
                    .font(.body)
                    .foregroundColor(.blue)
            }
            .frame(idealWidth: 800, maxWidth: 800, alignment: .topLeading)
            .padding()
        }
    }
}