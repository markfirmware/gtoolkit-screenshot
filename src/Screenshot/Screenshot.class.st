Class {
	#name : #Screenshot,
	#superclass : #Object,
	#instVars : [
		'form',
		'profile',
		'root'
	],
	#classInstVars : [
		'repositories'
	],
	#category : #Screenshot
}

{ #category : #accessing }
Screenshot class >> take [
	^ self new take
]

{ #category : #accessing }
Screenshot >> json [
	^ STON toJsonString: profile
]

{ #category : #accessing }
Screenshot >> profileFor: i [
	| p |
	p := Dictionary new.
	(i respondsTo: #text)
		ifTrue: [ profile at: #text put: i text asString ]
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
Screenshot >> take [
	root :=  GtWorldElement allInstances first.
	form := root exportAsForm.
	profile := self profileFor: root
]
