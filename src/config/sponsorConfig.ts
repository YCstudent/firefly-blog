import type { SponsorConfig } from "../types/sponsorConfig";

export const sponsorConfig: SponsorConfig = {
	title: "",
	description: "",

	// 打赏用途说明
	usage: "如果我的内容对你有帮助，欢迎请我喝杯奶茶 ☕",

	showSponsorsList: true,
	showComment: true,
	showButtonInPost: true,

	methods: [
		{
			name: "支付宝",
			icon: "fa7-brands:alipay",
			qrCode: "https://img.202886.xyz/file/1786135380870_alipay.jpg",
			link: "",
			description: "使用 支付宝 扫码打赏",
			enabled: true,
		},
		{
			name: "微信",
			icon: "fa7-brands:weixin",
			qrCode: "https://img.202886.xyz/file/1786135387863_wechat.jpg",
			link: "",
			description: "使用 微信 扫码打赏",
			enabled: true,
		},
	],

	sponsors: [],
};
