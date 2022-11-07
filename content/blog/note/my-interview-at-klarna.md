---
title: "My interview at Klarna"
date: 2022-06-21T14:50:59+02:00
draft: false
description: "Blog posts about when I was interviewed at Klarna"
type: "blog"
tags: ["Interview"]
best: true
images:
  - /og-images/klarna.png
series:
  - Interview
cover: "images/note/my-interview-at-klarna/klarna.png"
toc: true
---

This is a small article about when I was interviewed by Klarna.

The interview included 5 different steps where the steps was:

-   A simple call to get introduced to how the flow will be like and salary talk
-   A smaller interview on my thought about different topics
-   IQ test
-   Technical interview
-   More of a mental type of interview.

The first call was a 30 minutes call where the guy who called me talked about what the interview will look like and if a total time of 3-4 weeks was ok with me for the interview and what salary I was expected. This call was a fast one and was finished in less than 15 minutes. After this call, I was booked into an interview talking about my opinion on for example failure, what I was thinking of telling people about my thoughts, and so on. This call was also a really simple and smooth call which I passed. After this test, I was booked into an IQ test where the goal was to find patterns out of 9 images that matched should match which I also passed. But the most interesting interviews are the next 2.

The IQ test looked like this

![IQ test](images/note/my-interview-at-klarna/provtest_exempel.jpeg)

The most fun part was the technical interview as it was the most challenging one and probably because it was my first time doing this kind of interview. The tech interview was 2 different tasks, 1 task where the goal was to onboard other developers onto a team and a project, and my goal was to describe

-  How the project looked like
   -   What it was built on
   -   What system was involved
   -   How the developer workflow looked like
   -   How the system was deployed
- How the team worked
- What tools the team used

I chose to talk about a simple Next.JS e-commerce website project which was using an e-commerce system, Meilisearch, and Elasticsearch for the whole e-commerce part of the website including products, categories, and payment. The other part of the website was content that was fetched from WordPress using WP Graphql, hosted on Kinsta. The tricky part about this is not that I don't understand how the system we works, but more that it's harder than you think to talk about it. For me the project cristal clear but for a new individual which has never worked on the project, it's probably the project a labyrinth. While I was talking about the project did the individual who interviewed me ask side questions, such as "Why didn't you use Docker". What I noticed during this part of the tech interview was that the interviewer wanted to find out wherever I understood what I was working on and how  it worked, but also how I acted when there could be an improvement on a part of the system. Was I open to improvements or did I think that what we already had the best solution? The first part was harder than the second part is I am more confident in my skills than talking about something I work with.

## Tech interview

The second part was a coding interview. My goal was to iterate through an object which contains values and then convert it into an array and only show the last 3 values which are left in the array we created. This was the most fun part.
The initial code looked something like this:
```javascript
const values = {
    value: "Dog",
    nextValue: {
        value: "Watermelon",
        nextValue: {
            value: "Cat",
            nextValue: {
                value: "Orange",
                nextValue: {
                    value: "Pear",
                    nextValue: {
                        value: "Apple",
                    }
                }
            }
        }
    }
}

function getLastThreeValues(object) {
    console.log(object)
}

getLastThreeValues(values)

```

Something the interviewer said before we started was "this is a pair programming, I'm here to help.". When I started to code didn't I use the interviewer at all and the reason was that I wanted to show that I know how to solve the problem. But something I didn't think of is that at a company of this size is that pair-programming is important, this means collaboration is important and something that an interviewer looks at during the interview. 
My first solution to the problem was the code below.

```javascript
const values = {
    value: "Dog",
    nextValue: {
        value: "Watermelon",
        nextValue: {
            value: "Cat",
            nextValue: {
                value: "Orange",
                nextValue: {
                    value: "Pear",
                    nextValue: {
                        value: "Apple",
                    }
                }
            }
        }
    }
}

function getLastThreeValues(value) {
    const array = []

    function getValueAndPush (v) {
        array.push(v.value)

        if (v.nextValue) {
            getValueAndPush(v.nextValue)
        }
    }

    getValueAndPush(value)

    array.splice(0, array.length - 3)

    console.log(array)
}

getLastThreeValues(values)
```
My solution was to create a function inside of the `getLastThreeValues` function which I recalled inside the function if there is any next value. And this works fine if we don't have too much data. What happens if we increase the object to a million values?. Then we have an issue. The main issue is that when we call a function that has a function inside the function do we allocate a lot of memory. This means that sooner or later will we have an issue where the instance that runs the code, runs out of memory and dies.

