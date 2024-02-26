import SwiftUI
import AVFoundation

struct ContentView: View {
    @State private var welcome = ""
    @State private var imageName = ""
    @State private var lastImageNumber = -1
    @State private var lastSoundNumber = -1
    @State private var audioPlayer: AVAudioPlayer!
    @State private var soundIsOn = true
    var body: some View {
        ZStack{
            Rectangle()
                .fill(
                    Gradient(colors: [.blue, .yellow])
                )
                .ignoresSafeArea()
            VStack {
                
                let currentDate = Date()
                VStack
                {
                    Text("Welcome!")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .minimumScaleFactor(0.5)// scales font down
                        .multilineTextAlignment(.center)// helps align the text to the center
                        .foregroundColor(.red)
                        .frame(height: 150)
                        .frame(height: 50)// frame helps to keep the buttons fixed
                        .frame(maxWidth: .infinity)
                        .animation(.easeInOut(duration: 0.15), value: "Welcome!")
                    Text("Date: ")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(height: 50)
                    Text("\(currentDate)")
                        .font(.title)
                        .fontWeight(.heavy)
                        .minimumScaleFactor(0.5)// scales font down
                        .multilineTextAlignment(.center)// helps align the text to the center
                        .foregroundColor(.black)
                }
                .padding()
                
                
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(30)
                    .shadow(color: .black, radius: 12)
                    .imageScale(.large)
                    .animation(.default, value: "Welcome")
                    .padding(.all)
                
                
                Spacer()
                
                Button("Generate Quote"){
                    lastImageNumber = nonRepeatingRandom(lastNumber: lastImageNumber, upperBounds: 9)
                    imageName = "image\(lastImageNumber)"
                    
                    // Play sound when generating a quote
                    if soundIsOn {
                        lastSoundNumber = nonRepeatingRandom(lastNumber: lastSoundNumber, upperBounds: 5)
                        playSound(soundName: "sound\(lastSoundNumber)")
                    }
                    
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                
                HStack(){
                    Text("Play Sound")
                    Toggle("", isOn: $soundIsOn)
                        .labelsHidden()
                        .onChange(of: soundIsOn) { _ in
                            if audioPlayer != nil && audioPlayer.isPlaying {
                                audioPlayer.stop()
                            }
                        }
                        .padding()
                    
                }
            }
        }
    }
    
    // Function to generate a random number that is different from the last one
    func nonRepeatingRandom(lastNumber: Int, upperBounds: Int) -> Int {
        var newNumber: Int
        repeat {
            newNumber = Int.random(in: 0...upperBounds)
        } while newNumber == lastNumber
        return newNumber
    }
    
    func playSound(soundName: String) {
        guard let soundFile = NSDataAsset(name: soundName) else
        {
            print("😡 Could not read file names \(soundName)")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        }
        catch{
            print("😡 ERROR: \(error.localizedDescription)")
        }
    }
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
}
