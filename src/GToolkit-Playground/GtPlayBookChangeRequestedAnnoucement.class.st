Class {
	#name : #GtPlayBookChangeRequestedAnnoucement,
	#superclass : #Announcement,
	#traits : 'TGtAssert',
	#classTraits : 'TGtAssert classTrait',
	#instVars : [
		'oldPlayBook',
		'newPlayBook'
	],
	#category : #'GToolkit-Playground-Announcements'
}

{ #category : #accessing }
GtPlayBookChangeRequestedAnnoucement >> newPlayBook [
	^ newPlayBook
]

{ #category : #accessing }
GtPlayBookChangeRequestedAnnoucement >> newPlayBook: aGtPlayBook [
	self 
		assert: [ aGtPlayBook notNil ] 
		description: [ 'New PlayBook must be non-nil' ].
	newPlayBook := aGtPlayBook
]

{ #category : #accessing }
GtPlayBookChangeRequestedAnnoucement >> oldPlayBook [
	^ oldPlayBook
]

{ #category : #accessing }
GtPlayBookChangeRequestedAnnoucement >> oldPlayBook: aGtPlayBook [
	self 
		assert: [ aGtPlayBook notNil ] 
		description: [ 'Old PlayBook must be non-nil' ].
	oldPlayBook := aGtPlayBook
]
