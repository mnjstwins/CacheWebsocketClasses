Class Namespace.REST.Router Extends %CSP.REST
{

XData UrlMap
{
<Routes>

<Route Url="/pubSubTest" Method="GET" Call="pubSubTest"/>

</Routes>
}

ClassMethod pubSubTest()
{
	Set pubSub = ##class(Namespace.REST.WebSocketManager).Get()
	SET subscription = %request.Data("subscription", 1)
	SET message = %request.Data("message", 1)
	Write subscription
	Write message
	Do pubSub.Broadcast(subscription, message)
	Quit $$$OK
}

}
