<script>
import { onMount } from "svelte";

let turnstileRendered = false;

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
let loginConfirm = $state("");
let loginError = $state("");
let registerMode = $state(false);
let registerName = $state("");
let verifyCode = $state("");
let emailVerified = $state(false);
let sendingCode = $state(false);
let verifying = $state(false);
let codeSent = $state(false);
let showEmoji = $state(false);
let showPreview = $state(false);
let uploading = $state(false);

const API = "https://api.202886.xyz";

const emojis = [
	"😀",
	"😂",
	"🤣",
	"😊",
	"😍",
	"🤩",
	"😎",
	"🤔",
	"😅",
	"😭",
	"🥳",
	"😇",
	"🙃",
	"🤗",
	"😴",
	"🤐",
	"😤",
	"😡",
	"💀",
	"👻",
	"👽",
	"🤖",
	"🎉",
	"❤️",
	"🔥",
	"⭐",
	"💯",
	"✅",
	"❌",
	"🤝",
	"👏",
	"🙌",
	"💪",
	"🧠",
	"👀",
	"🌈",
	"☀️",
	"🌙",
	"⚡",
	"💧",
	"🍕",
	"🎮",
	"📚",
	"💻",
	"🚀",
	"🎯",
	"🏆",
	"👍",
];

$effect(() => {
	if (showLogin && !turnstileRendered) {
		setTimeout(() => {
			const el = document.getElementById("ts-container");
			if (!el) return;
			if (window.turnstile) {
				el.innerHTML = "";
				const div = document.createElement("div");
				div.className = "cf-turnstile";
				div.setAttribute("data-sitekey", "0x4AAAAAAEN2y0SVTceMvqdv");
				el.appendChild(div);
				const isDark = document.documentElement.classList.contains("dark");
				window.turnstile.render(div, {
					size: "normal",
					theme: isDark ? "dark" : "light",
				});
				turnstileRendered = true;
			}
		}, 300);
	}
	if (!showLogin) turnstileRendered = false;
});

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
	const tsToken = window.turnstile?.getResponse?.();
	if (!tsToken) {
		loginError = "请完成人机验证";
		return;
	}
	try {
		const res = await fetch(`${API}/api/auth/login`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({
				email: loginEmail,
				password: loginPassword,
				"cf-turnstile-response": tsToken,
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
		loginEmail = "";
		loginPassword = "";
	} catch (e) {
		loginError = "网络错误，请重试";
	}
}

async function doRegister() {
	loginError = "";
	if (!emailVerified) {
		loginError = "请先验证邮箱";
		return;
	}
	if (!registerName.trim()) {
		loginError = "请输入用户名";
		return;
	}
	if (registerName.trim().length < 2) {
		loginError = "用户名至少 2 个字符";
		return;
	}
	if (!loginEmail.includes("@")) {
		loginError = "请输入有效邮箱";
		return;
	}
	if (loginPassword.length < 6) {
		loginError = "密码至少 6 位";
		return;
	}
	if (loginPassword !== loginConfirm) {
		loginError = "两次密码不一致";
		return;
	}
	const tsToken = window.turnstile?.getResponse?.();
	if (!tsToken) {
		loginError = "请完成人机验证";
		return;
	}
	try {
		const res = await fetch(`${API}/api/auth/register`, {
			method: "POST",
			headers: { "Content-Type": "application/json" },
			body: JSON.stringify({
				username: registerName.trim(),
				email: loginEmail,
				password: loginPassword,
				"cf-turnstile-response": tsToken,
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
		loginConfirm = "";
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

function insertEmoji(emoji) {
	content += emoji;
}

async function handleImageUpload(e) {
	const file = e.target.files?.[0];
	if (!file) return;
	uploading = true;
	try {
		const form = new FormData();
		form.append("file", file);
		const res = await fetch(`${API}/api/upload`, {
			method: "POST",
			headers: { Authorization: `Bearer ${token}` },
			body: form,
		});
		const data = await res.json();
		if (data.url) content += `\n![图片](${data.url})\n`;
	} catch (e) {
		console.error(e);
	}
	uploading = false;
	e.target.value = "";
}

async function handleAvatarUpload(e) {
	const file = e.target.files?.[0];
	if (!file) return;
	uploading = true;
	try {
		const form = new FormData();
		form.append("file", file);
		const res = await fetch(`${API}/api/auth/avatar`, {
			method: "POST",
			headers: { Authorization: `Bearer ${token}` },
			body: form,
		});
		const data = await res.json();
		if (data.url) {
			user = { ...user, avatar_url: data.url };
			localStorage.setItem("ustinus_user", JSON.stringify(user));
			await loadComments();
		}
	} catch (e) {
		console.error(e);
	}
	uploading = false;
	e.target.value = "";
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
	if (!confirm("确认删除？")) return;
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
	return new Date(dateStr).toLocaleDateString("zh-CN");
}

function renderContent(text) {
	if (!text) return "";
	return text
		.replace(
			/!\[.*?\]\((https?:\/\/[^\s)]+)\)/g,
			'<img src="$1" class="max-w-full rounded-lg my-2" loading="lazy" alt="" />',
		)
		.replace(/\n/g, "<br>");
}
</script>

<div class="ustinus-comments">
  <div class="mb-6">
    <div class="flex items-center justify-between mb-4">
      <h3 class="text-lg font-bold" style="color: var(--btn-content)">评论 ({comments.length})</h3>
      {#if user}
        <div class="flex items-center gap-2">
          <span class="text-sm" style="color: var(--btn-content)">{user.username}</span>
          <button onclick={doLogout} class="text-xs cursor-pointer" style="color: var(--content-meta)">退出</button>
        </div>
      {/if}
    </div>

    {#if !user && !showLogin}
      <div class="rounded-xl border p-5 flex items-center justify-between" style="border-color: var(--line-divider); background: var(--btn-regular-bg)">
        <div>
          <p class="text-sm font-medium" style="color: var(--btn-content)">参与讨论</p>
          <p class="text-xs mt-0.5" style="color: var(--content-meta)">登录后可以发表评论、上传图片</p>
        </div>
        <button onclick={() => { showLogin = true; loginError = ""; registerMode = false; emailVerified = false; codeSent = false; verifyCode = ""; setTimeout(renderTurnstile, 100); }} class="px-5 py-2.5 rounded-lg text-white text-sm font-medium transition-opacity hover:opacity-90 shrink-0" style="background: var(--primary)">登录 / 注册</button>
      </div>
    {/if}

    {#if showLogin}
      <div class="rounded-xl border overflow-hidden" style="border-color: var(--line-divider); background: var(--card-bg)">
        <div class="flex border-b" style="border-color: var(--line-divider)">
          <button onclick={() => { registerMode = false; loginError = ""; turnstileRendered = false; setTimeout(renderTurnstile, 200); }} class="flex-1 py-3 text-sm font-medium transition-colors" style="color: {!registerMode ? 'var(--btn-content)' : 'var(--content-meta)'}; border-bottom: 2px solid {!registerMode ? 'var(--primary)' : 'transparent'}">登录</button>
          <button onclick={() => { registerMode = true; loginError = ""; turnstileRendered = false; setTimeout(renderTurnstile, 200); }} class="flex-1 py-3 text-sm font-medium transition-colors" style="color: {registerMode ? 'var(--btn-content)' : 'var(--content-meta)'}; border-bottom: 2px solid {registerMode ? 'var(--primary)' : 'transparent'}">注册</button>
        </div>
        <div class="p-5">
          {#if registerMode}
            <div class="mb-3">
              <label class="block text-xs font-medium mb-1.5" style="color: var(--btn-content)">用户名</label>
              <input bind:value={registerName} type="text" placeholder="至少 2 个字符" class="w-full px-3 py-2.5 rounded-lg border text-sm" style="border-color:var(--line-divider);background:var(--btn-regular-bg);color:var(--btn-content)" />
            </div>
          {/if}
          <div class="mb-3">
            <label class="block text-xs font-medium mb-1.5" style="color: var(--btn-content)">邮箱</label>
            <div class="flex gap-2">
              <input bind:value={loginEmail} type="email" placeholder="your@email.com" disabled={emailVerified} class="flex-1 px-3 py-2.5 rounded-lg border text-sm" style="border-color:var(--line-divider);background:var(--btn-regular-bg);color:var(--btn-content)" />
              {#if registerMode && !emailVerified}
                <button onclick={sendCode} disabled={sendingCode || !loginEmail.includes("@")} class="px-3 py-2.5 rounded-lg text-white text-xs font-medium shrink-0 transition-opacity disabled:opacity-50" style="background: var(--primary)">{sendingCode ? "发送中..." : codeSent ? "重新发送" : "发送验证码"}</button>
              {/if}
            </div>
            {#if registerMode && codeSent && !emailVerified}
              <div class="flex gap-2 mt-2">
                <input bind:value={verifyCode} type="text" placeholder="6 位验证码" maxlength="6" class="flex-1 px-3 py-2 rounded-lg border text-sm" style="border-color:var(--line-divider);background:var(--btn-regular-bg);color:var(--btn-content)" />
                <button onclick={verifyEmailCode} disabled={verifying || verifyCode.length < 6} class="px-3 py-2 rounded-lg text-white text-xs font-medium shrink-0 transition-opacity disabled:opacity-50" style="background: var(--primary)">{verifying ? "验证中..." : "验证"}</button>
              </div>
            {/if}
            {#if emailVerified}
              <p class="text-green-500 text-xs mt-1">✓ 邮箱已验证</p>
            {/if}
          </div>
          <div class="mb-3">
            <label class="block text-xs font-medium mb-1.5" style="color: var(--btn-content)">密码</label>
            <input bind:value={loginPassword} type="password" placeholder="输入密码" class="w-full px-3 py-2.5 rounded-lg border text-sm" style="border-color:var(--line-divider);background:var(--btn-regular-bg);color:var(--btn-content)" />
          </div>
          {#if registerMode}
            <div class="mb-4">
              <label class="block text-xs font-medium mb-1.5" style="color: var(--btn-content)">确认密码</label>
              <input bind:value={loginConfirm} type="password" placeholder="再次输入密码" class="w-full px-3 py-2.5 rounded-lg border text-sm" style="border-color:var(--line-divider);background:var(--btn-regular-bg);color:var(--btn-content)" />
            </div>
          {/if}
          <div class="mb-4" id="ts-container"></div>
          {#if loginError}
            <p class="text-red-500 text-xs mb-3">{loginError}</p>
          {/if}
          <button onclick={registerMode ? doRegister : doLogin} class="w-full py-2.5 rounded-lg text-white text-sm font-medium transition-opacity hover:opacity-90" style="background: var(--primary)">{registerMode ? "创建账号" : "登录"}</button>
          <button onclick={() => { showLogin = false; loginError = ""; }} class="w-full mt-2 py-2 text-xs cursor-pointer rounded-lg transition-colors" style="color: var(--content-meta)">取消</button>
        </div>
      </div>
    {/if}
  </div>

  {#if user}
    <div class="mb-6 flex gap-3">
      <label class="cursor-pointer group shrink-0" title="点击更换头像">
        <div class="relative w-9 h-9 rounded-full overflow-hidden border-2 transition-all group-hover:opacity-80" style="border-color: var(--primary)">
          {#if user.avatar_url}
            <img src={user.avatar_url} alt="" class="w-full h-full object-cover" />
          {:else}
            <div class="w-full h-full flex items-center justify-center text-white text-sm font-bold" style="background: var(--primary)">{user.username[0]?.toUpperCase() || "U"}</div>
          {/if}
          <div class="absolute inset-0 bg-black/40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
            <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"/><circle cx="12" cy="13" r="3"/></svg>
          </div>
        </div>
        <input type="file" accept="image/*" class="hidden" onchange={(e) => handleAvatarUpload(e)} disabled={uploading} />
      </label>
      <div class="flex-1">
        <textarea bind:value={content} rows="3" placeholder="写下你的想法... Markdown 图片语法和表情都支持" class="w-full px-4 py-3 rounded-xl border resize-none text-sm" style="border-color:var(--line-divider);background:var(--card-bg);color:var(--btn-content)"></textarea>

        {#if showPreview && content.trim()}
          <div class="mt-2 p-4 rounded-xl border text-sm leading-relaxed" style="border-color:var(--line-divider);background:var(--btn-regular-bg);color:var(--btn-content)">
            <div class="text-xs mb-2" style="color: var(--content-meta)">预览</div>
            {@html renderContent(content)}
          </div>
        {/if}

        <div class="flex items-center justify-between mt-2">
          <div class="flex items-center gap-1">
            <div class="relative">
              <button onclick={() => showEmoji = !showEmoji} class="w-8 h-8 rounded-lg flex items-center justify-center text-lg cursor-pointer hover:opacity-80" style="background: var(--btn-regular-bg)" title="表情">😊</button>
              {#if showEmoji}
                <div class="absolute bottom-full left-0 mb-2 p-2 rounded-xl border shadow-lg grid grid-cols-8 gap-1 z-50" style="background:var(--card-bg);border-color:var(--line-divider);max-height:200px;overflow-y:auto;width:260px">
                  {#each emojis as emoji}
                    <button onclick={() => insertEmoji(emoji)} class="w-7 h-7 flex items-center justify-center text-base rounded hover:opacity-80 cursor-pointer leading-none" style="background:var(--btn-regular-bg)">{emoji}</button>
                  {/each}
                </div>
              {/if}
            </div>
            <label class="w-8 h-8 rounded-lg flex items-center justify-center cursor-pointer hover:opacity-80 {uploading ? 'opacity-50 pointer-events-none' : ''}" style="background: var(--btn-regular-bg)" title="上传图片">
              <svg class="w-4 h-4" style="color: var(--btn-content)" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
              <input type="file" accept="image/*" class="hidden" onchange={(e) => handleImageUpload(e)} disabled={uploading} />
            </label>
            <button onclick={() => showPreview = !showPreview} class="w-8 h-8 rounded-lg flex items-center justify-center cursor-pointer hover:opacity-80 {showPreview ? 'ring-2' : ''}" style="background: var(--btn-regular-bg);color:var(--btn-content);--tw-ring-color:var(--primary)" title="预览">
              <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
            </button>
          </div>
          <button onclick={doSubmit} disabled={submitting || !content.trim()} class="px-5 py-2 rounded-lg text-white text-sm font-medium transition-opacity disabled:opacity-50 hover:opacity-90" style="background: var(--primary)">{submitting ? "提交中..." : "发表"}</button>
        </div>
      </div>
    </div>
  {/if}

  {#if loading}
    <div class="flex items-center justify-center py-12 gap-2 text-sm" style="color: var(--content-meta)">
        <span class="w-5 h-5 border-2 border-(--primary) border-t-transparent rounded-full animate-spin"></span>
        加载评论中...
      </div>
  {:else if comments.length === 0}
    <div class="text-center py-12 text-sm" style="color: var(--content-meta)">
      <svg class="w-10 h-10 mx-auto mb-2 opacity-30" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/></svg>
      <p>暂无评论，来抢沙发吧</p>
    </div>
  {:else}
    <div class="space-y-5">
      {#each comments as comment (comment.id)}
        <div class="flex gap-3">
          <div class="w-9 h-9 rounded-full shrink-0 flex items-center justify-center text-white text-sm font-bold overflow-hidden" style="background: var(--primary)">
            {#if comment.avatar_url}
              <img src={comment.avatar_url} alt="" class="w-full h-full object-cover" />
            {:else}
              {comment.username[0]?.toUpperCase() || "?"}
            {/if}
          </div>
          <div class="flex-1 min-w-0">
            <div class="flex items-center gap-2 mb-2">
              <span class="text-sm font-semibold" style="color: var(--btn-content)">{comment.username}</span>
              <span class="text-xs" style="color: var(--content-meta)">{timeAgo(comment.created_at)}</span>
              {#if user && user.id === comment.user_id}
                <button onclick={() => doDelete(comment.id)} class="ml-auto text-xs cursor-pointer" style="color: var(--content-meta)" title="删除">删除</button>
              {/if}
            </div>
            <div class="text-sm leading-relaxed" style="color: var(--btn-content)">
              {@html renderContent(comment.content)}
            </div>
          </div>
        </div>
      {/each}
    </div>
  {/if}
</div>

<style>
  .cf-turnstile { transform: scale(0.85); transform-origin: left top; margin-bottom: -8px; }
</style>
