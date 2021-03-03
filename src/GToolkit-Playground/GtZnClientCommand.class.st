Class {
	#name : #GtZnClientCommand,
	#superclass : #GtPlaygroundCommand,
	#instVars : [
		'client',
		'progressBlock',
		'response',
		'shouldContinue'
	],
	#category : #'GToolkit-Playground-Commands'
}

{ #category : #accessing }
GtZnClientCommand >> client [
	^ client
]

{ #category : #accessing }
GtZnClientCommand >> client: aZnClient [
	self 
		assert: [ aZnClient notNil ] 
		description: [ 'Zinc client must be non-nil' ].
	client := aZnClient
]

{ #category : #execution }
GtZnClientCommand >> execute [
	self 
		assert: [ self client notNil ]
		description: [ 'Zinc client must be initialized before execution' ].
	ZnSignalProgress 
		value: true
		during: [ 
			[ response := self client execute; response ]
			on: HTTPProgress 
			do: [ :anHTTPProgress | 
				self progressBlock cull: anHTTPProgress. 
				shouldContinue ifTrue: [ anHTTPProgress resume ] ] ]
]

{ #category : #accessing }
GtZnClientCommand >> get: aStringOrZnUrl [
	self 
		assert: [ aStringOrZnUrl notNil ] 
		description: [ 'URL must be non-nil' ].
	self client: (ZnClient new
		url: aStringOrZnUrl asZnUrl;
		method: #GET)
]

{ #category : #initialization }
GtZnClientCommand >> initialize [
	super initialize.
	client := nil.
	shouldContinue := true.
	progressBlock := [ :aHTTPProgress | "do nothing" ].
]

{ #category : #accessing }
GtZnClientCommand >> progressBlock [
	^ progressBlock
]

{ #category : #accessing }
GtZnClientCommand >> progressBlock: anOneArgBlock [
	self 
		assert: [ anOneArgBlock notNil ] 
		description: [ 'Progress block must be non-nil' ].
	progressBlock := anOneArgBlock
]

{ #category : #accessing }
GtZnClientCommand >> result [
	"Return a command execution result"
	<return: #ZnResponse or: nil>
	^ response
]

{ #category : #execution }
GtZnClientCommand >> terminationRequested [
	shouldContinue := false
]
