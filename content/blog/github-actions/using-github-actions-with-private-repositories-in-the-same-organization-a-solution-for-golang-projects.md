---
title: "Using Github Actions with Private Repositories in the Same Organization"
date: 2023-09-10T00:57:08+02:00
draft: false
description: "Learn how to use Github Actions with private repositories in the same organization for your Golang projects. This post provides a solution to the issue of Github Actions not being able to read from private repositories and Git not knowing which username and password to use. Follow the steps outlined in this post to be able to fetch and clone repositories and use go mod vendor without issues."
type: "blog"
tags: ["Github Actions", "Go"]
best: true
toc: true
images:
  - /og-images/golang.jpeg
series:
  - Data Warehouse
cover: "images/github-actions/golang.jpeg"
---
I have been struggling with Github Actions for a couple of hours now. My problem is that Github Actions cannot read from private repositories in the same organization. Additionally, I have been unable to install Go packages because Git does not know which username and password to use. This post describes a solution to these issues.

For a hobby project, my friend and I have an organization where we store all our code. We use re-usable Github Actions workflows that are reused within all Go repositories. Our actions include running lints, security checks, and tests. We also have one repository named “go-utils”, which contains a bunch of self-developed packages that can be used for different things, such as uploading images to Cloudflare R2. However, since this is a private repository, other repositories are unable to download it unless we either buy Github Enterprise (which is not feasible) or purchase Github Teams and create a Personal access token.

The problem in this post is not something unique to go. This would happen if you fetch a git repository for an npm package as well.

The solution we came up with was to create a personal access token and add it to an organization-wide token. This token only had read access to repositories and their contents.

To fetch other repositories and clone them into the runner while running our actions, we added this token as a parameter to `actions/checkout@v4`, as shown in the following YAML code:

```yaml
jobs:
	golang:
		runs-on: ubuntu-latest
		steps:
			- uses: actions/checkout@v4
				with:
				token: ${{ secrets.token }}

```

However, running our `go mod vendor` step produced the following error:

```yaml
fatal: could not read Username for '<https://github.com>': terminal prompts disabled
Confirm the import path was entered correctly.
If this is a private repository, see <https://golang.org/doc/faq#git_https> for additional information.

```

This error occurred because we needed to tell git which username and password we want to use for our https git calls. The reason why GO gave us this error is due to the fact that we are using a private Github repository as a go module, and GO needs to clone the repository to vendor before it is able to build the go project. As this is a private git repository, we also need to provide a username and password for the call; otherwise, we haven't authenticated ourselves. We are not able to use SSH, so we use standard HTTPS login, meaning we use `.NETRC` to store passwords and usernames. We used another Github Actions script called `little-core-labs/netrc-creds@master` to log in our git user. We passed in our personal access token and other required information as parameters, as shown in the following YAML code:

```yaml
name: Apply netrc creds with direct input
uses: little-core-labs/netrc-creds@master
with:
	machine: github.com
	login: x-oauth-basic
	password: ${{ secrets.token }}

```

After this, we were able to use `go mod vendor` within our Github Action.

Here’s the full setup script:

```yaml
jobs:
	golang:
		runs-on: ubuntu-latest
		steps:
		- name: Apply netrc creds with direct input
			uses: little-core-labs/netrc-creds@master
			with:
				machine: github.com
				login: x-oauth-basic
				password: ${{ secrets.token }}
		- uses: actions/checkout@v4
			with:
				token: ${{ secrets.token }}
		- name: Set up Go
			uses: actions/setup-go@v4
			with:
				go-version-file: 'go.mod'

```

Hope this tiny article might help you :D
