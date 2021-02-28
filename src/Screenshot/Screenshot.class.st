Class {
	#name : #Screenshot,
	#superclass : #Object,
	#classInstVars : [
		'repositories'
	],
	#category : #Screenshot
}

{ #category : #accessing }
Screenshot class >> jsonProfileFor: item [
	^ STON toJsonStringPretty: (Screenshot profileFor: item)
]

{ #category : #accessing }
Screenshot class >> profileFor: item [
	| profile |
	profile := Dictionary new.
	(item respondsTo: #text)
		ifTrue: [ profile at: #text put: item text asString ]
		ifFalse: [ | childProfiles |
			childProfiles := OrderedCollection new.
			item children
				do: [ :child | 
					| childProfile |
					childProfile := Screenshot profileFor: child.
					childProfile isEmpty
						ifFalse:
							[ childProfiles add: childProfile ] ].
			childProfiles isEmpty
				ifFalse:
					[ profile at: #children put: childProfiles asArray ] ].
	profile isEmpty
		ifFalse:
			[ profile at: #className put: item class name ].
	^ profile
]

{ #category : #accessing }
Screenshot class >> take [
	^ self jsonProfileFor: GtWorldElement allInstances first
]