When I was finished did the interview asks me if I had any idea of a way to improve the code, and I said no as couldn't think of a better solution at the time. At that time did I realize that it was probably a good idea to use the interviewer, so I asked him if he had any ideas. He then talked about the problem of memory and asked me if I could think of a solution by using a while loop. So at that point did I and during the interview together work on a solution where he mostly told me keywords such as, "while loop", and "splice".  

The solution we together came up with looked something like this:

````javascript
const values = {
    value: "Dog",
    nextValue: {
        value: "Watermelon",
        nextValue: {
            value: "Cat",
            nextValue: {
                value: "Orange",
                nextValue: {
                    value: "Pear",
                    nextValue: {
                        value: "Apple",
                        nextValue: null
                    }
                }
            }
        }
    }
}

function getLastThreeValues(value) {
    const array = []

    let currentValue = value
    while (currentValue.value) {
        array.push(currentValue.value)

        if(array.length > 3){
            array.splice(0,1)
        }

        if(currentValue.nextValue) {
            currentValue = currentValue.nextValue
        } else {
            break
        }
    }

    console.log(array)
}

getLastThreeValues(values)

````
What we did was that we removed the use of a function, and we also added a splice function. The reason why is that we wanted to remove a lot of memory usage. And a function that creates a function inside of a function increase memory usage, and a variable that has a lot of items in the array increase usage of memory for each new item added to the array. So we added `array.splice(0,1)` to always remove the first item in the array and not have more than 4 items in the array ( if we have 3 items in the array and add 1 item do we get 4 items, but we remove the first one, so we have at most 4 items in the array.).

### What I learned during this tech interview
It's more important to be able to work together and collaborate than have a lot of skills. So being able to show that you are good at pair programming is better than showing that you have a lot of knowledge. A system engineering job is solving problems and not showing how good you are at a language or a system. The main goal during this tech interview was not to solve the problem but to show that you as a developer are open to collaborating and allowing someone else to criticize your code. 


## Mental interview
The next part of the interview series was what I understood as a mental type of interview. Where the interviewer wanted to understand my thoughts on different topics and how my thoughts were to solve the problem. 
I don't remember all the topics, but 1 I remember is failure. I said that I don't think failure is necessarily bad as you can learn from them, and they can show you a solution to another problem.

But something we also talked about was how I acted when I wanted to find the best solution for something or which service works the best. And I started to talk about how I bought my TV. The way I bought the TV was that I first checked which TV led type that could work with the current room, and then I checked which TV had the best hardware that I wanted, and then I checked PriceRunner to find where the tv is cheapest and then I bought it. Which I understood the interviewer liked as a story. Maybe he wanted to understand the way I found the best solution which in this case was by looking at different options and then removing the solutions which weren't better than the others.

This interviewers goal was also to find out which team I could fit in.

## The end
I applied for the job as I wanted to try new areas in system engineering. The system engineering space is BIG and a lot to explore and try out. And my goal was probably not to get hired, but rather to learn which is one reason that I write this article. I also learned that these types of companies are probably not the most interested in your skills and that they are more interested in how you find solutions and how well you can take criticism and work together to be able to develop the best solution that is possible.

I didn't prepare at all, and I don't think you need to prepare a lot, But something good is to maybe read about the area you will work with. And what I mean by this is that you could read basic about the language, maybe the area the company works within (Klarna works in fintech, so I did read basic about fintech and Klarna as a company). Also, you don't need to know everything. To enter the interview and be honest about yourself is the best as a developer you constantly learn new stuff, so you are never at a level where you know everything and even a developer who has coded for 20 years doesn't know everything. 

Klarna never told me if I did get the job at the end, probably as they removed 10% of the [employees 2 weeks later](https://www.klarna.com/s/blogg/company-announcement-from-ceo-sebastian/). But feedback would be great.

✌️

PS. This post is a work in progress
