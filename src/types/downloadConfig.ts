export interface DownloadFile {
	name: string;
	desc?: string;
	url: string;
	size?: string;
	icon?: "pdf" | "image" | "markdown" | "code" | "archive" | "file";
	category?: string;
}

export interface DownloadConfig {
	title: string;
	description: string;
	categories: string[];
	files: DownloadFile[];
}
