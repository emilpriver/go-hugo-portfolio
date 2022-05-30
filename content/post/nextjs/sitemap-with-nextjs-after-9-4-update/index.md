---
title: Sitemap with NextJS after 9.4 update.
date: "2020-05-11T22:12:03.284Z"
seoTitle: "Sitemap with Nextjs after 9.4 update"
description: "Generate a sitemap.xml after Nextjs 9.4 update. Works with getServerSidedProps, getStaticProps update"
cover: ./cover.jpeg
published: true
tags: ["next.js", "sitemap", "react"]
type: blog
---

Nextjs have done some changes since last post that I wrote. Since then was getStaticProps, getStaticPaths and getServerSidedProps introduced(You can read more about that here: https://nextjs.org/blog/next-9-4)
One way to generate a sitemap with nextjs after the update on SSG and SSR with a dynamic output based on the pages the application have is to create an API route that fetches data and return it as XML which could be used to read what pages you have on your application.
## Create the code that generates the XML feed:

The way I generated my sitemap is with a package named "sitemap" which is an awesome package to generate a sitemap with.
The generation of the sitemap looked like this:

```javascript
// import functions from the package
import { SitemapStream, streamToPromise } from "sitemap";

// Fetch data from a source which will be used to render the sitemap.
const { posts } = await graphlqlFetch(`
    query getSitemapData {
        projects: allWorks {
            slug {
                current
            }
            publishedAt
        }
    }
`);

// Create the a stream to write to with a hostname which will be used for all links
// Your are able to add more settings to the stream. I recommend to look a the npm package for more information.
const smStream = new SitemapStream({
    hostname: "https://priver.dev",
});

// Add frontpage
smStream.write({
    url: "/",
});

// Add a static url to ex: about page
smStream.write({
    url: "/about",
});

// add all dynamic url to the sitemap which is fetched from a source.
posts.forEach((element) => {
    smStream.write({
        url: `/${element.slug.current}`,
        lastmod: element.publishedAt,
    });
});

// tell sitemap that there is nothing more to add to the sitemap
smStream.end();


// generate a sitemap and add the XML feed to a url which will be used later on.
const sitemap = await streamToPromise(smStream).then((sm) => sm.toString());
```

But this is only the code that generates the sitemap. They sitemap const will later on be used to send data to the user or an service which want to read the sitemap/xml feed.
##Send the sitemap to the user:

Nextjs have a build in way to return data to a user or service when an api route is generated. Which means we dont need any external packages like express.
They way I returned data to the user or service when using an api route is this code:
```javascript
export default async (req, res) => {
    // here is the generation of the sitemap happening
    
    // tell the output that we will output XML
    res.setHeader("Content-Type", "text/xml");
    // write the generate sitemap to the output
    res.write(sitemap);
    // end and send the data to the user or service.
    res.end();
};
```
Now the user will have a sitemap that is dynamic generated and outputed in a way that a service like Goole Search Engine is able to read it.

## Want to use domain.ltd/sitemap.xml as url for your sitemap?

To use domain.ltd/sitemap.xml in this solution do you basic add a rewrite from /sitemap.xml to /api/sitemap in next.config.js. More about rewrites here: https://nextjs.org/docs/api-reference/next.config.js/rewrites
Like this:
```javascript
module.exports = {
    async rewrites() {
        return [
            {
                source: "/sitemap.xml",
                destination: "/api/sitemap",
            },
        ];
    },
};
```

## The full code:
This is the whole code I used to generate a dynamic sitemap:
```javascript
// import functions from the package
import { SitemapStream, streamToPromise } from "sitemap";

// A custom function I use to fetch data from a backend. I will keep the import to make it more clear why "graphlqlFetch" is used in the code
import graphlqlFetch from "lib/apollo"

export default async (req, res) => {
// Fetch data from a source which will be used to render the sitemap.
const { posts } = await graphlqlFetch(`
    query getSitemapData {
        projects: allWorks {
            slug {
                current
            }
            publishedAt
        }
    }
`);

// Create the a stream to write to with a hostname which will be used for all links
// Your are able to add more settings to the stream. I recommend to look a the npm package for more information.
const smStream = new SitemapStream({
    hostname: "https://priver.dev",
});

// Add frontpage
smStream.write({
    url: "/",
});

// Add a static url to ex: about page
smStream.write({
    url: "/about",
});

// add all dynamic url to the sitemap which is fetched from a source.
posts.forEach((element) => {
    smStream.write({
        url: `/${element.slug.current}`,
        lastmod: element.publishedAt,
    });
});

// tell sitemap that there is nothing more to add to the sitemap
smStream.end();

// generate a sitemap and add the XML feed to a url which will be used later on.
const sitemap = await streamToPromise(smStream).then((sm) => sm.toString());
// here is the generation of the sitemap happening

// tell the output that we will output XML
res.setHeader("Content-Type", "text/xml");
// write the generate sitemap to the output
res.write(sitemap);
// end and send the data to the user or service.
res.end();
};
```

Github gist with the same code: [Github Gist](https://gist.github.com/emilpriver/475ab666d3155f84f9739cbf8567e640)

Hope this help you to generate a dynamic sitemap for your Nextjs application
