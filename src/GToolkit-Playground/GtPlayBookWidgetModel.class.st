Class {
	#name : #GtPlayBookWidgetModel,
	#superclass : #BrWidgetModel,
	#instVars : [
		'playBook'
	],
	#category : #'GToolkit-Playground-PlayBook - Model'
}

{ #category : #'announcement handling' }
GtPlayBookWidgetModel >> handlePlayBookChangeRequestedAnnouncement: aGtPlayBookChangeRequestedAnnoucement [
	self playBook: aGtPlayBookChangeRequestedAnnoucement newPlayBook
]

{ #category : #initialization }
GtPlayBookWidgetModel >> initialize [
	super initialize.
	playBook := GtPlayBook new.
	self subscribeToPlayBook.
]

{ #category : #hooks }
GtPlayBookWidgetModel >> initializeListeners [
	super initializeListeners.

	self when: GtPlayBookRequest reply: [ :aResponse | aResponse playBook: self playBook ]
]

{ #category : #notifying }
GtPlayBookWidgetModel >> notifyPlayBookChanged [
	self dispatchEvent: (GtPlayBookChanged new playBook: self playBook)
]

{ #category : #hooks }
GtPlayBookWidgetModel >> onInstalledIn: anElement [
	super onInstalledIn: anElement.
	self updateBindings.
]

{ #category : #hooks }
GtPlayBookWidgetModel >> onUninstalledIn: anElement [
	super onUninstalledIn: anElement.
	self removeBindings.
]

{ #category : #accessing }
GtPlayBookWidgetModel >> playBook [
	<return: #GtPlayBook>
	^ playBook
]

{ #category : #accessing }
GtPlayBookWidgetModel >> playBook: aGtPlayBook [
	self unsubscribeFromPlayBook.
	playBook := aGtPlayBook.
	self subscribeToPlayBook.
	self notifyPlayBookChanged.
]

{ #category : #defaults }
GtPlayBookWidgetModel >> playgroundVariableName [
	^ #'thisPlayground'
]

{ #category : #private }
GtPlayBookWidgetModel >> removeBindings [
	self playBook bindingsDo: [ :eachBinding | 
		eachBinding remove: self playgroundVariableName ].
]

{ #category : #subscriptions }
GtPlayBookWidgetModel >> subscribeToPlayBook [
	self playBook ifNil: [ ^ self ].
	self playBook
		when: GtPlayBookChangeRequestedAnnoucement
		send: #handlePlayBookChangeRequestedAnnouncement:
		to: self
		for: self.
	self updateBindings.
]

{ #category : #subscriptions }
GtPlayBookWidgetModel >> unsubscribeFromPlayBook [
	self playBook unsubscribe: self.
	self removeBindings.
]

{ #category : #private }
GtPlayBookWidgetModel >> updateBindings [
	self widgetDo: [ :aWidget | 
		self playBook bindingsDo: [ :eachBinding | 
			eachBinding at: self playgroundVariableName put: aWidget ] ].
]
