Class {
	#name : #GtSnippetEvaluatedAnnouncement,
	#superclass : #GtSnippetAnnoucement,
	#instVars : [
		'result',
		'isException',
		'isSpawnResultRequested'
	],
	#category : #'GToolkit-Playground-Announcements'
}

{ #category : #initialization }
GtSnippetEvaluatedAnnouncement >> initialize [
	super initialize.
	isException := false.
	result := nil.
	isSpawnResultRequested := false.
]

{ #category : #accessing }
GtSnippetEvaluatedAnnouncement >> isException [
	^ isException
]

{ #category : #accessing }
GtSnippetEvaluatedAnnouncement >> isException: anObject [
	isException := anObject
]

{ #category : #accessing }
GtSnippetEvaluatedAnnouncement >> isSpawnResultRequested [
	^ isSpawnResultRequested
]

{ #category : #accessing }
GtSnippetEvaluatedAnnouncement >> isSpawnResultRequested: aBoolean [
	isSpawnResultRequested := aBoolean
]

{ #category : #accessing }
GtSnippetEvaluatedAnnouncement >> result [
	^ result
]

{ #category : #accessing }
GtSnippetEvaluatedAnnouncement >> result: anObject [
	result := anObject
]
