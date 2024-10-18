// backend/src/utils/otpUtil.ts

/**
 * Generates a random six-digit OTP (One Time Password).
 * @returns {string} A six-digit OTP.
 */
export function generateOTP(): string {
    // Generate a random number between 100000 and 999999
    const otp = Math.floor(100000 + Math.random() * 900000).toString();
    return otp;
  }
  