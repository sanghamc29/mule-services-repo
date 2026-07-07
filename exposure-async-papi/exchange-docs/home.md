> Please, provide your feedback.

# Mule 4 RESTful API Template

The API Template can be used as a foundation for any RESTful API. The template is not backward compatible with older Mule versions.

The API Template implements the following patterns:

  *  [Logging](#logging)  
  *  [Error Handling](#error-handling)
  *  [Management of properties](#management-of-properties)
  *  [APIkit Router](#apikit-router)
  *  [API Versioning](#api-versioning)
  *  [Maven Filtering](#maven-filtering)
  *  [MUnit](#munit)

### Logging

If API Manager is available, consider using the out of the box [Message Logging Policy](https://docs.mulesoft.com/api-manager/2.x/message-logging-policy)  instead of default logging implementation in API Template.

By default, basic request and response details are logged together with correlation id. Example of log could be found below:

<details><summary>Log sample - request</summary><p>
	
```
INFO  2018-09-24 16:20:08,329 [[MuleRuntime].cpuLight.13: [mule4-api-template].api-main.CPU_LITE @47e60054] [event: 0-52095011-c00d-11e8-9c42-88e9fe79ff25] org.mule.runtime.core.internal.processor.LoggerMessageProcessor: 'Transaction': 0-52095011-c00d-11e8-9c42-88e9fe79ff25 'HTTP Method': GET 'URI': /api/mule4-api-template/v1/customers/1
```

</p></details>

<details><summary>Log sample - response</summary><p>
	
```
INFO  2018-09-24 16:20:08,484 [[MuleRuntime].cpuLight.13: [mule4-api-template].api-main.CPU_LITE @47e60054] [event: 0-52095011-c00d-11e8-9c42-88e9fe79ff25] org.mule.runtime.core.internal.processor.LoggerMessageProcessor: 'Transaction': 0-52095011-c00d-11e8-9c42-88e9fe79ff25 'Response HTTP Status': 200
```

</p></details>
<p></p>

There is no payload logged to avoid logging sensitive data.

### Error Handling

Implemented in `error-handling.xml`.

Most of the main error types (Like `CONNECTIVITY`, `TRANSFORMATION`, `SCRIPTING`, `EXPRESSION`, `ROUTING`, `SECURITY`, and `ANY`) and some specific error types (`APIKIT:<>`, `HTTP:<>`, and `DB:<>`) are handled in the template. In most of the cases, there is no need to handle any more generic error types. In case of the specific use cases and requirements the default error handling can be tailored (within the implementation of specific API).

**Error Propagation**

The template also implements propagation of known exceptions. Known exceptions are business exceptions handled within APIs explicitly as reaction on some specific business scenario (unhappy path) and provided with specific error code `error.errorCode`.

For exception propagation to work the error code prefix must be agreed and used/configured across the whole API landscape. Prefix can be configured in `default-properties.yaml` property name `custom-error-code-prefix` with default value `ORG_MB`. Ensure that every custom business exception that must be propagated has a custom `error.errorCode` set with provided error code prefix.

When the propagation is useful: There is a business exception that should be propagated to a end consumer, e.g. System API captures the database exception saying that email address is already used and builds a specific error payload with details that should not be udpated or wrapped by exception handling in Process or Experience API. Details must be forwarded instead, so the end consumer can trigger the specific functionality tied to this exception scenario. The consumer uses `error.errorCode` in error payload to recognise the specific exception scenario.

### Management of properties

As per the official [MuleSoft recommendations](https://docs.mulesoft.com/mule4-user-guide/v/4.1/intro-configuration) the template does not contain environment specific properties. Only default properties file is available: `default-properties.yaml`.

Use Anypoint Runtime Manager to manage environment specific properties. Available options are: UI, APIs, Anypoint CLI.

### APIkit Router

The template follows the key recommendation to utilise APIkit router.

### API Versioning

API Version is included in API URI by configuring path of HTTP Listener. Path is configured via property `api.http.listener.path` in `default-properties.yaml`.

Example: http://localhost:8081/api/mule4-api-template/v1/customers/

Where: **v1** is API version and **mule4-api-template** is api name / artifact id (in pom.xml).

The following steps must be followed to increase the API version:
1. Update version in RAML specification (tag: version). Once done, new version of RAML must be imported into the project's workspace.
2. Update property in pom.xml file: `<api.build.version>`

### Maven Filtering

Maven filtering is utilised to enable auto-configuration of some of the properties like `application.name`, `api.version`, and `api.name` available in properties file.

Maven filtering uses `<artifactId>` from pom file to populate the `application.name` and `api.name`, and `<api.build.version>` to populate `api.version` during the build time.

Logger configuration (in `log4j2.xml`) also benefits from maven filtering. The log file name is defined during the build time as follows: `${sys:mule.home}${sys:file.separator}logs${sys:file.separator}${project.artifactId}-${api.build.version}.log`.

<details><summary>Configuration details in pom.xml</summary><p>
	
```xml
<!-- enable filtering to replace variables -->
<resources>
  <resource>
    <directory>src/main/resources</directory>
    <filtering>true</filtering>
  </resource>
</resources>
```

</p></details>


### MUnit

Basic MUnit test is implemented in the template. It can be used as a reference for future unit testing.

MUnit is configured to fail a build in case the application coverage and flow coverage is less than 80% (see the pom.xml for more details).

There is much more functionality and capabilities with [MUnit 2](https://docs.mulesoft.com/munit/2.1/) (the template implements only very basic example).

### API instance autodiscovery (API Manager)

The configuration is not implemented in the template. However, configuration file contains the attribute as a placeholder for API Instance ID: `api.instanceId: "configure-it-from-ARM"`.

API Instance must be configured from Anypoint Runtime Manager (other options are the platform APIs or Anypoint CLI). It is not recommended to maintain hardcoded instance id within the API package, as the API Instance ID is different in different environment.

## How to use API Template

1. Copy template
2. Refactor the project name
3. Update pom.xml
4. Update default.properties
5. Import API specification
6. Regenerate flows
7. Update configuration of APIkit router
