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

const API = "https://api.202886.xyz";

onMount(async () => {
	const savedToken = localStorage.getItem("ustinus_token") || "";
	const savedUser = localStorage.getItem("ustinus_user");
	if (savedToken && savedUser) {
		token = savedToken;
		user = JSON.parse(savedUser);
	}
	await loadComments();
});

async function loadComments() {
	loading = true;
	try {
		const res = await fetch(
			`${API}/api/comments?slug=${encodeURIComponent(pageSlug)}`,
		);
		const data = await res.json();
		comments = data.comments || [];
	} catch (e) {
		console.error(e);
	}
	loading = false;
}

async function doLogin() {
	loginError = "";
	try {
		const res = await fetch(`${API}/api/auth/login`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({ email: loginEmail, password: loginPassword }),
		});
		const data = await res.json();
		if (data.error) {
			loginError = data.error;
			return;
		}
		user = data.user;
		token = data.token;
		localStorage.setItem("ustinus_token", token);
		localStorage.setItem("ustinus_user", JSON.stringify(user));
		showLogin = false;
		loginEmail = "";
		loginPassword = "";
	} catch (e) {
		loginError = "网络错误，请重试";
	}
}

async function doRegister() {
	loginError = "";
	try {
		const res = await fetch(`${API}/api/auth/register`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({
				username: registerName,
				email: loginEmail,
				password: loginPassword,
			}),
		});
		const data = await res.json();
		if (data.error) {
			loginError = data.error;
			return;
		}
		user = data.user;
		token = data.token;
		localStorage.setItem("ustinus_token", token);
		localStorage.setItem("ustinus_user", JSON.stringify(user));
		showLogin = false;
		registerMode = false;
		loginEmail = "";
		loginPassword = "";
		registerName = "";
	} catch (e) {
		loginError = "网络错误，请重试";
	}
}

function doLogout() {
	user = null;
	token = "";
	localStorage.removeItem("ustinus_token");
	localStorage.removeItem("ustinus_user");
}

async function doSubmit() {
	if (!content.trim() || submitting) return;
	submitting = true;
	await fetch(`${API}/api/comments`, {
		method: "POST",
		headers: {
			"Content-Type": "application/json",
			Authorization: `Bearer ${token}`,
		},
		body: JSON.stringify({ page_slug: pageSlug, content: content.trim() }),
	});
	content = "";
	submitting = false;
	await loadComments();
}

