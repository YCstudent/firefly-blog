<script>
  import { onMount } from "svelte";

  let { pageSlug = "" } = $props();

  let comments = $state([]);
  let user = $state(null);
  let token = $state("");
  let content = $state("");
  let loading = $state(true);
  let submitting = $state(false);
  let showLogin = $state(false);
  let loginEmail = $state("");
  let loginPassword = $state("");
  let loginError = $state("");
  let registerMode = $state(false);
  let registerName = $state("");

  const API = "https://ustinus-api.2917321268.workers.dev";

  onMount(async () => {
    token = localStorage.getItem("ustinus_token") || "";
    const saved = localStorage.getItem("ustinus_user");
    if (saved) user = JSON.parse(saved);
    await loadComments();
  });

  async function loadComments() {
    loading = true;
    const res = await fetch(`${API}/api/comments?slug=${encodeURIComponent(pageSlug)}`);
    const data = await res.json();
    comments = data.comments || [];
    loading = false;
  }

  async function handleLogin() {
    loginError = "";
    const res = await fetch(`${API}/api/auth/login`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ email: loginEmail, password: loginPassword }),
    });
    const data = await res.json();
    if (data.error) { loginError = data.error; return; }
    user = data.user;
    token = data.token;
    localStorage.setItem("ustinus_token", token);
    localStorage.setItem("ustinus_user", JSON.stringify(user));
    showLogin = false;
    loginEmail = "";
    loginPassword = "";
  }

  async function handleRegister() {
    loginError = "";
    const res = await fetch(`${API}/api/auth/register`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username: registerName, email: loginEmail, password: loginPassword }),
    });
    const data = await res.json();
    if (data.error) { loginError = data.error; return; }
    user = data.user;
    token = data.token;
    localStorage.setItem("ustinus_token", token);
    localStorage.setItem("ustinus_user", JSON.stringify(user));
    showLogin = false;
    registerMode = false;
    loginEmail = "";
    loginPassword = "";
    registerName = "";
  }

  function logout() {
    user = null; token = "";
    localStorage.removeItem("ustinus_token");
    localStorage.removeItem("ustinus_user");
  }

  async function submitComment() {
    if (!content.trim() || submitting) return;
    submitting = true;
    await fetch(`${API}/api/comments`, {
      method: "POST",
      headers: { "Content-Type": "application/json", "Authorization": `Bearer ${token}` },
      body: JSON.stringify({ page_slug: pageSlug, content: content.trim() }),
    });
    content = "";
    submitting = false;
    await loadComments();
  }

  async function deleteComment(id) {
    await fetch(`${API}/api/comments/${id}`, {
      method: "DELETE",
      headers: { "Authorization": `Bearer ${token}` },
    });
    await loadComments();
  }

  function timeAgo(dateStr) {
    const diff = Date.now() - new Date(dateStr).getTime();
    const m = Math.floor(diff / 60000);
    if (m < 1) return "刚刚";
    if (m < 60) return `${m} 分钟前`;
    const h = Math.floor(m / 60);
    if (h < 24) return `${h} 小时前`;
    const d = Math.floor(h / 24);
    if (d < 30) return `${d} 天前`;
    return new Date(dateStr).toLocaleDateString("zh-CN");
  }
</script>

