Class {
	#name : #GtUrlGetResponseCommand,
	#superclass : #GtDecoratedSnippetCommand,
	#instVars : [
		'response'
	],
	#category : #'GToolkit-Playground-Commands'
}

{ #category : #execution }
GtUrlGetResponseCommand >> execute [
	"response := ZnEasy get: self snippet url"
	command 
		get: self snippet url;
		progressBlock: [ :anHTTPProgress | 
			self snippet announce: (GtSnippetProgressAnnouncement fromHTTPProgress: anHTTPProgress) ].
	command execute
]

{ #category : #initialization }
GtUrlGetResponseCommand >> initialize [
	super initialize.
	self command: GtZnClientCommand new.
]
