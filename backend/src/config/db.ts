import mongoose from 'mongoose';
import dotenv from 'dotenv';

// Load environment variables from .env file
dotenv.config();

const MONGODB_URI: string = process.env.MONGO_URI || '';

const connectDB = async () => {
  try {
    await mongoose.connect(MONGODB_URI);
    console.log('MongoDB connected!');
  } catch (err) {
    console.error('MongoDB connection failed:', err);
    process.exit(1);
  }
};

export default connectDB;
