# GoogleBooks

Example Project to show the use of SwiftUI to search the Google Book API and displays the result in a list . Works on iOS and macOS and written in SwiftUi

Requires: XCode 13.1, Swift version 5, SwiftUI 3

## Contains:

#### GoogleBooksApp.swift
- The main entry point of the app

### Models

#### BookResults.swift
- Contains the results of the google search query, the model BookResults contains an array of items which are descriptions of Books. 
#### DownloadedFile.swift
- DownloadedFile is the  class representing a downloaded PDF file

### Networking

#### Network.swift
- General network and downloading handling classes
#### GoogleApi.swift
- Class to handle the google Books API interaction

### AppKit interaction views
#### PDFViewUI.swift
- A wrapper around the PDFKit PDFView to alliw it work in SwiftUI in macOS
#### iOSPDFViewUI.swift
- A wrapper around the PDFKit PDFView to alliw it work in SwiftUI in iOS

### Views

#### BookResultView.swift
- This file contains the BookResult swiftUi view and subviews private to it, composited from the SearchableView, BookResults, BookListView and BottomBar views
####PDFViewer.swift
- View that downloads and displays the locally downloaded PDF


### Tests
#### GoogleBooksTests.swift

- Tests: Mostly network and google search API integration and unit testing.

iOS screen.

<img width="488" alt="iOS" src="https://user-images.githubusercontent.com/156072/153465552-b8bd3aa9-5680-43c1-8f1a-68e77da76c8c.png">


MacOS screen
<img width="1066" alt="Mac" src="https://user-images.githubusercontent.com/156072/153465525-d636a188-38a5-4cc9-9f5a-0f5152760f5c.png">








