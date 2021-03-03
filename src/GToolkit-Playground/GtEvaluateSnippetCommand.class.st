Class {
	#name : #GtEvaluateSnippetCommand,
	#superclass : #GtDecoratedSnippetCommand,
	#category : #'GToolkit-Playground-Commands'
}

{ #category : #execution }
GtEvaluateSnippetCommand >> execute [
	^ command execute
]

{ #category : #initialization }
GtEvaluateSnippetCommand >> initialize [
	super initialize.
	self command: GtEvaluateSourceCodeCommand new.
]

{ #category : #accessing }
GtEvaluateSnippetCommand >> snippet: aGtSnippet [
	super snippet: aGtSnippet.
	command requestor: aGtSnippet.
	command sourceCode: aGtSnippet sourceCode.
	command variableBindings: aGtSnippet variableBindings.
	command receiver: aGtSnippet variableBindings receiver.
]
