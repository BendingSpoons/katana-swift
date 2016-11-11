#CodingLove
We all lived some of those moments only developers can laugh about. [thecodinglove.com](thecodinglove.com) is a simple website with a collection of Gifs about those moments. In this demo we implemented a very simple newsfeed for it!

Here's the final result.

![](CodingLoveDemo.gif)

Just a note about the implementation: we do not fetch the list of posts and their data directly from the website above. Instead we retrieve that data from a file bundled in the application (`posts.json`) in order to avoid scraping the website unnecessarily. We just simulate the responses to be paginated as they would be in a real scenario.

###What is showcased here:
- Most of the basics of Katana;
- Async Actions: Actions that are executed without blocking the application;
- Tables: yes, we've tables 😱;
- Providers: components that can be used to provide some functionality during side effects.

