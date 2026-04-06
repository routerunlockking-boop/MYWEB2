import mongoose from 'mongoose';

export const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGO_URI);
    console.log('✅ MongoDB සම්බන්ධ විය');
  } catch (err) {
    console.error('❌ MongoDB සම්බන්ධ වීම අසාර්ථකයි:', err.message);
    process.exit(1);
  }
};

