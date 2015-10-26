/// A subscriber to the WebSocketManager
Class Namespace.REST.WebSocketSubscriber Extends %CSP.WebSocket
{

Property Subscriptions As list Of %String;

Method OnPreServer() As %Status
{
	Set ..SharedConnection = 1
 	Quit $$$OK
}

Method Server() As %Status
{
	For  
   		{
      		Set data= ..Read(, .status, )
			If $$$ISERR(status) 
			{
				If $$$GETERRORCODE(status) = $$$CSPWebSocketClosed 
				{
					Quit
				}
      		} else 
      		{
	         	Set action = $piece(data, ":", 1)
	         	Set subscription = $piece(data, ":", 2)
	         	If (action = "subscribe"){
		         	Do ..Subscribe(subscription)
		        }
		       	If (action = "unsubscribe"){
			       	Do ..Unsubscribe(subscription)
			    }
	         	
     	 	}
   		}
   	Set status = ..EndServer()
   	Quit $$$OK
}

Method OnPostServer() As %Status
{
	Do ..UnsubscribeAll()
 	Quit $$$OK
}

Method Subscribe(Subscription) As %Status
{
	Set pubsub = ##class(Namespace.REST.WebSocketManager).Get()
	Do pubsub.Subscribe(Subscription, ..WebSocketID)
	
	Do ..Subscriptions.Insert(Subscription)
	
	Do ..Write("Subscribed to "_Subscription_" for "_..WebSocketID)
	Do ..Write("Remaining sockets: "_pubsub.SubscribersOf(Subscription).Serialize())
	
	Quit $$$OK
}

Method Unsubscribe(Subscription)
{
	//kill pubsub to get most current instance of it.
	//Should refactor .Get() code to that for us instead.
	Kill pubsub
	Set pubsub = ##class(Namespace.REST.WebSocketManager).Get()
	Do pubsub.Unsubscribe(Subscription, ..WebSocketID)
	
	Set index = ..Subscriptions.Find(Subscription)
	Do ..Subscriptions.RemoveAt(index)
	
	Do ..Write("Unsubscribed from "_Subscription_" for "_..WebSocketID)
	Do ..Write("Remaining sockets: "_pubsub.SubscribersOf(Subscription).Serialize())
	
	Quit $$$OK
}

Method UnsubscribeAll() As %Status
{
	Set x = 1
	Set size = ..Subscriptions.Count()
	Do {
		Set sub = ..Subscriptions.GetAt(x)
		Do ..Unsubscribe(sub)
	} While x <= size
}

}
