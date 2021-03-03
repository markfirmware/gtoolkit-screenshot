Class {
	#name : #GtPageSnippetEvaluatedAnnouncement,
	#superclass : #GtPageSnippetAnnouncement,
	#instVars : [
		'result',
		'isException',
		'isSpawnResultRequested'
	],
	#category : #'GToolkit-Playground-Announcements'
}

{ #category : #accessing }
GtPageSnippetEvaluatedAnnouncement >> isException [
	^ isException
]

{ #category : #accessing }
GtPageSnippetEvaluatedAnnouncement >> isException: anObject [
	isException := anObject
]

{ #category : #accessing }
GtPageSnippetEvaluatedAnnouncement >> isSpawnResultRequested [
	^ isSpawnResultRequested
]

{ #category : #accessing }
GtPageSnippetEvaluatedAnnouncement >> isSpawnResultRequested: anObject [
	isSpawnResultRequested := anObject
]

{ #category : #accessing }
GtPageSnippetEvaluatedAnnouncement >> result [
	^ result
]

{ #category : #accessing }
GtPageSnippetEvaluatedAnnouncement >> result: anObject [
	result := anObject
]
