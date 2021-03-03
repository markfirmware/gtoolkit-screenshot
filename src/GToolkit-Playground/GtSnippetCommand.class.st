Class {
	#name : #GtSnippetCommand,
	#superclass : #GtPlaygroundCommand,
	#instVars : [
		'snippet'
	],
	#category : #'GToolkit-Playground-Commands'
}

{ #category : #testing }
GtSnippetCommand class >> isAbstract [
	^ self name = #GtSnippetCommand
]

{ #category : #'api - execution' }
GtSnippetCommand class >> snippet: aGtSnippet [
	^ self new snippet: aGtSnippet
]

{ #category : #accessing }
GtSnippetCommand >> snippet [
	<return: #GtSnippet or: nil>
	^ snippet
]

{ #category : #accessing }
GtSnippetCommand >> snippet: aGtSnippet [
	self
		assert: [ aGtSnippet notNil ] 
		description: [ 'Snippet must be non-nil' ].
	snippet := aGtSnippet.
]
