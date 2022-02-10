# GoogleBooks

Example Project to show the use of SwiftUI to search the Google Book API and displays the result in a list . Works on iOS and macOS and written in SwiftUi

Requires: XCode 13.1, Swift version 5, SwiftUI 3

Contains:

GoogleBooksApp.swift
The main entry point of the app

Models

BookResults.swift
Contains the results of the google search query, the model BookResults contains an array of items which are descriptions of Books. 
DownloadedFile.swift
The class representing a downloaded PDF file

Networking

Network.swift
General network and downloading handling classes
GoogleApi.swift
Class to handle the google Books API interaction

AppKit interaction views
PDFViewUI.swift
A wrapper around the PDFKit PDFView to alliw it work in SwiftUI in macOS
iOSPDFViewUI.swift
A wrapper around the PDFKit PDFView to alliw it work in SwiftUI in iOS

BookResultView.swift
This file contains the BookResult swiftUi view and subviews private to it, composited from the SearchableView, BookResults, BookListView and BottomBar views
PDFViewer.swift
View that downloads and displays the locally downloaded PDF








