# AWS Costs API

## Goals
The goals of this repository are to:
* House the application code for a .Net Core Web API, written in C#, from which clients can retrieve the balance of the Amazon Web Services (AWS) bill for the current month, for the account where the API is deployed.
* Demonstrate the use of Docker containers and AWS Fargate to host the API.
* Demonstrate the use of a Git-based workflow mechanism for creating a Continuous Integration and Continuous Deployment (CICD) pipeline using <a href="https://docs.github.com/en/free-pro-team@latest/actions/guides/about-continuous-integration" target="_blank">GitHub Actions</a>.
* Demonstrate the use of <a href="https://www.envoyproxy.io/" target="_blank">Envoy</a> to handle transient failures in a distributed system (such as HTTP/TCP connection <a href="https://www.envoyproxy.io/docs/envoy/latest/faq/configuration/timeouts#faq-configuration-timeouts" target="_blank">timeouts</a> and <a href="https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/upstream/circuit_breaking#arch-overview-circuit-break" target="_blank">circuit-breaking</a>) and improve observability via <a href="https://www.envoyproxy.io/docs/envoy/latest/intro/arch_overview/observability/tracing" target="_blank">distributed tracing</a>.


## <a name="cicd-pipeline"></a>Git-based Continuous Integration / Continuous Deployment (CICD) Pipeline

A CICD pipeline for the AWS Costs API has been build using GitHub Actions.

The pipeline is triggered automatically whenever:
<ol type="a">
  <li>A pull-request is created.</li>
  <li>A change is pushed to the main branch.</li>
</ol>

For more details, the GitHub workflow file is [here](.github/workflows/main.yml).
