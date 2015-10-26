/// Tests basic functionality of a singleton
Class Namespace.DESIGNPATTERNS.SingletonTest Extends %UnitTest.TestCase
{

Method OnAfterOneTest() As %Status
{
	Do ##class(Namespace.DESIGNPATTERNS.Singleton).%KillExtent()
	Do ##class(Namespace.DESIGNPATTERNS.PubSub).%KillExtent()
	Quit $$$OK
}

Method TestSingletonConstructor()
{
	Set singleton = ##class(Namespace.DESIGNPATTERNS.Singleton).%New()
	Do $$$AssertTrue(##class(Namespace.DESIGNPATTERNS.Singleton).%ExistsId(1), "Singleton is able to instantiate with ID of 1")
	Do $$$AssertStatusNotOK(##class(Namespace.DESIGNPATTERNS.Singleton).%New(), "Only 1 instance can be created")
}

Method TestSingletonGet()
{
	Set singleton = ##class(Namespace.DESIGNPATTERNS.Singleton).%New()
	Do $$$AssertEquals(##class(Namespace.DESIGNPATTERNS.Singleton).Get(), singleton, "Singleton Get() ClassMethod should return a reference to the singleton")
}

Method TestSingletonCreatesInstanceOnGet()
{
	Do $$$AssertNotTrue(##class(Namespace.DESIGNPATTERNS.Singleton).%ExistsId(1), "There should be no singleton instance to start with")
	Set singleton = ##class(Namespace.DESIGNPATTERNS.Singleton).Get()
	Do $$$AssertTrue(##class(Namespace.DESIGNPATTERNS.Singleton).%ExistsId(1), "Get method should create singleton instance if not already created")
}

Method TestSingletonSharesInfoAccrossInstances()
{
	Set singleton1 = ##class(Namespace.DESIGNPATTERNS.Singleton).Get()
	Set singleton2 = ##class(Namespace.DESIGNPATTERNS.Singleton).Get()
	Set singleton1.Value = "This should be shared"
	Do singleton1.%Save()
	Do $$$AssertEquals(singleton2.Value, "This should be shared", "Changes to a value in 1 instance of the singleton should be reflected in other instances of the singleton")
}

Method TestSingletonConstructorInheritance()
{
	Set pubSub = ##class(Namespace.DESIGNPATTERNS.PubSub).%New()
	Do $$$AssertTrue(##class(Namespace.DESIGNPATTERNS.PubSub).%ExistsId(1), "Inheriting class is able to instantiate with ID of 1")
	Do $$$AssertStatusNotOK(##class(Namespace.DESIGNPATTERNS.PubSub).%New(), "Only 1 instance can be created")
}

Method TestSingletonGetInheritance()
{
	Set pubSub = ##class(Namespace.DESIGNPATTERNS.PubSub).%New()
	Do $$$AssertEquals(##class(Namespace.DESIGNPATTERNS.PubSub).Get(), pubSub, "Inheriting class's Get() ClassMethod should return a reference to the singleton")
}

Method TestSingletonCreatesInstanceOnGetInheritance()
{
	Do $$$AssertNotTrue(##class(Namespace.DESIGNPATTERNS.PubSub).%ExistsId(1), "There should be no instance of the inheriting class to start with")
	Set pubSub = ##class(Namespace.DESIGNPATTERNS.PubSub).Get()
	Do $$$AssertTrue(##class(Namespace.DESIGNPATTERNS.PubSub).%ExistsId(1), "Get method should create an instance of the inheriting class if not already created")
}

Method TestSingletonSharesInfoAccrossInstancesInheritance()
{
	Set pubSub1 = ##class(Namespace.DESIGNPATTERNS.PubSub).Get()
	Set pubSub2 = ##class(Namespace.DESIGNPATTERNS.PubSub).Get()
	Set pubSub1.Value = "This should be shared"
	Do pubSub1.%Save()
	Do $$$AssertEquals(pubSub2.Value, "This should be shared", "Changes to a value in 1 instance of the inheriting class should be reflected in other instances of the inheriting class")
}

}
