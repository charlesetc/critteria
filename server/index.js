export default {
  async fetch(request, env, ctx) {
    const id = env.SERVER_OBJECT.idFromName("test");
    const stub = env.SERVER_OBJECT.get(id);
    const response = await stub.fetch(request, env, ctx);
    return response
  },
};

function leftpad(i) { 
  return (10000000000 + i).toString()
}

const EVENT_PREFIX = "event-"

export class ServerDurableObject {
  constructor(state, env) {
    this.state = state;
    this.env = env;
  }

  async new_id() {
    const next = ((await this.state.storage.get("highest")) || 0) + 1
    await this.state.storage.put("highest", next)
    console.log('next', next)
    return EVENT_PREFIX + leftpad(next)
  }

  async get_subsequent_events(id) { 
    const ret = await this.state.storage.list({startAfter: id, prefix: EVENT_PREFIX})
    console.log('subseq', ret)
    return [...ret.values()]
  }

  async fetch(request, env, ctx) {
    const url = new URL(request.url);
    if (url.pathname == "/highest") {
      const ret = await this.state.storage.get("highest")
      return new Response(JSON.stringify(ret));
    } else if (url.pathname == "/write") {
      // const data = await request.json();
      this.state.storage.put(await this.new_id(), "1")
      this.state.storage.put(await this.new_id(), "2")
      this.state.storage.put(await this.new_id(), "3")
      this.state.storage.put(await this.new_id(), "4")
      this.state.storage.put(await this.new_id(), "5")
      this.state.storage.put(await this.new_id(), "6")
      this.state.storage.put(await this.new_id(), "7")
      this.state.storage.put(await this.new_id(), "8")
      this.state.storage.put(await this.new_id(), "9")
      this.state.storage.put(await this.new_id(), "10")
      this.state.storage.put(await this.new_id(), "11")
      this.state.storage.put(await this.new_id(), "12")
      this.state.storage.put(await this.new_id(), "13")
      return new Response("ok");
    } else if (url.pathname.startsWith("/read/")) {
      const id = url.pathname.split("/")[2]
      const ret = await this.get_subsequent_events(id)
      return new Response(JSON.stringify(ret));
    } else if (url.pathname == "/clear") {
      this.state.storage.deleteAll()
      return new Response("ok");
    } else {
      return new Response("not found", {status: 404});
    }
  }
}
