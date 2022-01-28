//
//  ContentView.swift
//  DiceRoller
//
//  Created by Christopher Fouts on 1/21/22.
//

import SwiftUI
import Combine

struct ContentView: View {
    
    private var diceSides = [4, 6, 8, 12, 20]
    
    var count = 0
    
    @State private var selectedSides = 6
    @State private var quantity = 1 // this is an index, not a value
    @State var dice = [Die]()
    @State private var firstRoll = true
    @State private var total = 0
    
    @State private var feedback = UINotificationFeedbackGenerator()
    
    
    // get notified when the timer completes
    let nc = NotificationCenter.default
    
    private var rollCompletedPublisher: AnyPublisher<Notification, Never> {
        NotificationCenter.default
            .publisher(for: .rollCompleted)
            .eraseToAnyPublisher()
    }
    
    private var publisher = NotificationCenter.default
        .publisher(for: .rollCompleted)
        .map { notification in
            return notification.userInfo
        }
       .receive(on: RunLoop.main)
    
    var body: some View {
        
        VStack{
            
            Spacer()
            
            Text("Dice Total: \(total)")
                .font(.headline)
                .onReceive(publisher) { notification in
                    sumDice()
                }
            
            ForEach(Array(stride(from: 0, to: dice.count, by: 2)), id: \.self) { index in
                if (index + 1 > dice.count - 1 ) {
                    DiceView(die: dice[index])
                } else {
                    HStack {
                        DiceView(die: dice[index])
                        DiceView(die: dice[index + 1])
                    }
                }

            }
            
            HStack {
                Picker("Number of Dice", selection: $quantity) {
                    ForEach(1 ..< 11) {
                        Text("\($0) dice")
                    }
                }
                .accentColor(.purple)
                
                Picker("Number of Sides", selection: $selectedSides) {
                    ForEach(diceSides, id: \.self) {
                        Text("\($0) sides")
                    }
                }
                .accentColor(.purple)
                
            }
            
            Spacer()
            
            Button("Tap to Roll") {
                generateDice()
                feedback.prepare()
            }
            .padding()
            .background(.purple)
            .foregroundColor(.white)
            .clipShape(Capsule())

        }
        .onAppear(perform: generateDice)
    }
    
    func generateDice() {
        guard quantity > 0 else { return }
        guard !firstRoll else {
            firstRoll = false
            return
        }
        
        dice = [Die]()
        for _ in 0...quantity {
            let die = Die(sides: selectedSides)
            dice.append(die)
        }
        
    }
    
    func sumDice() {
        var sum = 0
        for theDie in dice {
            sum += theDie.roll
        }
        total = sum
        feedback.notificationOccurred(.success)
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
