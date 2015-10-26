/// A base class to implement the singleton pattern
Class Namespace.DESIGNPATTERNS.Singleton Extends %Persistent
{

/// The one allowed ID
Parameter UNIQUEID = 1;

/// the ID is the Key, for both object and relational access
Index Key On ID [ IdKey, PrimaryKey, Unique ];

Property ID As %Integer [ Private ];

/// This property will be kept in sync across multiple processes,
/// via its Setter/Getter.
Property Value As %String;

/// If the Value hasn't been modified by *this* process, reload the object 
Method ValueGet() As %String [ ServerOnly = 1 ]
{
	if '(..ValueIsModified()) { do ..%Reload() }
	quit i%Value
}

/// Save the object when Value changes
Method ValueSet(val As %String) As %Status [ ServerOnly = 1 ]
{
	set i%Value = val
	quit ..%Save()
}

/// %New() should only work once for this class. If the singleton
/// doesn't exist already, assign the special ID, call %Save().
/// Otherwise, return an error. Using "quit sc" controls
/// whether or not %New() returns an object, and *returning* sc
/// by reference allows the caller of %New() to know the reason for failure.
Method %OnNew(ByRef sc As %Status) As %Status [ Private, ServerOnly = 1 ]
{
	if '(..KeyExists(..#UNIQUEID)) {
	set ..ID = ..#UNIQUEID
	set sc = ..%Save()
}
	else {
	set sc =  $$$ERROR($$$GeneralError, "Can't instantiate directly")
}
	quit sc
}

/// Get() returns the singleton. If the object already exists
/// in the current process, calling %OpenId() again simply returns
/// a new reference to the same object.
/// If the singleton doesn't exist yet, it calls %New().
ClassMethod Get(ByRef sc As %Status) As Namespace.DESIGNPATTERNS.Singleton
{
	if '(..KeyExists(..#UNIQUEID)) {
	set singleton = ..%New(.sc)
}
	set singleton = ..%OpenId(..#UNIQUEID, , .sc)
	quit singleton
}

<Storage name="Default">
<Data name="SingletonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Value</Value>
</Value>
</Data>
<DataLocation>^Namespace.DESIGNPATTERNS.SingletonD</DataLocation>
<DefaultData>SingletonDefaultData</DefaultData>
<IdLocation>^Namespace.DESIGNPATTERNS.SingletonD</IdLocation>
<IndexLocation>^Namespace.DESIGNPATTERNS.SingletonI</IndexLocation>
<StreamLocation>^Namespace.DESIGNPATTERNS.SingletonS</StreamLocation>
<Type>%Library.CacheStorage</Type>
</Storage>
}
