Class {
	#name : #GtExampleSnippet,
	#superclass : #GtCodeSnippet,
	#instVars : [
		'coder'
	],
	#category : #'GToolkit-Playground-Model'
}

{ #category : #testing }
GtExampleSnippet class >> isUserSnippet [
	^ false
]

{ #category : #accessing }
GtExampleSnippet class >> typeName [
	"Return a playground snippet type name.
	It should be an unique name among all playground snippet types."
	<return: #String>

	^ 'example'
]

{ #category : #visitor }
GtExampleSnippet >> accept: aVisitor [
	self flag: 'TODO'.
]

{ #category : #converting }
GtExampleSnippet >> asElement [
	| aCoderElement |

	aCoderElement := coder asElement.
	aCoderElement margin: (BlInsets all: 0).
	
	^ BrFrame new
		vFitContent;
		hMatchParent;
		look: (GtSnippetContainerLook new snippet: self);
		addChild: aCoderElement
]

{ #category : #converting }
GtExampleSnippet >> asStencilBuilder [
	^ self
]

{ #category : #'api - instantiation' }
GtExampleSnippet >> bind: aSnippet to: aSnippetElement [
]

{ #category : #accessing }
GtExampleSnippet >> coder [
	^ coder
]

{ #category : #initialization }
GtExampleSnippet >> defaultStyler [
	^ BrRBTextStyler new
]

{ #category : #'announcement handling' }
GtExampleSnippet >> handleEditorChanges: anAnnouncement [
]

{ #category : #initialization }
GtExampleSnippet >> initialize [ 	
	coder := GtMethodCoder forClass: nil source: 'exampleMessageSelector
	<gtExample>
	^ self flag: ''TODO: return object'''.
	super initialize.
	
]

{ #category : #accessing }
GtExampleSnippet >> sourceCode [
	^ self text asString
]

{ #category : #accessing }
GtExampleSnippet >> sourceCode: aString [
	self coder source: aString
]

{ #category : #converting }
GtExampleSnippet >> stencilBuilderClass [
	"Return a stencil builder class that knows how to display a snippet in Bloc"
	<return: #GtSnippetStencilBuilder>
	^ nil
]

{ #category : #accessing }
GtExampleSnippet >> text [
	^ self coder sourceEditor text
]

{ #category : #updating }
GtExampleSnippet >> updateForCodeSnippet: sourceCode inClass: aClass [
	| indentedLines methodSource |
	indentedLines := String streamContents: [ :stream | 
		sourceCode asString linesDo: [ :aLine |
			stream 
				nextPut: Character tab;
				nextPutAll: aLine;
				nextPut: Character lf ] ].
	methodSource := 'exampleMessageSelector
	<gtExample>
', indentedLines, '	^ self flag: ''TODO: return object'''.
	coder 
		forClass: aClass 
		source: methodSource
]
