Class Namespace.REST.WebSocketManagerTests Extends %UnitTest.TestCase
{

Method OnAfterOneTest() As %Status
{
	Do ##class(Namespace.REST.WebSocketManager).%KillExtent()
	Do ##class(Namespace.REST.Subscription).%KillExtent()
	Quit $$$OK
}

Method OnAfterAllTests() As %Status
{
	Set pubsub = ##class(Namespace.REST.WebSocketManager).Get()
	Do pubsub.Subscriptions.Clear()
	Do pubsub.%Save()
	K pubsub
	Do ##class(Namespace.REST.WebSocketManager).%KillExtent()
	Do ##class(Namespace.REST.Subscription).%KillExtent()
	Quit $$$OK
}

Method TestSubscribe()
{
	Set member = "member1"
	Set pubsub = ##class(Namespace.REST.WebSocketManager).Get()
	
	Do $$$AssertStatusOK(pubsub.Subscribe("The Washington Post", member), "Subscribe should return a status of OK")
	Do $$$AssertEquals(pubsub.Subscriptions.GetAt("The Washington Post").WebSocketIds.Count(), 1, "Subscription should have 1 member")
	
	Kill member
	
	set pubsub2 = ##class(Namespace.REST.WebSocketManager).Get()
	
	Do $$$AssertEquals(pubsub2.Subscriptions.GetAt("The Washington Post").WebSocketIds.GetAt(1), "member1", "Member should be saved")
}

Method TestRemoveSubscription()
{
	Set member = "member1"
	Set pubsub = ##class(Namespace.REST.WebSocketManager).Get()
	Do pubsub.Subscribe("test", "member1")
	Do $$$AssertTrue(pubsub.Subscriptions.IsDefined("test"), "subscription added")
	Do $$$AssertEquals(pubsub.Subscriptions.GetAt("test").WebSocketIds.GetAt(1), "member1", "member added to subscription")
	Do pubsub.RemoveSubscription("test")
	Do $$$AssertNotTrue(pubsub.Subscriptions.IsDefined("test"), "subscription removed")
}

Method TestUnsubscribe()
{
	Set member = "member1"
	Set pubsub = ##class(Namespace.REST.WebSocketManager).Get()
	
	Do $$$AssertNotTrue(pubsub.Subscriptions.IsDefined("The Times"), "Subscription should not be defined yet")
	Do pubsub.Subscribe("The Times", member)
	Do $$$AssertTrue(pubsub.Subscriptions.IsDefined("The Times"), "Subscription should be defined now")
	
	Do $$$AssertEquals(pubsub.Subscriptions.GetAt("The Times").WebSocketIds.GetAt(1), "member1", "The subscription should hold member 1")
	
	Do pubsub.Subscribe("The Times", "member2")
	Do $$$AssertEquals(pubsub.Subscriptions.GetAt("The Times").WebSocketIds.Count(), 2, "Pubsub should have a second member now")
	
	Do $$$AssertStatusOK(pubsub.Unsubscribe("The Times", "member1"), "Unsubscribe should be called with a status of OK")
	Do $$$AssertTrue(pubsub.Subscriptions.IsDefined("The Times"), "Pubsub should still have subscription after unsubscribe")
	Do $$$AssertEquals(pubsub.Subscriptions.GetAt("The Times").WebSocketIds.Count(), 1, "subscription should only have 1 member now")
	Do $$$AssertStatusOK(pubsub.Unsubscribe("The Times", "member2"), "Unsubscribe should be called on member 2 with status of OK")
	Do $$$AssertNotTrue(pubsub.Subscriptions.IsDefined("The Times"), "Empty subscription should not be defined")
}

Method TestSubscribersOf()
{
	Set member = "newMember"
	Set pubsub = ##class(Namespace.REST.WebSocketManager).Get()
	Do $$$AssertStatusOK(pubsub.Subscribe("The Times", member), "Subscribe should return status of OK")
	Do $$$AssertEquals(pubsub.SubscribersOf("The Times"), pubsub.Subscriptions.GetAt("The Times").WebSocketIds, "SubscribersOf should return subscription's websocketids")
	Do pubsub.Unsubscribe("The Times", member)
	Do $$$AssertNotTrue(pubsub.Subscriptions.IsDefined("The Times"), "Subscription should be empty after cleanup")
}

Method TestBroadcast()
{
	Set ws = ##class(%CSP.WebSocket).%New()
	Set wsId = ws.WebSocketID
	
	Set pubsub = ##class(Namespace.REST.WebSocketManager).Get()
	Do $$$AssertStatusOK(pubsub.Subscribe("sockets", wsId), "ws id added to socket subscription")
	Do $$$AssertStatusOK(pubsub.Broadcast("sockets", "test"), "broadcast should be run with a status of OK")
	
	Do pubsub.Unsubscribe("sockets", wsId)
}

}
