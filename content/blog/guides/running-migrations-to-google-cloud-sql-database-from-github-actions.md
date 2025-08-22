---
title: "Running Migrations To Google Cloud SQL Database From Github Actions"
date: 2023-10-16T16:06:10+02:00
draft: false
description: "Running Migrations To Google Cloud SQL Database From Github Actions"
type: "blog"
tags: ["Github Actions", "Guide", "SQL Migrations"]
best: true
toc: false
cover:
  image: "images/google-cloud.jpg"
series:
  - Guides
---
For a hobby project, I am using Google Cloud as my hosting provider. Recently, I built a way to run migrations from GitHub actions to my Cloud SQL Database using DBmate. However, my database is running within a VPC, which makes it difficult to connect to the database as it is within a private network with a firewall that does not accept traffic from the outside world. Fortunately, I found three potential solutions to this issue.

The initial solution was to create a VPS and deploy a GitHub runner on it, connecting it to the VPC. Another option was to utilize https://github.com/myoung34/docker-github-actions-runner as a Cloud Run Job, also connected to the VPC. After evaluating these choices, I ultimately opted to use Google's cloud-sql-proxy for the time being. Configuring the cloud-sql-proxy was a bit challenging, and I will provide a detailed discussion of it in this post. The drawback of not employing a server/container that is connected to the VPC is that I require a public IP for my database, which is not ideal. I prefer to have my network secured and only expose the public-facing APIs to the internet.

I am writing this post because I couldn't find a good guide on how to set up the runner.

This is a copy of the Cloud SQL Auth Proxy description from Google Cloud's [website](https://cloud.google.com/sql/docs/postgres/sql-proxy).

