Class Namespace.REST.WebSocketSubscriberTest Extends %UnitTest.TestCase
{

Method OnAfterOneTest() As %Status
{
		Do ##class(Namespace.REST.WebSocketManager).%KillExtent()
		Do ##class(Namespace.REST.WebSocketSubscriber).%KillExtent()
		Quit $$$OK
}

Method TestSubscriptionSave()
{
		Set ws = ##class(Namespace.REST.WebSocketSubscriber).%New()
		Set pubsub = ##class(Namespace.REST.WebSocketManager).Get()
		
		Do ws.Subscribe(pubsub, "TEST")
		
		Do $$$AssertEquals(pubsub.SubscribersOf("TEST").GetAt(1), ws, "Manager should save ws")
}

}
