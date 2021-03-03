"
I am a view model of all snippet widgets
"
Class {
	#name : #GtSnippetWidgetModel,
	#superclass : #BrWidgetModel,
	#instVars : [
		'snippet'
	],
	#category : #'GToolkit-Playground-Snippet - Model'
}

{ #category : #initialization }
GtSnippetWidgetModel >> initialize [
	super initialize.
	
	snippet := GtEmptySnippet uniqueInstance
]

{ #category : #hooks }
GtSnippetWidgetModel >> initializeListeners [
	super initializeListeners.

	self when: GtSnippetRequest reply: [ GtSnippetChanged new snippet: self snippet ].
	self registerToSnippet: self snippet.
]

{ #category : #notifying }
GtSnippetWidgetModel >> notifySnippetChanged [
	self dispatchEvent: (GtSnippetChanged new snippet: self snippet)
]

{ #category : #'api - hooks' }
GtSnippetWidgetModel >> onUninstalledIn: anElement [
	super onUninstalledIn: anElement.

	self unregisterFromSnippet: self snippet.
]

{ #category : #'announcement registration' }
GtSnippetWidgetModel >> registerToSnippet: aGtSnippet [
	self widgetDo: [ :aWidget | 
		self unregisterFromSnippet: aGtSnippet.
		aGtSnippet
			when: GtSnippetEvaluatedAnnouncement
			do: [ :anAnnouncement | 
				anAnnouncement isSpawnResultRequested ifTrue: [ 
					self
						fireEvent:
							(GLMBlocObjectToSelect new
								toSelect: anAnnouncement result;
								fromElement: aWidget).
					aWidget phlow spawnObject: anAnnouncement result ] ]
			for: self ]
]

{ #category : #accessing }
GtSnippetWidgetModel >> snippet [
	<return: #GtSnippet>

	^ snippet
]

{ #category : #accessing }
GtSnippetWidgetModel >> snippet: aGtSnippet [
	self unregisterFromSnippet: snippet.
	snippet := aGtSnippet.
	self registerToSnippet: aGtSnippet.
	self notifySnippetChanged.
]

{ #category : #'announcement registration' }
GtSnippetWidgetModel >> unregisterFromSnippet: aGtSnippet [
	aGtSnippet unsubscribe: self
]