<div class="ustinus-comments">
  <div class="flex items-center justify-between mb-6">
    <h3 class="text-lg font-bold" style="color: var(--btn-content)">评论 ({comments.length})</h3>
    {#if user}
      <div class="flex items-center gap-3">
        <span class="text-sm" style="color: var(--content-meta)">{user.username}</span>
        <button onclick={logout} class="text-xs underline cursor-pointer" style="color: var(--content-meta)">退出</button>
      </div>
    {:else}
      <button onclick={() => { showLogin = true; loginError = ""; registerMode = false; }} class="text-sm underline cursor-pointer" style="color: var(--primary)">登录后评论</button>
    {/if}
  </div>

  {#if showLogin}
    <div class="mb-6 p-4 rounded-xl border" style="border-color: var(--line-divider); background: var(--btn-regular-bg)">
      <h4 class="text-sm font-semibold mb-3" style="color: var(--btn-content)">{registerMode ? "注册" : "登录"}</h4>
      {#if registerMode}
        <input bind:value={registerName} type="text" placeholder="用户名" class="w-full mb-2 px-3 py-2 rounded-lg border text-sm" style="border-color:var(--line-divider);background:var(--card-bg);color:var(--btn-content)" />
      {/if}
      <input bind:value={loginEmail} type="email" placeholder="邮箱" class="w-full mb-2 px-3 py-2 rounded-lg border text-sm" style="border-color:var(--line-divider);background:var(--card-bg);color:var(--btn-content)" />
      <input bind:value={loginPassword} type="password" placeholder="密码" class="w-full mb-2 px-3 py-2 rounded-lg border text-sm" style="border-color:var(--line-divider);background:var(--card-bg);color:var(--btn-content)" />
      {#if loginError}
        <p class="text-red-500 text-xs mb-2">{loginError}</p>
      {/if}
      <div class="flex gap-2">
        <button onclick={registerMode ? handleRegister : handleLogin} class="px-4 py-1.5 rounded-lg text-white text-sm font-medium" style="background: var(--primary)">{registerMode ? "注册" : "登录"}</button>
        <button onclick={() => { registerMode = !registerMode; loginError = ""; }} class="text-xs underline cursor-pointer" style="color: var(--content-meta)">{registerMode ? "已有账号？登录" : "没有账号？注册"}</button>
        <button onclick={() => { showLogin = false; }} class="text-xs underline ml-auto cursor-pointer" style="color: var(--content-meta)">取消</button>
      </div>
    </div>
  {/if}

  {#if user}
    <div class="mb-6 flex gap-3">
      <div class="w-8 h-8 rounded-full shrink-0 flex items-center justify-center text-white text-xs font-bold" style="background: var(--primary)">{user.username[0]?.toUpperCase() || "U"}</div>
      <div class="flex-1">
        <textarea bind:value={content} rows="3" placeholder="写下你的想法..." class="w-full px-4 py-3 rounded-xl border resize-none text-sm focus:outline-none" style="border-color:var(--line-divider);background:var(--card-bg);color:var(--btn-content)"></textarea>
        <button onclick={submitComment} disabled={submitting || !content.trim()} class="mt-2 px-5 py-2 rounded-lg text-white text-sm font-medium transition-opacity disabled:opacity-50" style="background: var(--primary)">{submitting ? "提交中..." : "发表评论"}</button>
      </div>
    </div>
  {/if}

  {#if loading}
    <div class="text-center py-8 text-sm" style="color: var(--content-meta)">加载中...</div>
  {:else if comments.length === 0}
    <div class="text-center py-8 text-sm" style="color: var(--content-meta)">暂无评论，来抢沙发吧</div>
  {:else}
    <div class="space-y-4">
      {#each comments as comment (comment.id)}
        <div class="flex gap-3">
          <div class="w-8 h-8 rounded-full shrink-0 flex items-center justify-center text-white text-xs font-bold" style="background: var(--primary)">{comment.username[0]?.toUpperCase() || "?"}</div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1">
              <span class="text-sm font-semibold" style="color: var(--btn-content)">{comment.username}</span>
              <span class="text-xs" style="color: var(--content-meta)">{timeAgo(comment.created_at)}</span>
              {#if user && user.id === comment.user_id}
                <button onclick={() => deleteComment(comment.id)} class="ml-auto text-xs underline cursor-pointer" style="color: var(--content-meta)">删除</button>
              {/if}
            </div>
            <p class="text-sm leading-relaxed" style="color: var(--btn-content)">{comment.content}</p>
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>
