# ==============================================================================
# Makefile — workspace_flow (Focus App, macOS)
# ==============================================================================

.PHONY: run run-release build-runner build-runner-watch format analyze test test-architecture clean

# ------------------------------------------------------------------ Run
run:
	flutter run -d macos

run-release:
	flutter run -d macos --release

# ------------------------------------------------------------------ Codegen
build-runner:
	dart run build_runner build --delete-conflicting-outputs
	@make format

build-runner-watch:
	dart run build_runner watch --delete-conflicting-outputs

# ------------------------------------------------------------------ Quality
format:
	dart format .

analyze:
	flutter analyze

test:
	flutter test

test-architecture:
	flutter test test/architecture

clean:
	flutter clean
	flutter pub get
