Class {
	#name : #Screenshot,
	#superclass : #Object,
	#instVars : [
		'form',
		'profile'
	],
	#classInstVars : [
		'repositories'
	],
	#category : #Screenshot
}

{ #category : #accessing }
Screenshot class >> readFrom: fileName [
	| formAndTexts firstText |
	formAndTexts := PNGReadWriterWithTextChunks formAndTextFromFileNamed: fileName.
	firstText := formAndTexts value first value.
	^self new form: formAndTexts key; profile: (STON fromString: firstText); yourself
]

{ #category : #accessing }
Screenshot class >> take [
	^ self new take
]

{ #category : #accessing }
Screenshot >> form: anObject [
	form := anObject
]

{ #category : #accessing }
Screenshot >> json [
	^ STON toJsonString: profile
]

{ #category : #accessing }
Screenshot >> profile: anObject [
	profile := anObject
]

{ #category : #accessing }
Screenshot >> profileFor: i [
	| p |
	p := Dictionary new.
	(i respondsTo: #text)
		ifTrue: [ p at: #text put: i text asString ]
		ifFalse: [ | childProfiles |
			childProfiles := OrderedCollection new.
			i children
				do: [ :child | 
					| childProfile |
					childProfile := self profileFor: child.
					childProfile isEmpty
						ifFalse:
							[ childProfiles add: childProfile ] ].
			childProfiles isEmpty
				ifFalse:
					[ p at: #children put: childProfiles asArray ] ].
	p isEmpty
		ifFalse:
			[ p at: #className put: i class name ].
	^ p
]

{ #category : #accessing }
Screenshot >> saveOn: fileName [
PNGReadWriterWithTextChunks putForm: form onFileNamed:  
 fileName withTextChunksAsAssociations: (OrderedCollection with: #fullProfile -> self json)
]

{ #category : #accessing }
Screenshot >> take [
	| root1 |
	root1 :=  GtWorldElement allInstances first.
	form := root1 exportAsForm.
	profile := self profileFor: root1
]
