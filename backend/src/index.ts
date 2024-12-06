import dotenv from "dotenv";
import { serve } from "@hono/node-server";
import { Hono } from "hono";
import { Env } from "./types";
import auth from "./routes/auth";
import user from "./routes/user";
import scans from "./routes/scans";
import { cors } from "hono/cors";

dotenv.config();
const app = new Hono<Env>();

app.use(
	cors({
		origin: "*",
		exposeHeaders: ["X-New-Session-ExpiresAt"],
	})
);

app.route("/auth", auth);
app.route("/user", user);
app.route("/scans", scans);

const port = parseInt(process.env.PORT || "3000", 10);
console.log(`Server is running on port ${port}`);

serve({
	fetch: app.fetch,
	port,
});
