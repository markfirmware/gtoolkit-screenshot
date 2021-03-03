Class {
	#name : #PNGReadWriterWithTextChunks,
	#superclass : #PNGReadWriter,
	#instVars : [
		'textChunks'
	],
	#category : #Screenshot
}

{ #category : #'image reading/writing' }
PNGReadWriterWithTextChunks class >> formAndTextFromFileNamed: fileName [ 
	"Answer a Form of the image stored (encoded) on the file with fileName.
	This will (normally) autodetect the format and delegate to the correct concrete subclass."
	
	"ImageReadWriter formFromFileNamed: 'test.png'"
	"ImageReadWriter formFromFileNamed: 'test.jpg'"
	
	^ fileName asFileReference 
		binaryReadStreamDo: [ :in | self formAndTextFromStream: in ]
]

{ #category : #'image reading/writing' }
PNGReadWriterWithTextChunks class >> formAndTextFromStream: aBinaryReadStream [
	"Answer a Form of the image stored on aBinaryReadStream.
	This will (normally) autodetect the format and delegate to the correct concrete subclass.
	Closes aBinaryReadStream when done."
	
	"ImageReadWriter formFromStream: 'test.png' asFileReference binaryReadStream"
	"ImageReadWriter formFromStream: 'test.jpg' asFileReference binaryReadStream"

	| positionableReadStream reader readerClass form |
	positionableReadStream := ZnPositionableReadStream on: aBinaryReadStream.
	readerClass := self readerClassFromStream: positionableReadStream.
	reader := readerClass new on: positionableReadStream.
	form := reader nextImage.
	aBinaryReadStream close.
	^ Dictionary newFromPairs: { #form . form . #attachments . reader textChunks }
]

{ #category : #accessing }
PNGReadWriterWithTextChunks class >> putForm: aForm onFileNamed: fileName withTextChunks: someTextChunks [ 

	
	"PNGReadWriter putForm: PolymorphSystemSettings pharoLogoForm onFileNamed: 'test.png'"
	"PluginBasedJPEGReadWriter putForm: PolymorphSystemSettings pharoLogoForm onFileNamed: 'test.jpg'"
	
	fileName asFileReference 
		binaryWriteStreamDo: [ :out | (self on: out) nextPutImage: aForm withTextChunks: someTextChunks ]
]

{ #category : #accessing }
PNGReadWriterWithTextChunks >> nextImage [
	textChunks := OrderedCollection new.
	bigEndian := EndianDetector isBigEndian.
	filtersSeen := Bag new.
	idatChunkStream := nil.
	transparentPixelValue := nil.
	unknownChunks := Set new.
	stream skip: 8.
	[ stream atEnd ] whileFalse: [ self processNextChunk ].
	"Set up our form"
	palette
		ifNotNil: [ "Dump the palette if it's the same as our standard palette"
			palette = (StandardColors copyFrom: 1 to: palette size)
				ifTrue: [ palette := nil ] ].
	(depth <= 8 and: [ palette notNil ])
		ifTrue: [ form := ColorForm extent: width @ height depth: depth.
			form colors: palette ]
		ifFalse: [ form := Form extent: width @ height depth: depth ].
	backColor ifNotNil: [ form fillColor: backColor ].
	idatChunkStream
		ifNil: [ self error: 'image data is missing' ]
		ifNotNil: [ self processIDATChunk ].
	unknownChunks isEmpty
		ifFalse:
			[ "Transcript show: ' ',unknownChunks asSortedCollection asArray printString." ].
	self debugging
		ifTrue: [ self crTrace: 'form = ' , form printString.
			self crTrace: 'colorType = ' , colorType printString.
			self crTrace: 'interlaceMethod = ' , interlaceMethod printString.
			self
				crTrace: 'filters = ' , filtersSeen sortedCounts asArray printString ].
	^ form
]

{ #category : #writing }
PNGReadWriterWithTextChunks >> nextPutImage: aForm [
	^self nextPutImage: aForm withTextChunks: #()
]

{ #category : #writing }
PNGReadWriterWithTextChunks >> nextPutImage: aForm interlace: aMethod filter: aFilterType [ 
	"Note: For now we keep it simple - interlace and filtering are simply ignored"

	| crcStream |
	bigEndian := EndianDetector isBigEndian.
	form := aForm.
	width := aForm width.
	height := aForm height.
	aForm depth <= 8 
		ifTrue: 
			[bitsPerChannel := aForm depth.
			colorType := 3.
			bytesPerScanline := (width * aForm depth + 7) // 8]
		ifFalse: 
			[bitsPerChannel := 8.
			colorType := 6.
			bytesPerScanline := width * 4].
	self writeFileSignature.
	crcStream := (ByteArray new: 1000) writeStream.
	crcStream resetToStart.
	self writeIHDRChunkOn: crcStream.
	self writeChunk: crcStream.
	form depth <= 8 
		ifTrue: 
			[crcStream resetToStart.
			self writePLTEChunkOn: crcStream.
			self writeChunk: crcStream.
			form isColorForm 
				ifTrue: 
					[crcStream resetToStart.
					self writeTRNSChunkOn: crcStream.
					self writeChunk: crcStream]].
	form depth = 16 
		ifTrue: 
			[crcStream resetToStart.
			self writeSBITChunkOn: crcStream.
			self writeChunk: crcStream].
	crcStream resetToStart.
	self writeIDATChunkOn: crcStream.
	self writeChunk: crcStream.
	crcStream resetToStart.
	textChunks do: [ :x |
		x writetEXtChunkOn: crcStream.
		self writeChunk: crcStream
	].
	crcStream resetToStart.
	self writeIENDChunkOn: crcStream.
	self writeChunk: crcStream
]

{ #category : #accessing }
PNGReadWriterWithTextChunks >> nextPutImage: aForm withTextChunks: someTextChunks [
	"Write out the given form. We're keeping it simple here, no interlacing, no filters."
	textChunks := someTextChunks.
	^self nextPutImage: aForm interlace: 0 filter: 0. "no filtering"
]

{ #category : #accessing }
PNGReadWriterWithTextChunks >> processNextChunk [
	| length chunkType crc chunkCrc |
	length := self nextLong.
	chunkType := (self next: 4) asString.
 	(chunk isNil or: [ chunk size ~= length ])
 		ifTrue: [ chunk := self next: length ]
 		ifFalse: [ stream next: length into: chunk startingAt: 1 ].
	chunkCrc := self nextLong bitXor: 4294967295.
	crc := self 
		updateCrc: 4294967295
		from: 1
		to: 4
		in: chunkType.
	crc := self 
		updateCrc: crc
		from: 1
		to: length
		in: chunk.
	crc = chunkCrc ifFalse: [ self error: 'PNGReadWriter crc error in chunk ' , chunkType ].
	chunkType = 'IEND' ifTrue: [ ^ self	"*should* be the last chunk" ].
	chunkType = 'sBIT' ifTrue: 
		[ ^ self processSBITChunk	"could indicate unusual sample depth in original" ].
	chunkType = 'gAMA' ifTrue: [ ^ self	"indicates gamma correction value" ].
	chunkType = 'bKGD' ifTrue: [ ^ self processBackgroundChunk ].
	chunkType = 'pHYs' ifTrue: [ ^ self processPhysicalPixelChunk ].
	chunkType = 'tRNS' ifTrue: [ ^ self processTransparencyChunk ].
	chunkType = 'IHDR' ifTrue: [ ^ self processIHDRChunk ].
	chunkType = 'PLTE' ifTrue: [ ^ self processPLTEChunk ].
	chunkType = 'tEXt' ifTrue: [ ^ self processtEXtChunk ].
	chunkType = 'IDAT' ifTrue: 
		[ "---since the compressed data can span multiple
		chunks, stitch them all together first. later,
		if memory is an issue, we need to figure out how
		to do this on the fly---"
 		idatChunkStream
 			ifNil: [ idatChunkStream := WriteStream with: chunk copy ]
 			ifNotNil: [ idatChunkStream nextPutAll: chunk ].
		^ self ].
	unknownChunks add: chunkType
]

{ #category : #accessing }
PNGReadWriterWithTextChunks >> processtEXtChunk [
	| keywordAndText |
	keywordAndText := chunk asString splitOn: Character null asString.
	textChunks add: (PNGtEXtChunk keyword: keywordAndText first text: keywordAndText second)
]

{ #category : #accessing }
PNGReadWriterWithTextChunks >> textChunks [
	^textChunks
]
