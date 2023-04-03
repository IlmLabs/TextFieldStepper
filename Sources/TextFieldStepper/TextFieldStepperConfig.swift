import SwiftUI

public struct TextFieldStepperConfig {
    var unit: String
    var label: String
    var increment: Int
    var minimum: Int
    var maximum: Int
    var decrementImage: TextFieldStepperImage
    var incrementImage: TextFieldStepperImage
    var declineImage: TextFieldStepperImage
    var confirmImage: TextFieldStepperImage
    var disabledColor: Color
    var labelOpacity: Double
    var labelColor: Color
    var valueColor: Color
    var shouldShowAlert: Bool
    var minimumDecimalPlaces: Int
    var maximumDecimalPlaces: Int

    public init (
        unit: String = "",
        label: String = "",
        increment: Int = 1,
        minimum: Int = 0,
        maximum: Int = 100,
        decrementImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "minus.circle.fill"),
        incrementImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "plus.circle.fill"),
        declineImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "xmark.circle.fill", color: Color.red),
        confirmImage: TextFieldStepperImage = TextFieldStepperImage(systemName: "checkmark.circle.fill", color: Color.green),
        disabledColor: Color = Color(UIColor.lightGray),
        labelOpacity: Double = 1.0,
        labelColor: Color = .primary,
        valueColor: Color = .primary,
        shouldShowAlert: Bool = true,
        minimumDecimalPlaces: Int = 0,
        maximumDecimalPlaces: Int = 8
    ) {
        self.unit = unit
        self.label = label
        self.increment = increment
        self.minimum = minimum
        self.maximum = maximum
        self.decrementImage = decrementImage
        self.incrementImage = incrementImage
        self.declineImage = declineImage
        self.confirmImage = confirmImage
        self.disabledColor = disabledColor
        self.labelOpacity = labelOpacity
        self.labelColor = labelColor
        self.valueColor = valueColor
        self.shouldShowAlert = shouldShowAlert
        self.minimumDecimalPlaces = minimumDecimalPlaces
        self.maximumDecimalPlaces = maximumDecimalPlaces
    }
}