The **Cloud SQL Auth Proxy** is a Cloud SQL connector that provides secure access to your instances without the need for [Authorized networks](https://cloud.google.com/sql/docs/postgres/configure-ip) or for configuring SSL.

The Cloud SQL Auth Proxy, along with [other Cloud SQL Connectors](https://cloud.google.com/sql/docs/postgres/connect-connectors), offers the following benefits:

- **Secure connections:** The Cloud SQL Auth Proxy automatically encrypts traffic to and from the database using TLS 1.3 with a 256-bit AES cipher. SSL certificates are used to verify client and server identities, and are independent of database protocols. You won't need to manage SSL certificates.
- **Easier connection authorization:** The Cloud SQL Auth Proxy uses IAM permissions to control who and what can connect to your Cloud SQL instances. As a result, the Cloud SQL Auth Proxy handles authentication with Cloud SQL, eliminating the need to provide static IP addresses.
- **IAM database authentication:** Optionally, the Cloud SQL Auth Proxy supports an automatic refresh of OAuth 2.0 access tokens. For more information about this functionality, refer to [Cloud SQL IAM database authentication](https://cloud.google.com/sql/docs/postgres/authentication).

The Cloud SQL Auth Proxy does not provide a new connectivity path; it relies on existing IP connectivity. To connect to a Cloud SQL instance using [private IP](https://cloud.google.com/sql/docs/postgres/private-ip), the Cloud SQL Auth Proxy must be on a resource with access to the same VPC network as the instance.

## Requirements

To allow GH actions to connect to your VPC and Cloud SQL, you need to meet the following requirements:

- IAM service account JSON with the `Cloud SQL Client` role. This value should be stored as a secret for the Github Action. It is important to only add the necessary roles and avoid any administration roles. For example, the service account should not have the ability to edit the database configuration.
- The Cloud SQL database needs to have a public IP, but it does not require any firewall rules to expose the server to the internet.

## Action steps

I’m posting the YAML steps directly. I talk about each step after

```yaml
jobs:
  database-migrations:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
      with:
        token: ${{ secrets.token }} // this is used to allow checkout to pull private repos
    
    - name: Apply netrc creds with direct input
      uses: little-core-labs/netrc-creds@master
      with:
        machine: github.com
        login: x-oauth-basic
        password: ${{ secrets.token }} // this is used to allow checkout to pull private repos
    
    - name: Google auth
      id: auth
      uses: google-github-actions/auth@v1
      with:
        token_format: 'access_token'
        access_token_lifetime: '120s'
        create_credentials_file: true
        credentials_json:  '${{ secrets.GCP_CREDENTIALS_JSON }}'
        service_account: '${{ secrets.GCP_SERVICE_ACCOUNT }}' 

    - name: Google Cloud SQL Proxy
      run: |-
        docker run -d --net host --name gce-cloudsql-proxy --restart on-failure --expose 5432 gcr.io/cloud-sql-connectors/cloud-sql-proxy:2.7.0 --run-connection-test -t ${{steps.auth.outputs.access_token}} project:europe-west1:database
    
    - name: Install DBmate
      run: |-
        sudo curl -fsSL -o /usr/local/bin/dbmate https://github.com/amacneil/dbmate/releases/latest/download/dbmate-linux-amd64
        sudo chmod +x /usr/local/bin/dbmate

    - name: Run Migrations
      run: |-
        dbmate --wait -d ./migrations --url "postgresql://postgres:postgres@localhost:5432/postgres?sslmode=disable" migrate

    - name: Print filtered logs on failure
      if: ${{ failure() }}
      run: docker logs gce-cloudsql-proxy | grep -v -E '(password|secret|credential|token|auth|key)' | sed -r 's/(mongodb|postgresql|mysql):\/\/[^:]+:[^@]+@/\1:\/\/[REDACTED]:[REDACTED]@/g'
```

I am refering to each step by it’s name:

### Google Auth

To set up authentication in the runner, you will need the IAM Service Account JSON. This JSON is later used to obtain a token. The token is necessary because `google-github-actions/auth@v1` applies policies to the JSON file, preventing you from mounting it onto the Docker container used for the Cloud SQL proxy. Additionally, the container is run as a daemon in the background, allowing you to connect to other steps.

In this step, the token lifetime is set to 120 seconds. A lower lifetime is better for security as most of security is all about lowering the holes and setting a short lifetime will increase risk for a short time. Also the default time for a token for this action is 1 hour and you shouldn't need 1 hour.

### Google Cloud SQL Proxy

In this step, you will run a container using the official Cloud SQL Proxy image. Run it as a daemon and connect the container to the host network to allow connection using `[localhost:5432](<http://localhost:5432>)`. Set a name for the container to retrieve logs from it later in case the setup fails. Also, expose port 5432, as this is the commonly used port for Postgres.

The arguments for the container are `--run-connection-test`, which tests the connection to the database, `-t` to enable token authentication and specify the token to use. The final argument is the full path (e.g., "project:europe-west1:database") for the Cloud SQL database. Here, "project" refers to the project name in GCP, "europe-west1" is the region where your database is located, and "database" is the name of the Cloud SQL database.

### Installing DBmate

I am using DBmate for migrations, and I find that it handles everything I need perfectly. You can use any migration tool you prefer, such as Prisma. The important thing is how you set up the connection to the database and that you have a connection.

### Run Migrations

This step may vary depending on the tool you are using. The important part in this step is the URL for the database. Since we have already set up a container that connects to our database, we can use `[localhost:5432](<http://localhost:5432>)` as the host for the database. In my case, the URL to the database is `postgresql://postgres:postgres@localhost:5432/postgres?sslmode=disable`. Here, `postgres:postgres` represents the username and password for the database, and `/postgres` is the name of the PostgreSQL database inside my Cloud SQL Database. Additionally, I have added `sslmode=disable` to disable the PostgreSQL SSL connection as it don't work without creating a cert for the proxy and the proxy already encrypts the connection. 

If your connection string to the database with a public host is `postgresql://postgres:password@10.0.0.0:5432/postgres?sslmode=disable`,
then you only need to change `10.0.0.0:5432` to `localhost:5432`.

### Print Filtered Logs on Failure

The final step is optional and is used to see logs from the docker container if something fails, while ensuring sensitive information is not exposed. `if: ${{ failure() }}` tells GitHub Actions to run this step only if previous steps fail. This approach can also be used for cleanups.

The command filters out any log lines containing sensitive keywords (password, secret, credential, token, auth, key) and redacts usernames and passwords from connection strings. This is crucial for security, as unfiltered logs might contain sensitive information that would be visible in the GitHub Actions run history.

For advanced security needs, consider:
1. Using GitHub's secret masking capabilities
2. Redirecting logs to a secure location with proper access controls
3. Using a dedicated log processing service that can automatically redact sensitive information

The reference to status checks can be found here: https://docs.github.com/en/actions/learn-github-actions/expressions#status-check-functions

## Improvements

There is one improvement that I think would be better: running a GH runner (or similar) inside the VPC, either via a VPS or Cloud Run Jobs. I would need to experiment with Cloud Run Jobs to see if it is suitable for this purpose. Currently, I am required to have a public IP, which I'm not a big fan of. I prefer to have my databases completely locked down and not accessible by traffic outside the VPC. However, since this is a hobby project, I chose to stick with the cheapest option, which is running it in GH actions since I'm already paying for that service. Adding another service would increase the cost.

## End

I hope this article helps you establish a secure connection to your database from GH actions or a similar tool. I referred to GH actions because that's what I used, but the important thing to understand from this article is how to set up a connection to the database. The runner is more of a tool, and most CI/CD systems work in a similar way today.

If you have any feedback, I would love to hear it! You can find me on X: https://x.com/emil_priver