async function doDelete(id) {
	await fetch(`${API}/api/comments/${id}`, {
		method: "DELETE",
		headers: { Authorization: `Bearer ${token}` },
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
  <!-- Header + login area -->
  <div class="mb-6">
    <div class="flex items-center justify-between mb-4">
      <h3 class="text-lg font-bold" style="color: var(--btn-content)">评论 ({comments.length})</h3>
      {#if user}
        <div class="flex items-center gap-3">
          <span class="text-sm" style="color: var(--content-meta)">{user.username}</span>
          <button onclick={doLogout} class="text-xs cursor-pointer" style="color: var(--content-meta)">退出</button>
        </div>
      {/if}
    </div>

    <!-- Not logged in: show login prompt with style -->
    {#if !user && !showLogin}
      <div class="rounded-xl border p-4 flex items-center justify-between" style="border-color: var(--line-divider); background: var(--btn-regular-bg)">
        <span class="text-sm" style="color: var(--content-meta)">登录后参与讨论</span>
        <button onclick={() => { showLogin = true; loginError = ""; registerMode = false; }} class="px-4 py-2 rounded-lg text-white text-sm font-medium transition-opacity hover:opacity-90" style="background: var(--primary)">
          登录 / 注册
        </button>
      </div>
    {/if}

    <!-- Login/Register form -->
    {#if showLogin}
      <div class="rounded-xl border p-5" style="border-color: var(--line-divider); background: var(--btn-regular-bg)">
        <h4 class="text-sm font-semibold mb-4" style="color: var(--btn-content)">{registerMode ? "创建账号" : "登录账号"}</h4>
        {#if registerMode}
          <input bind:value={registerName} type="text" placeholder="用户名" class="w-full mb-3 px-3 py-2.5 rounded-lg border text-sm focus:outline-none" style="border-color:var(--line-divider);background:var(--card-bg);color:var(--btn-content)" />
        {/if}
        <input bind:value={loginEmail} type="email" placeholder="邮箱" class="w-full mb-3 px-3 py-2.5 rounded-lg border text-sm focus:outline-none" style="border-color:var(--line-divider);background:var(--card-bg);color:var(--btn-content)" />
        <input bind:value={loginPassword} type="password" placeholder="密码" class="w-full mb-3 px-3 py-2.5 rounded-lg border text-sm focus:outline-none" style="border-color:var(--line-divider);background:var(--card-bg);color:var(--btn-content)" />
        {#if loginError}
          <p class="text-red-500 text-xs mb-3">{loginError}</p>
        {/if}
        <div class="flex items-center gap-3">
          <button onclick={registerMode ? doRegister : doLogin} class="px-5 py-2 rounded-lg text-white text-sm font-medium transition-opacity hover:opacity-90" style="background: var(--primary)">
            {registerMode ? "注册" : "登录"}
          </button>
          <button onclick={() => { registerMode = !registerMode; loginError = ""; }} class="text-sm cursor-pointer" style="color: var(--primary)">
            {registerMode ? "← 返回登录" : "没有账号？注册"}
          </button>
          <button onclick={() => { showLogin = false; loginError = ""; }} class="text-sm ml-auto cursor-pointer" style="color: var(--content-meta)">取消</button>
        </div>
      </div>
    {/if}
  </div>

  <!-- Comment input -->
  {#if user}
    <div class="mb-6 flex gap-3">
      <div class="w-9 h-9 rounded-full shrink-0 flex items-center justify-center text-white text-sm font-bold" style="background: var(--primary)">{user.username[0]?.toUpperCase() || "U"}</div>
      <div class="flex-1">
        <textarea bind:value={content} rows="3" placeholder="写下你的想法..." class="w-full px-4 py-3 rounded-xl border resize-none text-sm focus:outline-none" style="border-color:var(--line-divider);background:var(--card-bg);color:var(--btn-content)"></textarea>
        <div class="flex justify-end mt-2">
          <button onclick={doSubmit} disabled={submitting || !content.trim()} class="px-5 py-2 rounded-lg text-white text-sm font-medium transition-opacity disabled:opacity-50 hover:opacity-90" style="background: var(--primary)">{submitting ? "提交中..." : "发表评论"}</button>
        </div>
      </div>
    </div>
  {/if}

  <!-- Comment list -->
  {#if loading}
    <div class="text-center py-8 text-sm" style="color: var(--content-meta)">加载中...</div>
  {:else if comments.length === 0}
    <div class="text-center py-12 text-sm" style="color: var(--content-meta)">
      <svg class="w-10 h-10 mx-auto mb-2 opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/></svg>
      <p>暂无评论，来抢沙发吧</p>
    </div>
  {:else}
    <div class="space-y-5">
      {#each comments as comment (comment.id)}
        <div class="flex gap-3">
          <div class="w-9 h-9 rounded-full shrink-0 flex items-center justify-center text-white text-sm font-bold" style="background: var(--primary)">{comment.username[0]?.toUpperCase() || "?"}</div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-1">
              <span class="text-sm font-semibold" style="color: var(--btn-content)">{comment.username}</span>
              <span class="text-xs" style="color: var(--content-meta)">{timeAgo(comment.created_at)}</span>
              {#if user && user.id === comment.user_id}
                <button onclick={() => doDelete(comment.id)} class="ml-auto text-xs cursor-pointer" style="color: var(--content-meta)">删除</button>
              {/if}
            </div>
            <p class="text-sm leading-relaxed" style="color: var(--btn-content)">{comment.content}</p>
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>
