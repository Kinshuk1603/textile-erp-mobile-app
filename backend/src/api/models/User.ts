import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true }, // New field
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  role: { type: String, required: true }, // If you have role-based access
  createdAt: { type: Date, default: Date.now }
});

export const User = mongoose.model('User', userSchema);
