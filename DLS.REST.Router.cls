Class NAMESPACE.REST.Router Extends %CSP.REST
{

XData UrlMap
{
<Routes>

<Route Url="/broadcast" Method="GET" Call="Broadcast"/>

</Routes>
}

ClassMethod Broadcast()
{
	Set pubSub = ##class(NAMESPACE.REST.WebSocketManager).Get()
	SET subscription = %request.Data("subscription", 1)
	SET message = %request.Data("message", 1)
	Do pubSub.Broadcast(subscription, message)
	Quit $$$OK
}

}
