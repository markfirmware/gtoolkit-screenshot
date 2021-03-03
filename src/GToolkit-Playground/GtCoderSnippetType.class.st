Class {
	#name : #GtCoderSnippetType,
	#superclass : #GtSnippetType,
	#category : #'GToolkit-Playground-Snippet - UI'
}

{ #category : #comparing }
GtCoderSnippetType >> = anotherSnippetType [
	^ self class = anotherSnippetType class and: [ self snippet = anotherSnippetType snippet ]
]

{ #category : #comparing }
GtCoderSnippetType >> hash [
	^ self class hash bitXor: self snippet hash
]
