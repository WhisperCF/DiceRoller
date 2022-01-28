//
//  DiceView.swift
//  DiceRoller
//
//  Created by Christopher Fouts on 1/24/22.
//

import SwiftUI

struct DiceView: View {
    var die: Die
    var colors: [Color] = [.red, .blue, .green, .orange, .pink, .purple]
    @State var currentFace = 1
    @State var counter = 0
    
    @State var currentDate = Date()
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()
    
    var body: some View {

        ZStack {
            Circle()
                .strokeBorder(style: StrokeStyle(lineWidth: 10.0))
                .foregroundColor(colors.randomElement())
                .padding()
            Text("\(currentFace)")
                .font(.largeTitle)
                .onReceive(timer) { input in
                    currentFace = Int.random(in: 1...die.sides)
                    counter += 1
                    if counter > 10 {
                        currentFace = die.roll
                        timer.upstream.connect().cancel()
                        counter = 0
                        
                        let nc = NotificationCenter.default
                        nc.post(name: .rollCompleted, object: nil)
                    }
                }
        }
        .frame(height: 130)
                

        
        
    }
}

struct DiceView_Previews: PreviewProvider {
    static var previews: some View {
        let die = Die(sides: 6)
        DiceView(die: die)
    }
}

extension Notification.Name {
    static let rollCompleted = Notification.Name("RollCompleted")
}
