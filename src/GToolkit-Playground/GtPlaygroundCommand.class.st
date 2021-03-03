Class {
	#name : #GtPlaygroundCommand,
	#superclass : #BlTktCommand,
	#category : #'GToolkit-Playground-Commands'
}

{ #category : #testing }
GtPlaygroundCommand class >> isAbstract [
	^ self name = #GtPlaygroundCommand
]
