Class {
	#name : #GtDecoratedSnippetCommand,
	#superclass : #GtSnippetCommand,
	#instVars : [
		'command'
	],
	#category : #'GToolkit-Playground-Commands'
}

{ #category : #testing }
GtDecoratedSnippetCommand class >> isAbstract [
	^ self name = #GtDecoratedSnippetCommand 
]

{ #category : #accessing }
GtDecoratedSnippetCommand >> command [
	<return: #GtPlaygroundCommand>
	^ command
]

{ #category : #accessing }
GtDecoratedSnippetCommand >> command: aGtCommand [
	self 
		assert: [ aGtCommand notNil ] 
		description: [ 'Command to execute must be non-nil' ].
	command := aGtCommand
]

{ #category : #initialization }
GtDecoratedSnippetCommand >> initialize [
	super initialize.
	command := BlTktCommand null.
]

{ #category : #accessing }
GtDecoratedSnippetCommand >> result [
	"Return a command execution result"
	<return: #Object>
	^ command result
]
