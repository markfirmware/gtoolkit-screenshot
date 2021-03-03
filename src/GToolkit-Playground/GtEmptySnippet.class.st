"
I am a snippet without any content, actions, nothing... empty space.
Use me as a default one in widget models , stencils and UI
"
Class {
	#name : #GtEmptySnippet,
	#superclass : #GtSnippet,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'GToolkit-Playground-Model'
}

{ #category : #cleanup }
GtEmptySnippet class >> cleanUp [
	self reset
]

{ #category : #testing }
GtEmptySnippet class >> isUserSnippet [
	^ false
]

{ #category : #accessing }
GtEmptySnippet class >> reset [
	uniqueInstance := nil
]

{ #category : #accessing }
GtEmptySnippet class >> typeName [
	"Return a playground snippet type name.
	It should be an unique name among all playground snippet types."
	<return: #String>

	^ 'empty'
]

{ #category : #accessing }
GtEmptySnippet class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]
