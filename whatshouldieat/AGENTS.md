# Repository Guidelines

## Project Structure & Module Organization
- `whatshouldieat/` contains the SwiftUI app sources (for example, `ContentView.swift`, `whatshouldieatApp.swift`).
- `Assets.xcassets/` holds images, colors, and the app icon.
- `whatshouldieat.xcodeproj/` stores Xcode project metadata and build settings.
- Tests are not currently tracked. If you add them, follow Xcode conventions with `whatshouldieatTests/` and `whatshouldieatUITests/`.

## Build, Test, and Development Commands
- `open whatshouldieat.xcodeproj` opens the project in Xcode for running and debugging.
- `xcodebuild -scheme whatshouldieat -destination 'platform=iOS Simulator,name=iPhone 15' build` builds the app from the CLI.
- `xcodebuild -scheme whatshouldieat -destination 'platform=iOS Simulator,name=iPhone 15' test` runs tests once test targets exist.

## Coding Style & Naming Conventions
- Use Swift with 4-space indentation and no tabs; match existing formatting.
- Types and views use `PascalCase`; SwiftUI view names end with `View` (e.g., `MealPickerView`).
- Keep one primary type per file and name files to match the type they contain.
- Use descriptive `lowerCamelCase` names for assets (e.g., `primaryAccent`).

## Testing Guidelines
- Use `XCTest` and standard Xcode test targets.
- Name test classes `ThingTests` and test methods `testThingDoesX`.
- Prefer unit tests for logic and UI tests for critical flows only.

## Commit & Pull Request Guidelines
- Git history only contains "Initial Commit", so there is no established convention yet.
- Use short, imperative commit subjects (e.g., "Add meal picker view").
- PRs should include a clear summary, manual test steps, and screenshots for UI changes.

## Configuration & Secrets
- Prefer Xcode build settings or `.xcconfig` files for configuration values.
- Do not commit API keys or secrets; keep local overrides out of Git.
