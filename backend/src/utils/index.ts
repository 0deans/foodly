export const sha256HexDigest = async (data: string) => {
	const hashedData = await crypto.subtle.digest(
		"SHA-256",
		new TextEncoder().encode(data)
	);

	const hex = [...new Uint8Array(hashedData)]
		.map((b) => b.toString(16).padStart(2, "0"))
		.join("");

	return hex;
};
