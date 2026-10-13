# Calculator State Lab

**Name:** Greena Nisheethkumar Patel  
**Course:** Mobile Application Development (CSC 6370)  
**Assignment:** 01 – Calculator State Lab

## About the Project

For this assignment, I created a calculator app using Flutter and Dart. The main goal was to understand how state management works in Flutter and how different button actions update the calculator.

The calculator performs basic arithmetic operations like addition, subtraction, multiplication, and division. It follows left-to-right calculations instead of the normal mathematical precedence rules. For example, when I enter 2 + 3 × 4, the answer is 20 instead of 14.

I also added some extra features to make the calculator easier to use.

## Features

- **Basic Operations:** The calculator supports addition, subtraction, multiplication, and division.
- **Decimal Numbers:** Users can enter decimal values and perform calculations with them.
- **Calculation History:** Previous calculations are saved in a history section. Users can tap a previous calculation to reuse its result or clear the history.
- **Backspace:** Users can delete digits if they enter a wrong number. Long-pressing backspace resets the calculator.
- **Error Handling:** The calculator displays an error message when users try to divide by zero or when a calculation produces an invalid result.
- **Clear Button:** The AC button resets the current calculation.
- **Running Total:** The calculator evaluates operations from left to right and updates the displayed result.

## Tools Used

I used Flutter and Dart to develop the application. I wrote the code in Visual Studio Code and tested the app using the iPhone simulator. I also used Git and GitHub to manage and upload my project.

## How to Run the App

First, clone the GitHub repository and open the project folder.

```bash
git clone https://github.com/greena-19/calculator_app.git
cd calculator_app
```

Install the required Flutter dependencies.

```bash
flutter pub get
```

Run the application.

```bash
flutter run
```

To generate the Android APK, use:

```bash
flutter build apk --release
```

## Testing

I tested the calculator with different inputs to check whether the calculations and state changes worked correctly.

| Test | Expected Result | Result |
|---|---|---|
| 2 + 3 × 4 | 20 | Passed |
| 9 + × 2 | 18 | Passed |
| 7 + = | 7 | Passed |
| 2.3 + 3.5 | 5.8 | Passed |
| 9.5 − 2.5 | 7 | Passed |
| 1.5 × 2 | 3 | Passed |
| 7.5 ÷ 2.5 | 3 | Passed |
| Division by zero | Error message | Passed |
| AC button | Reset to 0 | Passed |

I also checked that the completed calculations appeared in the history section.

## State Management

I used StatefulWidget and setState() to manage the calculator's changing values. The app keeps track of the current input, running total, and selected operator.

Whenever a button is pressed, the corresponding function updates the state and the display changes based on the new value.

## Challenges

One of the main challenges was handling multiple operations without using the normal operator precedence rules. I had to make sure that the calculator evaluated each operation from left to right.

Another important part was managing the calculator state after pressing equals, clear, or an operator multiple times. I tested different button sequences to check that the calculator behaved as expected.

## Conclusion

Through this assignment, I learned more about Flutter widgets, Dart functions, and state management. I also understood how important it is to handle different user inputs and test edge cases. Overall, this project helped me practice building an interactive mobile application using Flutter.
