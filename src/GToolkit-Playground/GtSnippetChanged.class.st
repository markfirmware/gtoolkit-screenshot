"
I am sent my snippet widget model when its snippet changes
"
Class {
	#name : #GtSnippetChanged,
	#superclass : #BrResponse,
	#instVars : [
		'snippet'
	],
	#category : #'GToolkit-Playground-Snippet - Model'
}

{ #category : #accessing }
GtSnippetChanged >> snippet [
	<return: #GtSnippet>

	^ snippet
]

{ #category : #accessing }
GtSnippetChanged >> snippet: aGtSnippet [
	snippet := aGtSnippet
]
