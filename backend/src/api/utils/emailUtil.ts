// backend/src/utils/emailUtil.ts
import sgMail from '@sendgrid/mail';

/**
 * Sends an OTP email to the specified recipient.
 * @param {string} to - The recipient's email address.
 * @param {string} otp - The OTP to send.
 */
export async function sendOTPEmail(to: string, otp: string) {
  try {
    // Set your SendGrid API Key
    console.log('SendGrid API Key:', process.env.SENDGRID_API_KEY);
    sgMail.setApiKey(process.env.SENDGRID_API_KEY as string); // Ensure the API key is not undefined

    // Define email content
    const msg = {
      to, // Recipient's email
      from: 'kinshukrajputkr25@gmail.com', // Sender's email (must be verified in SendGrid)
      subject: 'Your OTP Code',
      html: `
        <h1>Your OTP Code</h1>
        <p>Use the following OTP code to complete your login/sign-in:</p>
        <h2>${otp}</h2>
        <p>This OTP is valid for 10 minutes.</p>
      `,
    };

    // Send the email
    await sgMail.send(msg);
    console.log('OTP email sent successfully');
  } catch (error) {
    console.error('Error sending OTP email:', error);
    throw error; // Rethrow the error for further handling
  }
}
