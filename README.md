# CacheWebsocketClasses
A set of classes to perform basic websocket communication.

##WebSocketManager
A singleton object that holds an array of subscription categories. 
Call the subscribe() method with the subscription name and the Websocket ID to add a subscriber.
Call the unsubscribe() method with the subscription name and the Websocket ID to remove a client from that subscription.
Call the subscribersOf() method with the subscription name to get a list of all subscribers.
Call the broadcast() method with the subscription name and the message to brodcast to send that message to all subscribers.

##Router
A simple REST router, with one endpoint for demonstration purposes.
Send a get request to /broadcast with a subscription name and a message to call the WebsocketManager broadcast() method 
with those criteria.

##Subscription
A class for managing subscriptions
Call containsMember() with websocket ID to see if that client is already subscribed.
Call addMember() with websocket ID to add the client to the subscription.
Call removeMember() with websocket ID to remove the client from the subscription.
Call isEmpty() to determine if subscription is empty (used to help with cleanup/removal of empty subscriptions)

##WebSocketSubscriber
A class for managing the actual Websocket connections. Extends %CSP.Websocket
Call subscribe() with subscription name to subscribe to that category.
Call unsubscribe() with subscription name to unsubscribe to that category.
Call unsubscribeAll() to unsubscribe from all current subscriptions (automatically called during OnPostServer to cleanup after itself)

##WebSocketClient.csp
A simple CSP page to demostrate a subscription.

