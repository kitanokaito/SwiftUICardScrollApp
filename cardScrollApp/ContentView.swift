import SwiftUI
import Combine

class TimerHolder : ObservableObject {
  @Published var timer : Timer!
  @Published var textScaling: Bool = false
  
  func start() {
    self.timer?.invalidate()
    self.textScaling = !self.textScaling
    self.timer = Timer.scheduledTimer(withTimeInterval: 2.00, repeats: true) {
      _ in
      self.textScaling = !self.textScaling
    }
  }
}

struct ContentView: View {
  @EnvironmentObject var timerHolder : TimerHolder
  //  @State var textScaling: Bool = false
  // どのぐらいからカードが大きくなるか 1~2
  let boundTiming: CGFloat = 0.5
  let maxScale: CGFloat = 1.3
  let dWidth = UIScreen.main.bounds.width
  let dHalfWidth = UIScreen.main.bounds.width / 2
  
  var body: some View {
    ZStack {
      // 背景
      LinearGradient(
        gradient: Gradient(colors: [Color("lightblue"), Color("lightpurple")]),
        startPoint: .top,
        endPoint: .bottom
      )
        .edgesIgnoringSafeArea(.all)
      
      VStack(spacing: 0) {
        // タイトル
        Text("Select your first pokemon")
          .font(.system(size: 25))
          .foregroundColor(.black)
          .shadow(
            color: Color.black.opacity(0.4),
            radius: 3,
            x: 2,
            y: 2
        )
          .frame(
            height: 100
        )
          .scaleEffect(self.timerHolder.textScaling ? 1.3 : 1.0)
          .animation(.easeInOut(duration: 2.00))
          .padding(.bottom)
          .onAppear() {
            self.timerHolder.start()
        }
        
        // カードスクロール
        ScrollView(.horizontal, showsIndicators: false) {
          HStack(spacing: 40) {
            ForEach(0..<data.count) { index in
              // 拡大
              GeometryReader { geo in
                Card(index: index)
                  .scaleEffect(
                    max(
                      self.maxScale - abs(abs(geo.frame(in: .global).midX) - self.dHalfWidth) / self.dHalfWidth * self.maxScale * self.boundTiming
                      , 1.0
                    )
                )
              }
                
                // ペラペラ回転
                //              GeometryReader { geo in
                //                Card(index: index)
                //                  .rotation3DEffect(.degrees(-Double(geo.frame(in: .global).midX - dWidth / 2) / 10), axis: (x: 0, y: 1, z: 0))
                //              }
                .frame(
                  width: self.dWidth / 2.0 + 20
              )
            }
          }
          .padding(
            .horizontal,
            ((dWidth - (dWidth / 2.0 + 20)) / 2)
          )
        }
      }
    }
  }
}

struct Card: View {
  let index: Int
  let dWidth = UIScreen.main.bounds.width
  
  var body: some View {
    VStack(spacing: 0) {
      Image(data[index])
        .resizable()
      
      Text(data[index])
        .bold()
        .foregroundColor(.black)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .background(
          LinearGradient(
            gradient: Gradient(colors: [Color("lightblue"), Color("lightpurple")]),
            startPoint: .top,
            endPoint: .bottom
          )
      )
    }
    .frame(
      width: dWidth / 2.0,
      height: UIScreen.main.bounds.height / 2.5
    )
      .cornerRadius(40)
      .overlay(
        RoundedRectangle(cornerRadius: 40)
          .stroke(Color.black, lineWidth: 3)
    )
      .shadow(
        color: Color.black.opacity(0.4),
        radius: 5,
        x: 5,
        y: 5
    )
      .padding(10)
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}

let data = [
  "purin1",
  "purin2",
  "purin3",
  "purin4",
  "purin5",
  "purin6",
  "purin7",
  "purin8"
]
