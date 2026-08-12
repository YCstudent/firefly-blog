import { Hono } from "hono";
import { cors } from "hono/cors";

type Env = { DB: D1Database };
const app = new Hono<{ Bindings: Env }>();

app.use("*", cors());
app.get("/", (c) => c.json({ ok: true, name: "ustinus-api" }));

// Auth
app.post("/api/auth/register", async (c) => {
  const { username, email, password } = await c.req.json();
  if (!username || !email || !password) return c.json({ error: "缺少参数" }, 400);
  const hash = await hashPassword(password);
  try {
    await c.env.DB.prepare("INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)").bind(username, email, hash).run();
    const user = await c.env.DB.prepare("SELECT id, username, email, avatar_url FROM users WHERE email = ?").bind(email).first();
    const token = await generateToken(user);
    return c.json({ token, user });
  } catch (e: any) {
    if (e.message?.includes("UNIQUE")) return c.json({ error: "用户名或邮箱已存在" }, 409);
    return c.json({ error: "注册失败" }, 500);
  }
});

app.post("/api/auth/login", async (c) => {
  const { email, password } = await c.req.json();
  if (!email || !password) return c.json({ error: "缺少参数" }, 400);
  const user = await c.env.DB.prepare("SELECT * FROM users WHERE email = ?").bind(email).first();
  if (!user || !(await verifyPassword(password, user.password_hash as string))) return c.json({ error: "邮箱或密码错误" }, 401);
  const token = await generateToken(user);
  return c.json({ token, user: { id: user.id, username: user.username, email: user.email, avatar_url: user.avatar_url } });
});

// Comments
app.get("/api/comments", async (c) => {
  const slug = c.req.query("slug");
  if (!slug) return c.json({ comments: [] });
  const { results } = await c.env.DB.prepare("SELECT c.id, c.content, c.parent_id, c.created_at, u.username, u.avatar_url FROM comments c JOIN users u ON c.user_id = u.id WHERE c.page_slug = ? ORDER BY c.created_at ASC").bind(slug).all();
  return c.json({ comments: results });
});

app.post("/api/comments", async (c) => {
  const token = c.req.header("Authorization")?.replace("Bearer ", "");
  if (!token) return c.json({ error: "未登录" }, 401);
  const payload = await verifyToken(token);
  if (!payload) return c.json({ error: "登录已过期" }, 401);
  const { page_slug, content, parent_id } = await c.req.json();
  if (!page_slug || !content) return c.json({ error: "缺少参数" }, 400);
  await c.env.DB.prepare("INSERT INTO comments (user_id, page_slug, content, parent_id) VALUES (?, ?, ?, ?)").bind(payload.userId, page_slug, content, parent_id || null).run();
  return c.json({ ok: true });
});

app.delete("/api/comments/:id", async (c) => {
  const token = c.req.header("Authorization")?.replace("Bearer ", "");
  if (!token) return c.json({ error: "未登录" }, 401);
  const payload = await verifyToken(token);
  if (!payload) return c.json({ error: "登录已过期" }, 401);
  const id = c.req.param("id");
  const comment = await c.env.DB.prepare("SELECT user_id FROM comments WHERE id = ?").bind(id).first();
  if (!comment) return c.json({ error: "评论不存在" }, 404);
  if (comment.user_id !== payload.userId) return c.json({ error: "无权删除" }, 403);
  await c.env.DB.prepare("DELETE FROM comments WHERE id = ?").bind(id).run();
  return c.json({ ok: true });
});

async function generateToken(user: any) {
  const payload = JSON.stringify({ userId: user.id, username: user.username, exp: Date.now() + 7*24*60*60*1000 });
  return btoa(payload);
}
async function verifyToken(token: string) {
  try { const p = JSON.parse(atob(token)); if (p.exp < Date.now()) return null; return p; } catch { return null; }
}
async function hashPassword(pw: string) {
  const data = new TextEncoder().encode(pw);
  const hash = await crypto.subtle.digest("SHA-256", data);
  return Array.from(new Uint8Array(hash)).map(b => b.toString(16).padStart(2, "0")).join("");
}
async function verifyPassword(pw: string, hash: string) { return (await hashPassword(pw)) === hash; }

export default app;
