import {
	DeleteObjectCommand,
	PutObjectCommand,
	S3Client,
} from "@aws-sdk/client-s3";
import "dotenv/config";

export const s3 = new S3Client({
	endpoint: process.env.S3_ENDPOINT!,
	region: process.env.S3_REGION!,
	credentials: {
		accessKeyId: process.env.S3_ACCESS_KEY_ID!,
		secretAccessKey: process.env.S3_SECRET_ACCESS_KEY!,
	},
});

export const uploadFile = async (file: File, key: string): Promise<string> => {
	const buffer = await file.arrayBuffer();
	const putCommand = new PutObjectCommand({
		Bucket: process.env.S3_BUCKET!,
		Key: key,
		Body: new Uint8Array(buffer),
		ContentType: file.type,
		ACL: "public-read",
	});

	await s3.send(putCommand);
	const publicUrl = new URL(
		`${process.env.S3_BUCKET!}/${key!}`,
		process.env.S3_ENDPOINT!
	).toString();

	return publicUrl;
};

export const deleteFile = async (key: string) => {
	const deleteCommand = new DeleteObjectCommand({
		Bucket: process.env.S3_BUCKET!,
		Key: key,
	});

	await s3.send(deleteCommand);
};
