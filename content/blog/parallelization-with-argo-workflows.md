---
title: "Parallelization With Argo Workflows"
date: 2024-08-19T15:06:10+02:00
draft: true
toc: true
description: How we process large files with Argo Workflows to improve parallelization
type: "blog"
tags: []
series:
- Rust
cover:
  image: "images/argocd.jpg"
---
I work at CarbonCloud, a company whose goal is to help companies understand their carbon footprint. When we work with these companies, we often receive files containing all their products. My team's task is to parse the files, import them into the system, and validate, transform, and categorize the products. Categorizing involves running the product through an AI model to determine its type. For example, if we receive a product like ketchup, we need to select the correct category to ensure accurate carbon calculations.

The reason we wanted to try Argo Workflows was because we had previously built a simple queue using GO's routines and a postgres database. The way it worked was that we inserted jobs into a table and then a worker would check the database every second for any jobs. If there were jobs, it would execute them. If there were no jobs, it would wait for a second and check again. This solution was simple and effective, but we knew it would become an issue as we added more products to fetch. We needed to find a better solution that was also simple to use, and that's where Argo Workflows came in handy.

Some of the goals we wanted to achieve are:
1. Utilize the same codebase without the need to create a new repository or run stuff as for instance Serverless functions. We aim to continue running this in a container.
2. Implement a small change with a straightforward solution.
3. Ensure that it does not become more difficult to work locally on our machines.

And this is where Argo Workflows came in handy. Argo would simple allow us to use the same repository and codebase but change the entrypoint to the Docker container
