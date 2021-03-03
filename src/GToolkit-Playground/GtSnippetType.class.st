"
I represent a unique snippet type that is used in a context of the infinite list element.

I differentiate snippets by their class.

[[[
	GtSnippetType new snippet: (GtPharoSnippet new)
]]]

I am responsible for creation of Snippet element holders of the corresponding type
"
Class {
	#name : #GtSnippetType,
	#superclass : #BlInfiniteItemType,
	#instVars : [
		'snippet'
	],
	#category : #'GToolkit-Playground-Snippet - UI'
}

{ #category : #'instance creation' }
GtSnippetType class >> new [
	self error: 'Use of: instead'
]

{ #category : #'instance creation' }
GtSnippetType class >> of: aSnippet [
	^ self basicNew
		snippet: aSnippet;
		initialize;
		yourself
]

{ #category : #comparing }
GtSnippetType >> = anotherSnippetType [
	^ self snippet class = anotherSnippetType snippet class
]

{ #category : #comparing }
GtSnippetType >> hash [
	^ self snippet class hash
]

{ #category : #'instance creation' }
GtSnippetType >> newHolder [
	"Create a new instance of the snippet element holder for this snippet type"
	<return: #GtSnippetElementHolder>

	^ GtSnippetElementHolder type: self
]

{ #category : #'private - accessing' }
GtSnippetType >> snippet [
	<return: #GtSnippet>

	^ snippet
]

{ #category : #'private - accessing' }
GtSnippetType >> snippet: aGtSnippet [
	snippet := aGtSnippet
]

{ #category : #'api - accessing' }
GtSnippetType >> stencilBuilder [
	^ self snippet asStencilBuilder
]
