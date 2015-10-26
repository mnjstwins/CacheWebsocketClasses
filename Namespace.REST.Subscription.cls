Class Namespace.REST.Subscription Extends %Persistent
{

Property WebSocketIds As list Of %String;

Method ContainsMember(WebsocketID) As %Boolean
{
	Set index = ..WebSocketIds.Find(WebsocketID)
	if (index = "") {
		Quit 0
	}
	Else {
		Quit 1	
	}
}

Method AddMember(WebsocketID) As %Status
{
	if ..ContainsMember(WebsocketID) {
		Quit $$$OK
	}
	Else {
		Do ..WebSocketIds.Insert(WebsocketID)
		Quit ..%Save()
	}
}

Method RemoveMember(WebsocketID) As %Status
{
	Set index = ..WebSocketIds.Find(WebsocketID)
	if (index = "") {
		Quit $$$OK	
	}
	Else { 
		Do ..WebSocketIds.RemoveAt(index)
		Quit ..%Save()
	}
}

Method IsEmpty() As %Boolean
{
	Set length = ..WebSocketIds.Count()
	if (length < 1 ) {
		Quit 1
	}
	Else {
		Quit 0	
	}
}

<Storage name="Default">
<Data name="SubscriptionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WebSocketIds</Value>
</Value>
</Data>
<DataLocation>^Namespace.REST.SubscriptionD</DataLocation>
<DefaultData>SubscriptionDefaultData</DefaultData>
<IdLocation>^Namespace.REST.SubscriptionD</IdLocation>
<IndexLocation>^Namespace.REST.SubscriptionI</IndexLocation>
<StreamLocation>^Namespace.REST.SubscriptionS</StreamLocation>
<Type>%Library.CacheStorage</Type>
</Storage>
}
