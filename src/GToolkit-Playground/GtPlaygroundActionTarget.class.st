Class {
	#name : #GtPlaygroundActionTarget,
	#superclass : #GtPhlowActionTarget,
	#classInstVars : [
		'uniqueInstance'
	],
	#category : #'GToolkit-Playground-Page'
}

{ #category : #cleanup }
GtPlaygroundActionTarget class >> cleanUp [
	self resetUniqueInstance
]

{ #category : #cleanup }
GtPlaygroundActionTarget class >> resetUniqueInstance [
	uniqueInstance := nil
]

{ #category : #accessing }
GtPlaygroundActionTarget class >> uniqueInstance [
	^ uniqueInstance ifNil: [ uniqueInstance := self new ]
]
