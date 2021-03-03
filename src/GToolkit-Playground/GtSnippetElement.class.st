"
I am the root element of a visual snippet representation
"
Class {
	#name : #GtSnippetElement,
	#superclass : #BlElement,
	#category : #'GToolkit-Playground-Snippet - UI'
}

{ #category : #initialization }
GtSnippetElement >> initialize [
	super initialize.

	self viewModel: (GtSnippetWidgetModel new)
]

{ #category : #'api - accessing' }
GtSnippetElement >> snippet [
	<return: #GtSnippet>

	^ self viewModel snippet
]

{ #category : #'api - accessing' }
GtSnippetElement >> snippet: aGtSnippet [
	self viewModel snippet: aGtSnippet
]
