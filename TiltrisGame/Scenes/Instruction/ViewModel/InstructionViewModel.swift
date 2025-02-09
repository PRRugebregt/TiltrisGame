//
//  InstructionViewModel.swift
//  TiltrisGame
//
//  Created by Patrick Rugebregt on 09/02/2025.
//

import Foundation

protocol InstructionViewModelProtocol: AnyObject, ObservableObject {
    var titleText: String { get }
    var subtitleText: String { get }
    var buttonText: String { get }
}

class InstructionViewModel: InstructionViewModelProtocol {
    var titleText: String = "Rotate and tilt device"
    var subtitleText: String = "Try to get every piece in the correct bin with the correct rotation"
    var buttonText: String = "Let's play"
}
