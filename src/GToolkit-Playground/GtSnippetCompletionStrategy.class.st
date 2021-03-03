Class {
	#name : #GtSnippetCompletionStrategy,
	#superclass : #GtPharoCompletionStrategy,
	#instVars : [
		'snippetVariables'
	],
	#category : #'GToolkit-Playground-Completion'
}

{ #category : #'initialize-release' }
GtSnippetCompletionStrategy >> initialize [
	super initialize.
	self isMethod: false.
	self hasImplicitVariables: true.
	snippetVariables := GtPrefixTree new
]

{ #category : #'private-variables' }
GtSnippetCompletionStrategy >> localVariablesFor: aVariableNode [
	| vars |
	vars := super localVariablesFor: aVariableNode.
	snippetVariables
		weightedDo: [ :each :weight | vars add: each weight: weight ].
	vars remove: aVariableNode source ifAbsent: [  ].
	^ vars
]

{ #category : #accessing }
GtSnippetCompletionStrategy >> snippetVariables [
	^ snippetVariables
]

{ #category : #accessing }
GtSnippetCompletionStrategy >> snippetVariables: anObject [
	snippetVariables := anObject
]
