import {
	Body,
	Button,
	Container,
	Head,
	Html,
	Preview,
	Section,
	Text,
} from "@react-email/components";

interface ResetPasswordEmailProps {
	resetPasswordLink: string;
}

export const ResetPasswordEmail = ({
	resetPasswordLink,
}: ResetPasswordEmailProps) => {
	return (
		<Html>
			<Head />
			<Preview>Foodly reset your password</Preview>
			<Body style={main}>
				<Container style={container}>
					<Section style={logo}>Foodly</Section>
					<Section style={content}>
						<Text>
							Someone recently requested a password change for
							your Foodly account. If this was you, you can set a
							new password here:
						</Text>
						<Button style={button} href={resetPasswordLink}>
							Reset password
						</Button>
						<Text>
							If you didn't request a password change, you can
							safely ignore this email.
						</Text>
						<Text>
							To keep your account secure, please don't forward
							this email to anyone.
						</Text>
					</Section>
				</Container>
			</Body>
		</Html>
	);
};

ResetPasswordEmail.PreviewProps = {
	resetPasswordLink: "https://foodly.com",
} as ResetPasswordEmailProps;

export default ResetPasswordEmail;

const main: React.CSSProperties = {
	backgroundColor: "#f9f9f9",
	fontFamily: "HelveticaNeue,Helvetica,Arial,sans-serif",
};

const container: React.CSSProperties = {
	margin: "30px auto",
	maxWidth: "580px",
	backgroundColor: "#ffffff",
};

const logo: React.CSSProperties = {
	paddingTop: "20px",
	textAlign: "center",
	width: "100%",
	fontSize: "24px",
	color: "#007ee6",
	fontWeight: "bold",
};

const content: React.CSSProperties = {
	padding: "5px 20px 10px 20px",
};

const button: React.CSSProperties = {
	display: "block",
	margin: "20px auto",
	padding: "10px 20px",
	backgroundColor: "#007ee6",
	color: "#ffffff",
	textDecoration: "none",
	borderRadius: "5px",
	width: "fit-content",
};
