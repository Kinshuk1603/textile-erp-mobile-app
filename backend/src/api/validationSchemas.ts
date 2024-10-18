import { z } from "zod";

// Signup Validation Schema
export const userSchema = z.object({
  username: z
    .string()
    .min(1, "Username is required")
    .max(20, "Username must be at most 20 characters long"),
  email: z.string().email({ message: "Invalid email address" }),
  password: z
    .string()
    .min(6, "Password must be at least 6 characters long")
    .max(15, "Password must be at most 15 characters long")
    .regex(/[A-Z]/, "Password must contain at least one uppercase letter")
    .regex(/[a-z]/, "Password must contain at least one lowercase letter")
    .regex(/[0-9]/, "Password must contain at least one number")
    .regex(
      /[!@#\$&*~]/,
      "Password must contain at least one special character"
    ),
  role: z.string().min(1, "Role is required"),
});

export const signupSchema = userSchema; // You can use userSchema directly since it includes role validation

export const loginSchema = z.object({
  email: z
    .string()
    .email({ message: "Invalid email format" })
    .min(1, { message: "Email is required" }),
  password: z
    .string()
    .min(4, { message: "Password must be at least 4 characters" })
    .max(15, { message: "Password must not exceed 15 characters" })
    .regex(/^(?=.*[A-Z])/, { message: "At least 1 uppercase letter required" })
    .regex(/^(?=.*\d)/, { message: "At least 1 number required" })
    .regex(/^(?=.*[@$!%*?&])/, {
      message: "At least 1 special character required",
    }),
});
