import SwiftUI

struct LongPressButton: View {
    @Binding var intValue: Int
    
    @State private var timer: Timer? = nil
    @State private var isLongPressing = false
    
    enum Actions {
        case decrement,
             increment
    }
    
    let config: TextFieldStepperConfig
    let image: TextFieldStepperImage
    let action: Actions
    let actionCheck: () -> Bool
    
    var body: some View {
        Button(action: {
            if shouldPerformAction() {
                !isLongPressing ? updateIntValue() : invalidateLongPress()
            }
        }) {
            image
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.25).onEnded(startTimer)
        )
        .foregroundColor(!disableButton() ? image.color : config.disabledColor)
        .disabled(disableButton())
    }
    
    private func shouldPerformAction() -> Bool {
        if (intValue == 0 && action == .increment) || (intValue == 1 && action == .decrement) {
            return true
        }
        
        return actionCheck()
    }
    
    /**
     * Stops the long press
     */
    private func invalidateLongPress() {
        isLongPressing = false
        timer?.invalidate()
    }
    
    /**
     * Check if button should be enabled or not based on the action
     */
    private func disableButton() -> Bool {
        var shouldDisable = false
        
        switch action {
            case .decrement:
                shouldDisable = intValue <= config.minimum
            case .increment:
                shouldDisable = intValue >= config.maximum
        }
        
        return shouldDisable
    }
    
    /**
     * Starts the long press
     */
    private func startTimer(_ value: LongPressGesture.Value) {
        isLongPressing = true
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            // Perform action regardless of actual value
            updateIntValue()
            
            // If value after action is outside of constraints, stop long press
            if intValue <= config.minimum || intValue >= config.maximum {
                invalidateLongPress()
            }
        }
    }
    
    /**
     * Decreases or increases the doubleValue
     */
    private func updateIntValue() {
        var newValue: Int
        
        switch action {
            case .decrement:
                newValue = intValue - config.increment
            case .increment:
                newValue = intValue + config.increment
        }
        
        intValue = (config.minimum...config.maximum).contains(newValue) ? newValue : intValue
    }
}
