Class {
	#name : #GtMarkEvaluatedCodeCommand,
	#superclass : #GtTextEditorCommand,
	#instVars : [
		'result'
	],
	#category : #'GToolkit-Playground-Commands'
}

{ #category : #private }
GtMarkEvaluatedCodeCommand >> clearTextAttributes [
	self editor text
		clearAttributes: [ :each | 
			(each isKindOf: GtPlaygroundEvaluatedCodeHighlightedAttribute)
				or: [ each isKindOf: GtPlaygroundEvaluatedCodeButtonAttribute ] ]
]

{ #category : #accessing }
GtMarkEvaluatedCodeCommand >> result [
	"Return a command execution result"
	<return: #Object>
	^ result
]

{ #category : #accessing }
GtMarkEvaluatedCodeCommand >> result: anObject [
	result := anObject
]

{ #category : #private }
GtMarkEvaluatedCodeCommand >> textToStyle [
	<return: #BlRopedText>
	^ self editor hasSelection
		ifFalse: [ self editor text ]
		ifTrue: [ self editor text
				from: self editor selection from + 1
				to: self editor selection to ]
]
