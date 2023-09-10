---
title: "Using Github Actions with Private Repositories in the Same Organization: A Solution for Golang Projects"
date: 2023-09-10T00:57:08+02:00
draft: false
description: "This article explains how to use Github Actions for Go projects and addresses two common issues: reading from private repositories and installing Go packages. The solution involves creating a personal access token and adding it to an organization-wide token with read access to repositories and their contents, and logging in to the git user for Go using the `little-core-labs/netrc-creds@master` Github Actions script. The article provides YAML code examples for implementing these solutions."
type: "blog"
tags: ["Github Actions"]
best: true
toc: true
images:
  - /og-images/golang.jpeg
series:
  - Data Warehouse
cover: "images/github-actions/golang.jpeg"
---

I have been struggling with Github Actions for a couple of hours now. My problem is that Github Actions cannot read from private repositories in the same organization. Additionally, I have been unable to install Go packages because Git does not know which username and password to use. This post describes a solution to these issues.

For a hobby project, my friend and I have an organization where we store all our code. We use re-usable Github Actions workflows that are reused within all Go repositories. Our actions include running lints, security checks, and tests. We also have one repository named "go-utils", which contains a bunch of self-developed packages that can be used for different things, such as uploading images to Cloudflare R2. However, since this is a private repository, other repositories are unable to download it unless we either buy Github Enterprise (which is not feasible) or purchase Github Teams and create a Personal access token.

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

This error occurred because we needed to log in to our git user for GO as well. If git is now using ssh, it uses `.NETRC` to store passwords and usernames for some cases. We used another Github Actions script called `little-core-labs/netrc-creds@master` to log in our git user. We passed in our personal access token and other required information as parameters, as shown in the following YAML code:

```yaml
name: Apply netrc creds with direct input
uses: little-core-labs/netrc-creds@master
with:
	machine: github.com
	login: x-oauth-basic
	password: ${{ secrets.token }}

```

After this, we were able to use `go mod vendor` within our Github Action.

Here's the full setup script:

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

