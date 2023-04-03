import SwiftUI

public struct TextFieldStepper: View {
    @Binding var intValue: Int
    
    @FocusState private var keyboardOpened
    
    @State private var confirmEdit = false
    @State private var textValue = ""
    @State private var showAlert = false
    @State private var cancelled = false
    @State private var confirmed = false
    @State private var defaultValue: Int = 0
    
    // Alert
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    private let config: TextFieldStepperConfig
    private let actionCheck: () -> Bool
    
    private var cancelButton: some View {
        Button(action: {
            textValue = formatTextValue(intValue)
            cancelled = true
            keyboardOpened = false
        }) {
            config.declineImage
        }
        .foregroundColor(config.declineImage.color)
    }
    
    private var confirmButton: some View {
        Button(action: {
            confirmed = true
            validateValue()
        }) {
            config.confirmImage
        }
        .foregroundColor(config.confirmImage.color)
    }
    
    private var decrementButton: some View {
        LongPressButton(
            intValue: $intValue,
            config: config,
            image: config.decrementImage,
            action: .decrement,
            actionCheck: actionCheck
        )
    }
    
    private var incrementButton: some View {
        LongPressButton(
            intValue: $intValue,
            config: config,
            image: config.incrementImage,
            action: .increment,
            actionCheck: actionCheck
        )
    }
    
    /**
     * init(intValue: Binding<Int>, unit: String, label: String, config: TextFieldStepperConfig)
     */
    public init(
        intValue: Binding<Int>,
        actionCheck: @escaping () -> Bool,
        unit: String? = nil,
        label: String? = nil,
        increment: Int? = nil,
        minimum: Int? = nil,
        maximum: Int? = nil,
        decrementImage: TextFieldStepperImage? = nil,
        incrementImage: TextFieldStepperImage? = nil,
        declineImage: TextFieldStepperImage? = nil,
        confirmImage: TextFieldStepperImage? = nil,
        disabledColor: Color? = nil,
        labelOpacity: Double? = nil,
        labelColor: Color? = nil,
        valueColor: Color? = nil,
        shouldShowAlert: Bool? = nil,
        minimumDecimalPlaces: Int? = nil,
        maximumDecimalPlaces: Int? = nil,
        config: TextFieldStepperConfig = TextFieldStepperConfig()
    ) {
        // Compose config
        var config = config
        config.unit = unit ?? config.unit
        config.label = label ?? config.label
        config.increment = increment ?? config.increment
        config.minimum = minimum ?? config.minimum
        config.maximum = maximum ?? config.maximum
        config.decrementImage = decrementImage ?? config.decrementImage
        config.incrementImage = incrementImage ?? config.incrementImage
        config.declineImage = declineImage ?? config.declineImage
        config.confirmImage = confirmImage ?? config.confirmImage
        config.disabledColor = disabledColor ?? config.disabledColor
        config.labelOpacity = labelOpacity ?? config.labelOpacity
        config.labelColor = labelColor ?? config.labelColor
        config.valueColor = valueColor ?? config.valueColor
        config.shouldShowAlert = shouldShowAlert ?? config.shouldShowAlert
        config.minimumDecimalPlaces = minimumDecimalPlaces ?? config.minimumDecimalPlaces
        config.maximumDecimalPlaces = maximumDecimalPlaces ?? config.maximumDecimalPlaces
        
        // Assign properties
        self._intValue = intValue
        self.actionCheck = actionCheck
        self.config = config
        
        // Set text value with State
        _textValue = State(initialValue: formatTextValue(intValue.wrappedValue))
        _defaultValue = State(initialValue: intValue.wrappedValue)
    }
    
    public var body: some View {
        HStack {
            ZStack {
                decrementButton.opacity(keyboardOpened ? 0 : 1)
                
                if keyboardOpened {
                    cancelButton
                }
            }
            
            VStack(spacing: 0) {
                TextField("", text: $textValue)
                    .focused($keyboardOpened)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 24, weight: .black))
                    .keyboardType(.numberPad)
                    .foregroundColor(config.valueColor)
                    .monospacedDigit()
                
                if !config.label.isEmpty {
                    Text(config.label)
                        .font(.footnote)
                        .fontWeight(.light)
                        .foregroundColor(config.labelColor)
                        .opacity(config.labelOpacity)
                }
            }
            
            // Right button
            ZStack {
                incrementButton.opacity(keyboardOpened ? 0 : 1)
                
                if keyboardOpened {
                    confirmButton
                }
            }
        }
        .onChange(of: keyboardOpened) { _ in
            if keyboardOpened {
                textValue = textValue.replacingOccurrences(of: config.unit, with: "")
            } else {
                if !confirmed {
                    validateValue()
                } else {
                    confirmed = false
                }
            }
        }
        .onChange(of: intValue) { _ in
            textValue = formatTextValue(intValue)
        }
        .alert(
            alertTitle,
            isPresented: $showAlert,
            actions: {},
            message: {
                Text(alertMessage)
            }
        )
    }
    
    private func formatTextValue(_ value: Int) -> String {
        var stringValue = String(format: "%d", value)
        return stringValue + config.unit
    }
    
    private func validateValue() {
        // Value for non confirm button taps
        var value = defaultValue
        
        // Reset alert status
        showAlert = false
        
        var shouldShowAlert = false
        
        // Confirm intValue is actually a Double
        if let textToInt = Int(textValue) {
            // 4. If intValue is less than config.minimum, throw Alert
            // 5. If intValue is greater than config.maximum, throw Alert
            if textToInt < config.minimum {
                alertTitle = config.label
                alertMessage = "Must be at least \(formatTextValue(Int(config.minimum)))."
                shouldShowAlert = true
                value = config.minimum
            }
            
            if textToInt > config.maximum {
                alertTitle = config.label
                alertMessage = "Must be at most \(formatTextValue(Int(config.maximum)))."
                shouldShowAlert = true
                value = config.maximum
            }
            
            // All checks passed, set the double value.
            if !shouldShowAlert {
                intValue = textToInt
                keyboardOpened = false
                
                // If intValue is unchanged, ensure the textValue is still formatted
                textValue = formatTextValue(textToInt)
            }
        } else {
            // 2. If more than one decimal, throw Alert
            // 3. If contains characters, throw Alert (hardware keyboard issue)
            // 6. If intValue is empty, throw Alert
            alertTitle = config.label
            alertMessage = "Must contain a valid number."
            shouldShowAlert = true
        }
        
        if shouldShowAlert && confirmed {
            showAlert = true
        }
        
        if shouldShowAlert && !confirmed {
            intValue = value
            textValue = formatTextValue(value)
            
            if config.shouldShowAlert {
                showAlert = true
            }
        }
    }
}
