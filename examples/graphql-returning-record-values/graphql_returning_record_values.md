# Returning record values

In Ballerina GraphQL, a service represents the GraphQL endpoint.
Each resource function inside the service represents a resolver function for a field in the root Query type.<br/><br/>
For more information on the underlying package, see the
[GraphQL package](https://docs.central.ballerina.io/ballerina/graphql/latest/).<br/><br/>
This example shows a GraphQL endpoint, which has a field `profile` of type `Person`.
A GraphQL client can query on this service to retrieve specific fields or subfields of the `Person` object.

::: code graphql_returning_record_values.bal :::

::: out graphql_returning_record_values.client.out :::

::: out graphql_returning_record_values.server.out :::