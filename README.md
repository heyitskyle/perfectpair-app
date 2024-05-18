# The Perfect Pair App

## Overview

The Perfect Pair is an iOS application that utilizes machine learning to suggest food pairings. It leverages a large-scale food graph built on more than one million food recipes and information of 1,500 flavor molecules. The foundational data & research for this application is forked from [FlavorGraph](https://github.com/lamypark/FlavorGraph).

## Features

- **Food Pairing Suggestions**: The app provides food pairing suggestions based on the FlavorGraph model.
- **Ingredient Pairing Model**: The app includes an Ingredient Pairing Model that helps in suggesting the best food pairings, created with [PyTorch](https://github.com/pytorch/pytorch) and [Core ML Tools](https://github.com/apple/coremltools).

## Prerequisites

- Xcode
- Swift

## Setup

1. Clone the repository.
2. Open `ThePerfectPair.xcodeproj` in Xcode.
3. Build and run the project.

## Testing

The project includes unit tests for the Ingredient Pairing Model and other components. To run the tests, select `Product > Test` in Xcode.

## License

This project is not distributed under a public license at this stage. Stay tuned for updates!
