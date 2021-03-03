Class {
	#name : #GtTextEditorCommand,
	#superclass : #GtPlaygroundCommand,
	#instVars : [
		'editor'
	],
	#category : #'GToolkit-Playground-Commands'
}

{ #category : #testing }
GtTextEditorCommand class >> isAbstract [
	^ self name = #GtTextEditorCommand
]

{ #category : #accessing }
GtTextEditorCommand >> editor [
	<return: #BrTextEditor or: nil>
	^ editor
]

{ #category : #accessing }
GtTextEditorCommand >> editor: aBrTextEditor [
	self
		assert: [ aBrTextEditor notNil ]
		description: [ 'Text editor must be non-nil' ].
	editor := aBrTextEditor
]
