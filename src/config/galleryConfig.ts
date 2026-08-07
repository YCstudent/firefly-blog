import type { GalleryConfig } from "@/types/galleryConfig";

// 相册配置
export const galleryConfig: GalleryConfig = {
	// 相册列表
	albums: [
		{
			id: "spiderman",
			name: "Spider-Man",
			description: "With great power comes great responsibility.",
			location: "New York City",
			date: "2026-08-08",
			tags: ["Spider-Man", "Marvel"],
		},
		{
			id: "elden-ring",
			name: "艾尔登法环 黑夜君临",
			description: "ELDEN RING NIGHTREIGN",
			location: "狭间之地",
			date: "2026-08-08",
			tags: ["Elden Ring", "Nightreign", "FromSoftware"],
		},
	],

	// 瀑布流最小列宽(px)，浏览器根据容器宽度自动计算列数，默认 240
	// 值越小列数越多，值越大列数越少
	columnWidth: 240,
};
