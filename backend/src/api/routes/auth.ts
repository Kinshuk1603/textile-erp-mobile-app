import { Router, Request, Response } from "express";
import bcrypt from "bcryptjs";
import { loginSchema, signupSchema } from "../validationSchemas";
import { User } from "../models/User";

const router = Router();

// Sign-up route
router.post("/signup", async (req: Request, res: Response) => {
  try {
    // Validate user 
    const { username, email, password, role } = signupSchema.parse(req.body);

    // Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      res.status(400).json({ message: "User already exists" });
      return; // Return here to stop further execution
    }

    // Hash the password
    const hashedPassword = await bcrypt.hash(password, 5);

    // Create new user with isVerified set to false
    const newUser = new User({
      username, // Add username here
      email,
      password: hashedPassword,
      role,
    });
    await newUser.save();

    res.status(201).json({ message: "User created successfully" });
  } catch (error) {
    if (error instanceof Error) {
      res.status(400).json({ message: error.message });
    }
  }
});

// Login route
router.post("/login", async (req: Request, res: Response) => {
  try {
    // Validate user input
    const { email, password } = loginSchema.parse(req.body);

    const user = await User.findOne({ email });
    if (!user) {
      res.status(400).json({ message: "Invalid credentials" });
      return;
    }

    const isPasswordValid = await bcrypt.compare(password, user.password);
    if (!isPasswordValid) {
      res.status(400).json({ message: "Invalid credentials" });
      return;
    }

     // Successful login (you may want to implement JWT here)
    res.status(200).json({ message: 'Login successful' });
  } catch (error) {
    if (error instanceof Error) {
      res.status(400).json({ message: error.message });
    }
  }
});


export default router;
