@echo off
echo Setting up Flutter project...
echo.

echo Step 1: Cleaning project...
if exist .dart_tool rmdir /s /q .dart_tool
if exist build rmdir /s /q build
if exist pubspec.lock del /f pubspec.lock

echo Step 2: Getting Flutter packages...
flutter pub get

echo Step 3: Creating platform support...
flutter create . --project-name restaurant_order_system

echo Step 4: Getting packages again...
flutter pub get

echo.
echo Setup complete! You can now run: flutter run
pause
