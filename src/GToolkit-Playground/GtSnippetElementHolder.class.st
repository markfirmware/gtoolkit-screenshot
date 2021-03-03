"
I hold a snippet element within an infinite list element.
I know my unique snippet type (pharo code, url, empty etc)
"
Class {
	#name : #GtSnippetElementHolder,
	#superclass : #BlInfiniteHolder,
	#instVars : [
		'snippetType'
	],
	#category : #'GToolkit-Playground-Snippet - UI'
}

{ #category : #'instance creation' }
GtSnippetElementHolder class >> new [
	self error: 'Use snippetType: instead'
]

{ #category : #'instance creation' }
GtSnippetElementHolder class >> type: aSnippetType [
	^ self basicNew
		snippetType: aSnippetType;
		initialize;
		yourself
]

{ #category : #initialization }
GtSnippetElementHolder >> initialize [
	super initialize.

	"create a default snippet element"
	itemElement := snippetType stencilBuilder asElement
]

{ #category : #'api - accessing' }
GtSnippetElementHolder >> snippet: aGtSnippet [
	"Change the snippet behind the snippet element.
	Snippet must be of the same type as the type if a snippet element"
	self
		assert: [ aGtSnippet snippetType = snippetType ]
		description: [ 'Must bind the same snippet type' ].

	snippetType stencilBuilder bind: aGtSnippet to: itemElement
]

{ #category : #private }
GtSnippetElementHolder >> snippetType [
	<return: #GtSnippetType>

	^ snippetType
]

{ #category : #private }
GtSnippetElementHolder >> snippetType: aSnippetType [
	snippetType := aSnippetType
]
