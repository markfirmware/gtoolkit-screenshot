Class {
	#name : #GtMarkUnsuccessfullyEvaluatedCodeCommand,
	#superclass : #GtMarkEvaluatedCodeCommand,
	#category : #'GToolkit-Playground-Commands'
}

{ #category : #'api - execution' }
GtMarkUnsuccessfullyEvaluatedCodeCommand >> execute [
	| aSubText |
	self clearTextAttributes.
	aSubText := self textToStyle.
	aSubText isEmpty ifTrue: [ ^ self ].
	aSubText
		attribute:
			(GtPlaygroundEvaluatedCodeHighlightedAttribute new
				paint: (Color red)).
	aSubText
		attributes:
			{(GtPlaygroundDebugExceptionButtonAttribute new
				result: self result)}
		from: aSubText size
		to: aSubText size
]
