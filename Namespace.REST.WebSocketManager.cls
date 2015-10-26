/// A singleton class to manage Pub-Sub for Websocket connections
Class Namespace.REST.WebSocketManager Extends Namespace.DESIGNPATTERNS.Singleton
{

Property Subscriptions As array Of Namespace.REST.Subscription;

Method Subscribe(Subscription As %String, WebSocketId As %String) As %Status
{
	Set sub = ..Subscriptions.GetAt(Subscription)
	if (sub = "") {
		Set sub = ##class(Namespace.REST.Subscription).%New()
	}	
	Do sub.AddMember(WebSocketId)
	Do ..Subscriptions.SetAt(sub, Subscription)
	Quit ..%Save()
}

Method Unsubscribe(Subscription As %String, WebSocketId As %String) As %Status
{
	Set sub = ..Subscriptions.GetAt(Subscription)
	if (sub = "") {
		Quit $$$OK	
	}
	Do sub.RemoveMember(WebSocketId)
	If (sub.IsEmpty()){
		//clean up array
		Do ..RemoveSubscription(Subscription)
	}
	Quit ..%Save()
}

Method RemoveSubscription(Subscription As %String) As %Status
{
	Do ..Subscriptions.RemoveAt(Subscription)
	Quit ..%Save()
}

// need to add broadcast method and unit test

Method SubscribersOf(Subscription As %String) As %List
{
	Set sub = ..Subscriptions.GetAt(Subscription)
	if (sub = "")
	{
		Quit $$$ERROR($$$GeneralError, "Subscription not found")	
	}
	Set subscribers = sub.WebSocketIds
	Quit subscribers
}

Method Broadcast(Subscription As %String, Message As %String) As %Status
{
	Set subscribers = ..SubscribersOf(Subscription)
	If subscribers = $$$ERROR($$$GeneralError, "Subscription not found"){
		Quit $$$ERROR($$$GeneralError, "Subscription not found")	
	}
	If (subscribers.Count() = 0){
		Quit $$$OK	
	}
	Set x=1
	Set ws = ##class(%CSP.WebSocket).%New()
	Set sent = ""
	Do {
		Set WebSocketId = subscribers.GetAt(x)
		Do ws.OpenServer(WebSocketId)
		Set %status = ws.OpenServer(WebSocketId)
		Set %status = ws.Write(Message)
		//Todo: work on method for handling errors when status is not ok.
		//possibly unsubscribe faulty websockets.
		if (%status '= $$$OK){
			Do subscribers.RemoveAt(x)
		}
		Set x=x+1
	} While x<=subscribers.Count()
	
	if x<=subscribers.Count(){
		Quit $$$ERROR($$$GeneralError, "Error with broadcast")	
	}
	
	Quit $$$OK
}

<Storage name="Default">
<Data name="Subscriptions">
<Attribute>Subscriptions</Attribute>
<Structure>subnode</Structure>
<Subscript>"Namespace.REST.WebSocketManager.Subscriptions"</Subscript>
</Data>
<Type>%Library.CacheStorage</Type>
</Storage>
}
