Class {
	#name : #GtSnippetStencilBuilder,
	#superclass : #BrStencilBuilder,
	#instVars : [
		'snippet'
	],
	#category : #'GToolkit-Playground-Snippet - Stencils'
}

{ #category : #testing }
GtSnippetStencilBuilder class >> isAbstract [
	^ self name = #GtSnippetStencilBuilder
]

{ #category : #'api - instantiation' }
GtSnippetStencilBuilder >> bind: aSnippet to: aSnippetElement [
	aSnippetElement snippet: aSnippet
]

{ #category : #'api - instantiation' }
GtSnippetStencilBuilder >> buildDefault [
	<return: #BlElement>

	^ GtSnippetElement new snippet: self snippet.
]

{ #category : #accessing }
GtSnippetStencilBuilder >> snippet [
	<return: #GtSnippet>
	^ snippet
]

{ #category : #accessing }
GtSnippetStencilBuilder >> snippet: aGtSnippet [
	self 
		assert: [ aGtSnippet notNil ] 
		description: [ 'Snippet must be non-nil' ].
	snippet := aGtSnippet
]
