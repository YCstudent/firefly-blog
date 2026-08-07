export default {
  async fetch(request) {
    const url = new URL(request.url);
    url.hostname = "firefly-blog-4zg.pages.dev";
    const newRequest = new Request(url.toString(), request);
    return fetch(newRequest);
  }
}
