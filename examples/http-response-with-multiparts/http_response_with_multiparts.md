# Response With multiparts

Ballerina supports encoding and decoding multipart content in HTTP responses along with the nested parts.
When you request multiparts from an HTTP inbound response, you get an array of the parts of the body (an array of
entities). If the received parts contain nested parts, you can loop through the parent parts and get the child parts.<br/><br/>
For more information on the underlying module, 
see the [Mime module](https://docs.central.ballerina.io/ballerina/mime/latest/).

::: code http_response_with_multiparts.bal :::

::: out http_response_with_multiparts.client.out :::

::: out http_response_with_multiparts.server.out :::