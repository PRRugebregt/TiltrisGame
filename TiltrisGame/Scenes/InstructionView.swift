//
//  InstructionView.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 07/02/2025.
//

import SwiftUI
import SpriteKit

struct InstructionView<ViewModel: InstructionViewModelProtocol>: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var instructionViewModel: ViewModel
    @State var showGame = false
    
    @State private var emptyGameScene = {
        GameScene.create(isEmpty: true)
    }()
    
    init(viewModel: @autoclosure @escaping () -> ViewModel) {
        self._instructionViewModel = StateObject(wrappedValue: viewModel())
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundStyle(.black)
                .ignoresSafeArea()
            SpriteView(scene: emptyGameScene)
            GeometryReader { geometry in
                VStack {
                    Text(instructionViewModel.titleText)
                        .foregroundStyle(.white)
                        .font(.title)
                    Text(instructionViewModel.subtitleText)
                        .foregroundStyle(Color.white.opacity(0.8))
                        .font(.title3)
                    HomeButtonView(text: instructionViewModel.buttonText, color: .yellow) {
                        coordinator.navigate(to: .game)
                    }
                    .frame(width: 300)
                    Spacer()
                }
                .rotatedView(geometry: geometry)
            }
        }
    }
}

extension View {
    func rotatedView(geometry: GeometryProxy) -> some View {
        modifier(RotatedView(geometry: geometry))
    }
}

struct RotatedView: ViewModifier {
    var geometry: GeometryProxy
    
    func body(content: Content) -> some View {
        content
            .frame(width: geometry.size.height, height: geometry.size.width)
            .padding()
            .rotationEffect(.degrees(270))
            .offset(
                x: (geometry.size.width - geometry.size.height) / 2,
                y: (geometry.size.height - geometry.size.width) / 2
            )
    }
}

protocol InstructionViewModelProtocol: AnyObject, ObservableObject {
    var titleText: String { get }
    var subtitleText: String { get }
    var buttonText: String { get }
    func startGame()
}

class InstructionViewModel: InstructionViewModelProtocol {
    var titleText: String = "Rotate and tilt device"
    var subtitleText: String = "Try to get every piece in the correct bin with the correct rotation"
    var buttonText: String = "Let's play"
    
    func startGame() {
        
    }
}

//#Preview {
//    InstructionView<InstructionViewModel>(viewModel: InstructionViewModel(), delegate: RootCoordinatorView())
//}
